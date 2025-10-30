package com.example.test1.controller;

import com.example.test1.model.Area;
import com.example.test1.dao.TourAreaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/areas")
public class TourAreaController {

    private final TourAreaService service;

    /** 시/도 */
    @GetMapping("/sido")
    public ResponseEntity<List<Area>> sido() {
        return ResponseEntity.ok(service.listSido());
    }

    /** 시/군/구 (예: /api/areas/sigungu?areaCode=1) */
    @GetMapping("/sigungu")
    public ResponseEntity<List<Area>> sigungu(@RequestParam String areaCode) {
        return ResponseEntity.ok(service.listSigungu(areaCode));
    }
}
