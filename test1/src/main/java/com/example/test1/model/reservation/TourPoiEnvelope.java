package com.example.test1.model.reservation;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TourPoiEnvelope {

    private Resp response;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Resp {
        private Header header;
        private Body body;
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Header {
        private String resultCode;
        private String resultMsg;
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

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class PoiItem {
        private Long contentid;
        private Integer contenttypeid;
        private String title;
        private String addr1;
        private String mapx;
        private String mapy;
        private String firstimage;
        private String firstimage2;
        
        private String areacode;
        private String sigungucode;
    }
}