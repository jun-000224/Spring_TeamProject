package com.example.test1.model; // (패키지명은 본인 것에 맞게 확인)

import lombok.Data;
import java.util.List;
import java.util.Map; // Map도 import해야 합니다.

@Data
public class RecommendationRequest {
    
    // --- 기존 필드 ---
    private List<String> themes;
    private Integer headCount;
    private Integer budget;
    private String startDate;
    private String endDate;
    private Map<String, Integer> budgetWeights;
    private List<RegionDto> regions;
   
    @Data
    public static class RegionDto {
        private String sidoCode;
        private String sigunguCode;
        private String name; 
    }
}