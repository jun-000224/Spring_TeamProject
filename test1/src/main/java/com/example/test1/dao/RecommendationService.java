package com.example.test1.dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.test1.model.Attr;
import com.example.test1.model.RecommendationRequest;
import com.example.test1.model.TourPoiEnvelope; // [ ⭐ 1. 임포트 ]

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecommendationService {

    private final AttrRepository attrRepository;
    private final TourAreaService tourAreaService; // [ ⭐ 2. TourAreaService 주입 ]

    @Transactional
    public List<Attr> generateAndSaveAttributes(RecommendationRequest request) {
        
        log.info("추천 요청 받음. (테마: {}, 지역: {})", request.getThemes(), request.getAreaCode());

        // [ ⭐ 3. (수정) 실제 TourAPI 호출로 변경 ]
        // 임시 POI 목록(simulatedPoiMap) 삭제
        
        // 프론트에서 받은 지역 코드로 TourAPI 서비스 호출
        List<TourPoiEnvelope.PoiItem> poiItems = tourAreaService.listPoisByArea(
            request.getAreaCode(), 
            request.getSigunguCode()
        );

        if (poiItems.isEmpty()) {
            log.warn("TourAPI로부터 조회된 POI가 없습니다. ATTR 저장을 생략합니다.");
            return Collections.emptyList(); // 빈 목록 반환
        }

        // API 결과(PoiItem 리스트)를 Map<ContentId, TypeId>로 변환
        Map<Long, Integer> poiMap = poiItems.stream()
                .collect(Collectors.toMap(
                        TourPoiEnvelope.PoiItem::getContentid,
                        TourPoiEnvelope.PoiItem::getContenttypeid
                ));
        
        List<Long> requestedContentIds = new ArrayList<>(poiMap.keySet());
        log.info("TourAPI에서 총 {}개의 POI 목록을 받았습니다.", requestedContentIds.size());


        //ATTR 테이블에서 이미 저장된 속성값 조회 
        List<Attr> existingAttrs = attrRepository.findByContentIdIn(requestedContentIds);
        
        Set<Long> existingIds = existingAttrs.stream()
                                             .map(Attr::getContentId)
                                             .collect(Collectors.toSet());
        log.info("ATTR DB 조회: 요청 {}개 중 {}개는 이미 저장되어 있음.", requestedContentIds.size(), existingIds.size());

        // DB에 없는 POI만 찾아서 새로 생성
        List<Attr> newAttrsToSave = new ArrayList<>();
        
        for (Long contentId : requestedContentIds) {
            if (!existingIds.contains(contentId)) {
                // [ ⭐ 4. (수정) poiMap에서 TypeId 가져오기 ]
                Integer typeId = poiMap.get(contentId); 
                
                Attr newAttr = new Attr(contentId, typeId); 
                newAttrsToSave.add(newAttr);
            }
        }
        
        // 새로 생성된 POI 속성값만 DB에 저장(INSERT)
        if (!newAttrsToSave.isEmpty()) {
            attrRepository.saveAll(newAttrsToSave);
            log.info("신규 POI {}개를 ATTR 테이블에 INSERT 했습니다.", newAttrsToSave.size());
        }

        //프론트로 결과 반환
        List<Attr> finalResult = new ArrayList<>(existingAttrs);
        finalResult.addAll(newAttrsToSave);
        
        return finalResult;
    }
}