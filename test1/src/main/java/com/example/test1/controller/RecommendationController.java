package com.example.test1.controller;

import com.example.test1.dao.RecommendationService;
import com.example.test1.model.Attr;
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
    public ResponseEntity<List<Attr>> generateRecommendations(
            @RequestBody RecommendationRequest request // [DTO]
    ) {
        // Service 호출
        List<Attr> resultAttributes = recommendationService.generateAndSaveAttributes(request);
        
        // 결과 반환
        return ResponseEntity.ok(resultAttributes);
    }
}