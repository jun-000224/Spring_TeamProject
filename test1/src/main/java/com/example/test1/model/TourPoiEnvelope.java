package com.example.test1.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

/**
 * TourAPI /areaBasedList2 (지역기반 관광정보) 응답 구조
 * (TourAreaEnvelope 참조를 제거하고 완전히 독립적인 클래스로 수정)
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TourPoiEnvelope {

    //최상위 'response' 필드
    private Resp response;

    //'response' 내부에 'header'와 'body'가 있는 구조
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Resp {
        private Header header; // (TourAreaEnvelope 참조 대신 내부 Header 사용)
        private Body body;
    }

    //'header'를 독립적으로 정의
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Header {
        private String resultCode;
        private String resultMsg;
    }

    //'body' 정의
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Body {
        private Items items;
        private int numOfRows;
        private int pageNo;
        private int totalCount;
    }

    //'items' (item 배열 래퍼) 정의
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Items {
        private List<PoiItem> item;
    }

    /**
     * POI(관광지) 개별 항목
     */
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class PoiItem {
        private Long contentid;
        private Integer contenttypeid;
        private String title;
        private String addr1;
        private String mapx; // 경도
        private String mapy; // 위도
    }
}