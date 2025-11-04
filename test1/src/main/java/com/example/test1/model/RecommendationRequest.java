package com.example.test1.model;

import lombok.Data;
import java.util.List;
import java.util.Map; 

@Data
public class RecommendationRequest {
    
    private List<String> themes;
    private Integer headCount;
    private Long budget; 
    private String startDate;
    private String endDate;
    private Map<String, Integer> budgetWeights;

    // 멀티 지역 선택용
    private List<RegionDto> regions;

    @Data
    public static class RegionDto {
        private String sidoCode;
        private String sigunguCode;
        private String name; 
    }
}