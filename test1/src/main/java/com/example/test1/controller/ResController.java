package com.example.test1.controller;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList;
import com.example.test1.model.reservation.ReservationRequest; 
import com.example.test1.dao.ResService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class ResController {

    @Autowired
    private ResService resService;

    @PostMapping("/api/reservation/save")
    @ResponseBody
    public ResponseEntity<?> saveReservation(@RequestBody ReservationRequest request) {
        try {
            // 1. DTO에서 DB 저장을 위한 객체로 변환
            ReservationList reservation = createReservationList(request);
            
            // 🛑 [필수 필드 설정] 모든 NULL 오류 해결 (userId, price, areaNum, themNum)
            reservation.setUserId("999"); 
            
            Long calculatedPrice = calculateTotalPrice(request); 
            reservation.setPrice(calculatedPrice); 
            
            setAreaNumFromRequest(reservation, request);

            setThemNumFromRequest(reservation, request);
            
            // DB NOT NULL 제약을 우회하기 위해 packName에 임시 값 설정
            if (reservation.getPackName() == null) {
                reservation.setPackName("임시 패키지명");
            }
            
            // 2. POI 목록 준비 (RATING/CONTENT 기본값 설정 포함)
            List<Poi> pois = createPoiList(request);
            
            // 3. Service 호출 및 저장
            Long resNum = resService.saveNewReservation(reservation, pois);
            
            // 4. 성공 응답
            return ResponseEntity.ok(Map.of("resNum", resNum, "message", "일정 저장 성공"));

        } catch (Exception e) {
            // 5. 실패 응답
            System.err.println("예약 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(Map.of("message", "일정 저장 실패", "error", e.getMessage()));
        }
    }

    private Long calculateTotalPrice(ReservationRequest request) {
        return request.getItinerary().values().stream()
                .flatMap(List::stream)
                .mapToLong(dto -> (dto.getPrice() != null) ? dto.getPrice().longValue() : 0L)
                .sum();
    }

    private void setThemNumFromRequest(ReservationList reservation, ReservationRequest request) {
        if (request.getThemes() != null && !request.getThemes().isEmpty()) {
            String themesString = String.join(",", request.getThemes());
            reservation.setThemNum(themesString); 
        } else {
            reservation.setThemNum("DEFAULT"); 
        }
    }

    private void setAreaNumFromRequest(ReservationList reservation, ReservationRequest request) {
        if (request.getRegions() != null && !request.getRegions().isEmpty()) {
            try {
                String sidoCode = request.getRegions().get(0).getSidoCode();
                reservation.setAreaNum(Integer.parseInt(sidoCode)); 
            } catch (NumberFormatException e) {
                reservation.setAreaNum(99); 
            }
        } else {
            reservation.setAreaNum(99); 
        }
    }

    private ReservationList createReservationList(ReservationRequest request) {
        ReservationList list = new ReservationList();
        
        list.setStartDate(request.getStartDate());
        list.setEndDate(request.getEndDate());
        
        return list;
    }

    /**
     * POI 객체 생성 시 RATING/CONTENT 필드에 기본값을 설정합니다.
     */
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
                            
                            // 🛑 RATING/CONTENT NULL 오류 방지 및 CLOB 타입 대비 기본값 설정
                            poi.setRating(0);       
                            poi.setContent("");     
                            
                            return poi;
                        });
                })
                .collect(Collectors.toList());
    }

    @GetMapping("/reservation-view")
    public String reservationView(@RequestParam("resNum") Long resNum, Model model) {
        
        List<Poi> pois = resService.getPoisByResNum(resNum);
        ReservationList reservationDetails = resService.getReservationDetails(resNum);

        model.addAttribute("reservation", reservationDetails); 
        model.addAttribute("poiList", pois); 
        
        return "reservation-view"; 
    }
}