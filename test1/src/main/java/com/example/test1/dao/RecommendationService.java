package com.example.test1.dao;

import com.example.test1.model.Attr;
import com.example.test1.model.PoiRecommendation;
import com.example.test1.model.RecommendationRequest;
import com.example.test1.model.TourPoiEnvelope;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecommendationService {

    private final AttrRepository attrRepository;
    private final TourAreaService tourAreaService; 

    @Transactional
    public List<PoiRecommendation> generateAndSaveAttributes(RecommendationRequest request) {
        
        log.info("추천 요청 받음. (테마: {}, 지역: {}, 날짜: {}~{})", 
            request.getThemes(), request.getRegions(), request.getStartDate(), request.getEndDate());

        if (request.getRegions() == null || request.getRegions().isEmpty()) {
             log.warn("선택된 지역이 없습니다. 빈 목록을 반환합니다.");
            return Collections.emptyList();
        }
        
        // [ 1. 1차 POI 목록 조회 (멀티 지역) ]
        List<TourPoiEnvelope.PoiItem> allPois = new ArrayList<>();
        for (RecommendationRequest.RegionDto region : request.getRegions()) {
            if (region.getSidoCode() == null || region.getSidoCode().isBlank()) continue;
            allPois.addAll(tourAreaService.listPoisByArea(region.getSidoCode(), region.getSigunguCode()));
        }
        
        if (allPois.isEmpty()) {
            log.warn("TourAPI로부터 조회된 POI가 없습니다.");
            return Collections.emptyList();
        }

        // [ 2. ATTR 조회 및 생성 ]
        List<Long> requestedContentIds = allPois.stream()
                                        .map(TourPoiEnvelope.PoiItem::getContentid)
                                        .distinct()
                                        .collect(Collectors.toList());
        
        log.info("TourAPI에서 총 {}개의 고유 POI 목록을 받았습니다.", requestedContentIds.size());
        
        List<Attr> existingAttrs = attrRepository.findByContentIdIn(requestedContentIds);
        Map<Long, Attr> attrMap = existingAttrs.stream()
                                             .collect(Collectors.toMap(Attr::getContentId, Function.identity()));
        
        List<Attr> newAttrsToSave = new ArrayList<>();
        for (TourPoiEnvelope.PoiItem poi : allPois) { 
            if (!attrMap.containsKey(poi.getContentid())) {
                Attr newAttr = new Attr(poi.getContentid(), poi.getContenttypeid()); 
                newAttrsToSave.add(newAttr);
                attrMap.put(newAttr.getContentId(), newAttr);
            }
        }
        if (!newAttrsToSave.isEmpty()) {
            attrRepository.saveAll(newAttrsToSave);
            log.info("신규 POI {}개를 ATTR 테이블에 INSERT 했습니다.", newAttrsToSave.size());
        }

        // [ 3. 점수 계산 ]
        List<String> selectedThemes = request.getThemes();
        List<PoiRecommendation> recommendations = new ArrayList<>();
        
        for (TourPoiEnvelope.PoiItem poi : allPois) { 
            Attr attr = attrMap.get(poi.getContentid());
            if (attr == null) continue; 
            PoiRecommendation rec = new PoiRecommendation(poi, attr);
            
            double totalScore = 0;
            if (selectedThemes != null && !selectedThemes.isEmpty()) {
                for (String theme : selectedThemes) {
                    totalScore += getScoreForTheme(attr, theme);
                }
                rec.setScore(Math.round((totalScore / selectedThemes.size()) * 100) / 100.0);
            } else {
                 rec.setScore(0); // 테마가 없으면 0점
            }
            recommendations.add(rec);
        }
        
        // 중복 POI 제거
        List<PoiRecommendation> finalRecommendations = new ArrayList<>(
            recommendations.stream()
                .collect(Collectors.toMap(
                    PoiRecommendation::getContentId,
                    Function.identity(),
                    (existing, replacement) -> existing
                ))
                .values()
        );

        finalRecommendations.sort((r1, r2) -> Double.compare(r2.getScore(), r1.getScore()));
        log.info("총 {}개의 POI 점수 계산 및 정렬 완료.", finalRecommendations.size());

        return finalRecommendations;
    }

    private double getScoreForTheme(Attr attr, String themeCode) {
        if (attr == null || themeCode == null) return 0;

        switch (themeCode) {
            case "FAMILY":    return attr.getFamily();
            case "LUXURY":    return attr.getLuxury();
            case "UNIQUE":    return attr.getUnique();
            case "ADVENTURE": return attr.getAdventure();
            case "BUDGET":    return attr.getBudget();
            case "FRIEND":    return attr.getFriend();
            case "COUPLE":    return attr.getCouple();
            case "HEALING":   return attr.getHealing();
            case "QUIET":     return attr.getQuiet();
            default:
                return 0;
        }
    }
}