package com.example.test1.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/api/tour")
public class TourApiProxyController {

    @Value("${tourapi.service-key}")
    private String serviceKey;

    @Value("${tourapi.base-url}")
    private String baseUrl;

    private final RestTemplate rt = new RestTemplate();

    // 시/도 목록
    @GetMapping("/areas")
    public ResponseEntity<String> getAreas(
            @RequestParam(defaultValue = "json") String _type,
            @RequestParam(defaultValue = "50") String numOfRows,
            @RequestParam(defaultValue = "1") String pageNo
    ) {
        try {
            // 서비스 키는 항상 인코딩 (KorService2 키에도 특수문자 포함)
            

            // [최종 수정] KorService2에 맞게 "/areaCode1" -> "/areaCode" 변경
            String url = baseUrl + "/areaCode" 
                    + "?serviceKey=" + serviceKey
                    + "&MobileOS=ETC"
                    + "&MobileApp=Ready"
                    + "&_type=" + _type
                    + "&numOfRows=" + numOfRows
                    + "&pageNo=" + pageNo;

            return ResponseEntity.ok(rt.getForObject(url, String.class));
            
        } catch (Exception e) {
            // 오류 발생 시 서버 로그에 기록하고 500 에러 반환
            System.err.println("Tour API (areas) 호출 실패: " + e.getMessage());
            return ResponseEntity.internalServerError().body("API 호출 중 오류 발생: " + e.getMessage());
        }
    }

    
    
    // 시/군/구 목록
    @GetMapping("/sigungu")
    public ResponseEntity<String> getSigungu(
            @RequestParam String areaCode,
            @RequestParam(defaultValue = "json") String _type,
            @RequestParam(defaultValue = "50") String numOfRows,
            @RequestParam(defaultValue = "1") String pageNo
    ) {
        try {
            // 서비스 키는 항상 인코딩
            String encodedServiceKey = URLEncoder.encode(serviceKey, StandardCharsets.UTF_8);

            // [최종 수정] KorService2에 맞게 "/areaCode1" -> "/areaCode" 변경
            String url = baseUrl + "/areaCode"
                    + "?serviceKey=" + encodedServiceKey
                    + "&MobileOS=ETC"
                    + "&MobileApp=Ready"
                    + "&areaCode=" + URLEncoder.encode(areaCode, StandardCharsets.UTF_8)
                    + "&_type=" + _type
                    + "&numOfRows=" + numOfRows
                    + "&pageNo=" + pageNo;

            return ResponseEntity.ok(rt.getForObject(url, String.class));
            
        } catch (Exception e) {
            // 오류 발생 시 서버 로그에 기록하고 500 에러 반환
            System.err.println("Tour API (sigungu) 호출 실패: " + e.getMessage());
            return ResponseEntity.internalServerError().body("API 호출 중 오류 발생: " + e.getMessage());
        }
    }
}