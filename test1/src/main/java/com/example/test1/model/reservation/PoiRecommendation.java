package com.example.test1.model.reservation;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PoiRecommendation {

    private Long contentId;
    private Integer typeId;
    private String title;
    private String mapx;
    private String mapy;
    private double score;
    private String firstimage;
    private String firstimage2;
    private String areaCode;    // 프론트에서 사용할 필드 (camelCase)
    private String sigunguCode; // 프론트에서 사용할 필드 (camelCase)

    public PoiRecommendation(TourPoiEnvelope.PoiItem poi, Attr attr) {
        this.contentId = poi.getContentid();
        this.typeId = poi.getContenttypeid();
        this.title = poi.getTitle();
        this.mapx = poi.getMapx();
        this.mapy = poi.getMapy();
        this.score = 0;
        
        this.firstimage = poi.getFirstimage();
        this.firstimage2 = poi.getFirstimage2();
        
        // [수정] poi.getAreacode() (소문자) 호출
        this.areaCode = poi.getAreacode();
        this.sigunguCode = poi.getSigungucode();
    }
}