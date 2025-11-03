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
        
        // 로그에서 regions를 확인하도록 변경
        log.info("추천 요청 받음. (테마: {}, 지역: {}, 날짜: {}~{})", 
            request.getThemes(), request.getRegions(), request.getStartDate(), request.getEndDate());

        // 지역 파라미터가 없는 경우
        if (request.getRegions() == null || request.getRegions().isEmpty()) {
             log.warn("선택된 지역이 없습니다. 빈 목록을 반환합니다.");
            return Collections.emptyList();
        }

        // TourAPI 호출 (멀티 지역)
        List<TourPoiEnvelope.PoiItem> allPois = new ArrayList<>();
        
        // 프론트에서 받은 모든 지역을 순회하며 API 호출
        for (RecommendationRequest.RegionDto region : request.getRegions()) {
            if (region.getSidoCode() == null || region.getSidoCode().isBlank()) {
                continue;
            }
            // TourAreaService는 싱글 지역만 호출하므로, 반복문 안에서 호출
            List<TourPoiEnvelope.PoiItem> poiItems = tourAreaService.listPoisByArea(
                region.getSidoCode(), 
                region.getSigunguCode() // null일 수도 있음 (정상)
            );
            allPois.addAll(poiItems);
        }

        if (allPois.isEmpty()) {
            log.warn("TourAPI로부터 조회된 POI가 없습니다.");
            return Collections.emptyList();
        }

        List<Long> requestedContentIds = allPois.stream()
                                            .map(TourPoiEnvelope.PoiItem::getContentid)
                                            .distinct() // 여러 지역 호출 시 중복 POI가 있을 수 있으므로 중복 제거
                                            .collect(Collectors.toList());
        log.info("TourAPI에서 총 {}개의 고유 POI 목록을 받았습니다.", requestedContentIds.size());

        
        //On-Demand 로직: ATTR 테이블 조회 및 신규 생성/저장
        
        // 2-1. 이미 DB에 저장된 Attr 조회
        List<Attr> existingAttrs = attrRepository.findByContentIdIn(requestedContentIds);
        Map<Long, Attr> attrMap = existingAttrs.stream()
                                             .collect(Collectors.toMap(Attr::getContentId, Function.identity()));
        
        // 2-2. DB에 없는 POI 찾기 (신규 Attr 생성)
        List<Attr> newAttrsToSave = new ArrayList<>();
        
        for (TourPoiEnvelope.PoiItem poi : allPois) {
            // 중복된 POI(contentId)가 여러 지역 검색 시 나올 수 있으므로, attrMap 기준으로 체크
            if (!attrMap.containsKey(poi.getContentid())) {
                Attr newAttr = new Attr(poi.getContentid(), poi.getContenttypeid()); 
                newAttrsToSave.add(newAttr);
                attrMap.put(newAttr.getContentId(), newAttr); // 새로 만든 것도 맵에 추가 (중복 생성 방지)
            }
        }
        
        // 2-3. 신규 Attr 저장
        if (!newAttrsToSave.isEmpty()) {
            attrRepository.saveAll(newAttrsToSave);
            log.info("신규 POI {}개를 ATTR 테이블에 INSERT 했습니다.", newAttrsToSave.size());
        }

        
        // [ 3. (핵심) 점수 계산 및 최종 목록 생성 ]
        List<String> selectedThemes = request.getThemes();
        if (selectedThemes == null || selectedThemes.isEmpty()) {
            log.warn("선택된 테마가 없어 점수 계산을 생략합니다.");
            return allPois.stream()
                    .filter(poi -> attrMap.containsKey(poi.getContentid())) // Attr이 있는 것만
                    .map(poi -> new PoiRecommendation(poi, attrMap.get(poi.getContentid())))
                    .distinct() // DTO 레벨에서 중복 제거 (PoiRecommendation에 equals/hashCode 필요)
                    .collect(Collectors.toList());
        }

        List<PoiRecommendation> recommendations = new ArrayList<>();
        
        for (TourPoiEnvelope.PoiItem poi : allPois) {
            Attr attr = attrMap.get(poi.getContentid());
            if (attr == null) continue; 

            PoiRecommendation rec = new PoiRecommendation(poi, attr);

            double totalScore = 0;
            for (String theme : selectedThemes) {
                totalScore += getScoreForTheme(attr, theme);
            }
            rec.setScore(Math.round((totalScore / selectedThemes.size()) * 100) / 100.0); 
            
            recommendations.add(rec);
        }
        
        // 중복 제거: contentId가 동일한 경우, 점수가 더 높은 것을 선택 (혹은 그냥 하나만 선택)
        List<PoiRecommendation> finalRecommendations = new ArrayList<>(
            recommendations.stream()
                .collect(Collectors.toMap(
                    PoiRecommendation::getContentId, // Key: contentId
                    Function.identity(),             // Value: DTO 자체
                    (existing, replacement) -> existing // 중복 시 기존 값(existing) 유지
                ))
                .values()
        );


        // [ 4. 점수(score) 기준으로 내림차순 정렬 ]
        finalRecommendations.sort((r1, r2) -> Double.compare(r2.getScore(), r1.getScore()));

        log.info("총 {}개의 POI 점수 계산 및 정렬 완료.", finalRecommendations.size());

        return finalRecommendations;
    }

    /**
     * 9개 테마(String)를 Attr 객체의 점수(double)로 매핑합니다.
     */
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
                return 0; // 모르는 테마는 0점 처리
        }
    }
}