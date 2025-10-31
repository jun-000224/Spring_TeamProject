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
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecommendationService {

    private final AttrRepository attrRepository;
    private final TourAreaService tourAreaService; 

    @Transactional
    // [ ⭐ 3. 반환 타입 수정 ]
    // ATTR이 아닌 최종 추천 DTO (PoiRecommendation)를 반환합니다.
    public List<PoiRecommendation> generateAndSaveAttributes(RecommendationRequest request) {
        
        log.info("추천 요청 받음. (테마: {}, 지역: {}, 날짜: {}~{})", 
            request.getThemes(), request.getAreaCode(), request.getStartDate(), request.getEndDate());

        // [ 1. TourAPI 호출 ]
        List<TourPoiEnvelope.PoiItem> poiItems = tourAreaService.listPoisByArea(
            request.getAreaCode(), 
            request.getSigunguCode()
        );

        if (poiItems.isEmpty()) {
            log.warn("TourAPI로부터 조회된 POI가 없습니다.");
            return Collections.emptyList();
        }

        List<Long> requestedContentIds = poiItems.stream()
                                            .map(TourPoiEnvelope.PoiItem::getContentid)
                                            .collect(Collectors.toList());
        log.info("TourAPI에서 총 {}개의 POI 목록을 받았습니다.", requestedContentIds.size());

        
        // [ 2. On-Demand 로직: ATTR 테이블 조회 및 신규 생성/저장 ]
        
        // 2-1. 이미 DB에 저장된 Attr 조회
        List<Attr> existingAttrs = attrRepository.findByContentIdIn(requestedContentIds);
        Map<Long, Attr> attrMap = existingAttrs.stream()
                                             .collect(Collectors.toMap(Attr::getContentId, Function.identity()));
        
        // 2-2. DB에 없는 POI 찾기 (신규 Attr 생성)
        List<Attr> newAttrsToSave = new ArrayList<>();
        for (TourPoiEnvelope.PoiItem poi : poiItems) {
            if (!attrMap.containsKey(poi.getContentid())) {
                // [ ⭐ 4. 수정 ]
                // 1단계에서 수정한 Attr.java의 새 생성자 호출
                Attr newAttr = new Attr(poi.getContentid(), poi.getContenttypeid()); 
                newAttrsToSave.add(newAttr);
                attrMap.put(newAttr.getContentId(), newAttr); // 새로 만든 것도 맵에 추가
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
            return poiItems.stream()
                    .map(poi -> new PoiRecommendation(poi, attrMap.get(poi.getContentid())))
                    .collect(Collectors.toList());
        }

        List<PoiRecommendation> recommendations = new ArrayList<>();
        
        for (TourPoiEnvelope.PoiItem poi : poiItems) {
            Attr attr = attrMap.get(poi.getContentid());
            if (attr == null) continue; 

            PoiRecommendation rec = new PoiRecommendation(poi, attr);

            double totalScore = 0;
            for (String theme : selectedThemes) {
                // [ ⭐ 5. 수정 ]
                // 9개 테마를 매핑하는 헬퍼 메소드 호출
                totalScore += getScoreForTheme(attr, theme);
            }
            rec.setScore(Math.round((totalScore / selectedThemes.size()) * 100) / 100.0); 
            
            recommendations.add(rec);
        }

        // [ 4. 점수(score) 기준으로 내림차순 정렬 ]
        recommendations.sort((r1, r2) -> Double.compare(r2.getScore(), r1.getScore()));

        log.info("총 {}개의 POI 점수 계산 및 정렬 완료.", recommendations.size());

        return recommendations;
    }

    /**
     * [ ⭐ 6. (핵심 수정) ]
     * 9개 테마(String)를 Attr 객체의 점수(double)로 매핑합니다.
     */
    private double getScoreForTheme(Attr attr, String themeCode) {
        if (attr == null || themeCode == null) return 0;

        switch (themeCode) {
            // (프론트 themeOptions의 code값과 Attr 필드명 일치)
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