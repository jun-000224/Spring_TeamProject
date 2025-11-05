package com.example.test1.model.reservation; // (패키지명은 본인 것에 맞게 확인)

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import java.util.List;

/**
 * TourAPI /detailInfo (반복정보) 응답 (숙소용, contentTypeId=32)
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class TourRoomInfoEnvelope {

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
        // TourAPI는 결과가 1개면 객체, 여러개면 배열을 반환합니다.
        // 이 문제를 해결하려면 List<RoomItem> 대신 'TourDetailItem' 같은 래퍼 클래스가 필요할 수 있으나,
        // 일단 List로 시도합니다. (오류 발생 시 이 부분을 수정해야 함)
        private List<RoomItem> item;
    }

    /**
     * 숙소 객실(Room) 항목
     */
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class RoomItem {
        private String roomprice; // 객실 1박 기본요금
        private String roomoffseasonweekdays; // 비수기 주중
        private String roomoffseasonweekend; // 비수기 주말
    }
}