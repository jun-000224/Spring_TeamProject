package com.example.test1.model;

import lombok.Data;
import lombok.NoArgsConstructor;

// 프론트엔드 지도 표시에 필요한 최종 정보를 담는 DTO
@Data
@NoArgsConstructor
public class PoiRecommendation {

    private Long contentId;
    private Integer typeId;
    private String title;   // 장소명 (e.g., "경복궁")
    
    // TourAPI는 좌표를 String으로 주므로, String으로 받습니다.
    private String mapx; // 경도 (Longitude)
    private String mapy; // 위도 (Latitude)

    private double score; // [핵심] 테마 기반 가중 평균 점수

    // TourPoiEnvelope.PoiItem과 Attr 객체를 조합하기 위한 생성자
    public PoiRecommendation(TourPoiEnvelope.PoiItem poi, Attr attr) {
        this.contentId = poi.getContentid();
        this.typeId = poi.getContenttypeid();
        this.title = poi.getTitle();
        this.mapx = poi.getMapx();
        this.mapy = poi.getMapy();
        this.score = 0; // 점수는 서비스에서 별도 계산 후 세팅
    }
}