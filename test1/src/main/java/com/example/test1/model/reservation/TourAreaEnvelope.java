package com.example.test1.model.reservation;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

/** TourAPI /areaCode2 응답 구조: response → (header), (body → items → item[Area...]) */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TourAreaEnvelope {
    private Resp response;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Resp {
        //header 필드 추가
        private Header header;
        private Body body;
    }

    // API 응답 코드를 받기 위한 Header 클래스
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
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Items {
        private List<Area> item;
    }
}