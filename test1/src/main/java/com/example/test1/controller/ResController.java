package com.example.test1.controller;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.Reservation; 
import com.example.test1.model.reservation.ReservationRequest; 
import com.example.test1.dao.ResService;
import com.fasterxml.jackson.databind.ObjectMapper; 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class ResController {

    @Autowired
    private ResService resService;
    
    private final ObjectMapper objectMapper = new ObjectMapper(); 

    @Value("${kakao_javascript_key}")
    private String kakaoAppKey; 

    // --- Public Mapping Methods ---

    @PostMapping("/api/reservation/save")
    @ResponseBody
    public ResponseEntity<?> saveReservation(@RequestBody ReservationRequest request) {
        try {
            Reservation reservation = createReservation(request);
            
            reservation.setUserId("999"); 
            Long calculatedPrice = calculateTotalPrice(request); 
            reservation.setPrice(String.valueOf(calculatedPrice)); 
            setAreaNumFromRequest(reservation, request);
            setThemNumFromRequest(reservation, request);

            // 🛑 [수정] 예산 할당량(%) 필드 설정
            setBudgetWeights(reservation, request);
            
            if (reservation.getPackname() == null) { 
                reservation.setPackname("임시 패키지명");
            }
            
            List<Poi> pois = createPoiList(request);
            
            Long resNum = resService.saveNewReservation(reservation, pois);
            
            return ResponseEntity.ok(Map.of("resNum", resNum, "message", "일정 저장 성공"));

        } catch (Exception e) {
            System.err.println("예약 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(Map.of("message", "일정 저장 실패", "error", e.getMessage()));
        }
    }
    
    @GetMapping("/reservation-view.do")
    public String reservationView(@RequestParam("resNum") Long resNum, Model model) {
        
        Reservation reservationDetails = resService.getReservationDetails(resNum);
        List<Poi> pois = resService.getPoisByResNum(resNum);

        model.addAttribute("kakaoAppKey", kakaoAppKey); 
        
        try {
            reservationDetails.setPois(pois); 
            
            String reservationJson = objectMapper.writeValueAsString(reservationDetails);
            model.addAttribute("reservationJson", reservationJson);
            
            String poisJson = objectMapper.writeValueAsString(pois);
            model.addAttribute("poiListJson", poisJson);

        } catch (Exception e) {
            System.err.println("JSON 변환 실패: " + e.getMessage());
            model.addAttribute("reservationJson", "{}");
            model.addAttribute("poiListJson", "[]");
        }
        
        return "reservation-view"; 
    }

    // --- Private Helper Methods (전체 구현부) ---

    // 🛑 [수정] 예산 할당량(%) 설정 메서드 - String.valueOf() 제거! Float을 직접 전달합니다.
    private void setBudgetWeights(Reservation reservation, ReservationRequest request) {
        Map<String, Integer> weights = request.getBudgetWeights();
        if (weights == null) return;
        
        // 🛑 [핵심 수정] Float 객체를 반환하여 setEtcBudget(Float) 메서드 요구사항 충족
        reservation.setEtcBudget(weights.getOrDefault("etc", 0).floatValue());
        reservation.setAccomBudget(weights.getOrDefault("accom", 0).floatValue());
        reservation.setFoodBudget(weights.getOrDefault("food", 0).floatValue());
        reservation.setActBudget(weights.getOrDefault("act", 0).floatValue());
    }

    private Long calculateTotalPrice(ReservationRequest request) {
        return request.getItinerary().values().stream()
                .flatMap(List::stream)
                .mapToLong(dto -> (dto.getPrice() != null) ? dto.getPrice().longValue() : 0L)
                .sum();
    }

    private void setThemNumFromRequest(Reservation reservation, ReservationRequest request) {
        if (request.getThemes() != null && !request.getThemes().isEmpty()) {
            String themesString = String.join(",", request.getThemes());
            reservation.setThemNum(themesString); 
        } else {
            reservation.setThemNum("DEFAULT"); 
        }
    }

    private void setAreaNumFromRequest(Reservation reservation, ReservationRequest request) {
        if (request.getRegions() != null && !request.getRegions().isEmpty()) {
            try {
                String sidoCode = request.getRegions().get(0).getSidoCode();
                reservation.setAreaNum(sidoCode); 
            } catch (Exception e) {
                reservation.setAreaNum("99"); 
            }
        } else {
            reservation.setAreaNum("99"); 
        }
    }

    private Reservation createReservation(ReservationRequest request) {
        Reservation list = new Reservation();
        list.setStartDate(request.getStartDate());
        list.setEndDate(request.getEndDate());
        return list;
    }

    private List<Poi> createPoiList(ReservationRequest request) {
        return request.getItinerary().entrySet().stream()
                .flatMap(entry -> {
                    String date = entry.getKey(); 
                    List<ReservationRequest.PoiDto> dtos = entry.getValue();

                    return dtos.stream()
                        .map(dto -> {
                            Poi poi = new Poi();
                            
                            poi.setContentId(dto.getContentId());
                            poi.setTypeId(dto.getTypeId());
                            poi.setReservDate(date); 
                            poi.setPlaceName(dto.getTitle()); 
                            
                            poi.setRating(0);       
                            poi.setContent("");     
                            
                            return poi;
                        });
                })
                .collect(Collectors.toList());
    }
}