package com.example.test1.controller;

import com.example.test1.dao.RecommendationService;
// import com.example.test1.model.Attr; // [ ⭐ 1. Attr 임포트 삭제 ]
import com.example.test1.model.PoiRecommendation; // [ ⭐ 2. PoiRecommendation 임포트 추가 ]
import com.example.test1.model.RecommendationRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recommend")
public class RecommendationController {

    private final RecommendationService recommendationService;

    @PostMapping("/generate")
    //반환 타입을 List<PoiRecommendation>로
    public ResponseEntity<List<PoiRecommendation>> generateRecommendations(
            @RequestBody RecommendationRequest request // [DTO]
    ) {
        //변수 타입을 List<PoiRecommendation>으로 수정
        List<PoiRecommendation> resultRecommendations = recommendationService.generateAndSaveAttributes(request);
        
        // 결과 반환
        return ResponseEntity.ok(resultRecommendations);
    }
}