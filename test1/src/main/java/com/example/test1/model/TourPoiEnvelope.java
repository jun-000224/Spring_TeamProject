package com.example.test1.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

/**
 * TourAPI /areaBasedList1 (지역기반 관광정보) 응답 구조
 * response → (header), (body → items → item[PoiItem...])
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TourPoiEnvelope {
    private Resp response;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Resp {
        private TourAreaEnvelope.Header header; // TourAreaEnvelope의 Header 재사용
        private Body body;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Body {
        private Items items;
        private int numOfRows;
        private int pageNo;
        private int totalCount;
    }

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
        private Long contentid;     // [핵심] 콘텐츠 ID
        private Integer contenttypeid; // [핵심] 콘텐츠 타입 ID (12, 32, 39 등)
        private String title;
        private String addr1;
        // (필요한 다른 필드가 있다면 여기에 추가)
    }
}