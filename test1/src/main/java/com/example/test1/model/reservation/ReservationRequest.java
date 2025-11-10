package com.example.test1.model.reservation; // <<<<<<< 패키지 경로 수정 완료

import lombok.Data;
import java.util.List;
import java.util.Map;

@Data
public class ReservationRequest {

    private List<String> themes;
    private Integer headCount;
    private Long budget;
    private String startDate;
    private String endDate;
    private Map<String, Integer> budgetWeights;
    private List<RegionDto> regions;
    private Map<String, List<PoiDto>> itinerary;
    private String desecript;

    @Data
    public static class RegionDto {
        private String sidoCode;
        private String sigunguCode;
        private String name;
    }

    @Data
    public static class PoiDto {
        private Long contentId;
        private Integer typeId;
        private String title;
        private String mapx;
        private String mapy;
        private Integer price;

    }
}