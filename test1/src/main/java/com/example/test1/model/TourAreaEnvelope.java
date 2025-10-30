package com.example.test1.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

/** TourAPI /areaCode2 응답 구조: response → body → items → item[Area...] */
@Data @JsonIgnoreProperties(ignoreUnknown = true)
public class TourAreaEnvelope {
    private Resp response;

    @Data @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Resp {
        private Body body;
    }

    @Data @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Body {
        private Items items;
    }

    @Data @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Items {
        private List<Area> item;
    }
}
