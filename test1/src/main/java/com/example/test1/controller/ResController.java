package com.example.test1.controller;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList;
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
            ReservationList reservation = createReservationList(request);
            
            reservation.setUserId("999"); 
            Long calculatedPrice = calculateTotalPrice(request); 
            reservation.setPrice(calculatedPrice); 
            setAreaNumFromRequest(reservation, request);
            setThemNumFromRequest(reservation, request);
            
            if (reservation.getPackName() == null) {
                reservation.setPackName("임시 패키지명");
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

    /**
     * 🛑 [수정] 이 AJAX 엔드포인트는 이제 DB에서 모든 정보를 가져오므로 필요 없습니다.
     */
    /*
    @GetMapping("/api/reservation/poi-details") 
    @ResponseBody
    public Poi getPoiDetailsForView(@RequestParam("contentId") String contentId) {
        Poi details = resService.getPoiDetailsByContentId(contentId);
        if (details != null) {
            return details;
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "POI 상세 정보를 찾을 수 없습니다.");
        }
    }
    */

    @GetMapping("/reservation-view.do")
    public String reservationView(@RequestParam("resNum") Long resNum, Model model) {
        
        List<Poi> pois = resService.getPoisByResNum(resNum);
        ReservationList reservationDetails = resService.getReservationDetails(resNum);

        model.addAttribute("kakaoAppKey", kakaoAppKey); 
        
        try {
            // 🛑 [수정] JSP(EL)가 아닌 Vue가 객체를 사용하도록 JSON 문자열 2개 전달
            
            // 1. POI 목록 (지도/리스트용)
            String poisJson = objectMapper.writeValueAsString(pois);
            model.addAttribute("poiListJson", poisJson);
            
            // 2. 예약 정보 (기본 정보 표시용)
            String reservationJson = objectMapper.writeValueAsString(reservationDetails);
            model.addAttribute("reservationJson", reservationJson);

        } catch (Exception e) {
            System.err.println("JSON 변환 실패: " + e.getMessage());
            model.addAttribute("poiListJson", "[]");
            model.addAttribute("reservationJson", "{}");
        }
        
        return "reservation-view"; 
    }

    // --- Private Helper Methods (전체 구현부) ---

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