package com.example.test1.controller; 

import com.example.test1.dao.RecommendationService;
import com.example.test1.dao.TourAreaService;
import com.example.test1.model.reservation.PoiRecommendation;
import com.example.test1.model.reservation.RecommendationRequest;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.DayOfWeek; 
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map; 

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recommend")
public class RecommendationController {

    private final RecommendationService recommendationService;
    private final TourAreaService tourAreaService; 

    @PostMapping("/generate")
    public List<PoiRecommendation> generateRecommendations(@RequestBody RecommendationRequest request) {
        // (기존 '코스 생성' 로직은 그대로 사용)
        return recommendationService.generateAndSaveAttributes(request);
    }

    // 클릭 시 가격 조회를 위한 API
    @GetMapping("/getPrice")
    public ResponseEntity<Map<String, Integer>> getPrice(
            @RequestParam("contentId") String contentId,
            @RequestParam("typeId") Integer typeId,
            @RequestParam(value = "startDate", required = false) String startDateStr) {
        
        // 1. 주중/주말 판단
        boolean isWeekend = false;
        if (startDateStr != null && !startDateStr.isBlank()) {
            try {
                LocalDate date = LocalDate.parse(startDateStr);
                DayOfWeek dayOfWeek = date.getDayOfWeek();
                isWeekend = (dayOfWeek == DayOfWeek.FRIDAY || dayOfWeek == DayOfWeek.SATURDAY);
            } catch (Exception e) {
                // 날짜 파싱 실패 시 주중으로 간주
            }
        }
        
        // TourAreaService의 가격 조회 메소드 호출
        // getPoiPrice 메소드를 사용
        int price = tourAreaService.getPoiPrice(contentId, typeId, isWeekend);
        
        // 3. JSON으로 가격 반환 (e.g., { "price": 15000 })
        return ResponseEntity.ok(Collections.singletonMap("price", price));
    }
}