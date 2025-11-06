package com.example.test1.model.reservation; // <<<<<<< 패키지 경로 수정 완료

import lombok.Data;
import java.util.List;
import java.util.Map;

@Data
public class ReservationRequest {

    // [Step 1] 기존 코스 생성 요청 (RecommendationRequest)의 모든 필드를 포함
    private List<String> themes;
    private Integer headCount;
    private Long budget;
    private String startDate;
    private String endDate;
    private Map<String, Integer> budgetWeights;
    private List<RegionDto> regions;

    // [Step 2] DB 저장에 필요한 최종 일정 목록 필드 추가 (핵심)
    private Map<String, List<PoiDto>> itinerary;

    // 내부 DTO는 ReservationRequest 파일 내부에 유지
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