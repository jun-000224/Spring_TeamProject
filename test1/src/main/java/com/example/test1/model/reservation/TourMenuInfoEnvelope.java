package com.example.test1.model.reservation; // (패키지명은 본인 것에 맞게 확인)

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

/**
 * TourAPI /detailInfo (반복정보) 응답 (식당용, contentTypeId=39)
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TourMenuInfoEnvelope {

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
    }

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Items {
        private List<MenuItem> item;
    }

    /**
     * 식당 메뉴(Menu) 항목
     */
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class MenuItem {
        private String menuname;  // 메뉴 이름
        private String menuprice; // 메뉴 가격
    }
}