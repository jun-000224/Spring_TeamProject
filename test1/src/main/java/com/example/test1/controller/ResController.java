package com.example.test1.controller;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.Reservation;
import com.example.test1.model.reservation.ReservationRequest;
import com.example.test1.dao.ResService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
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

    // =========================
    // 예약 저장
    // =========================
    @PostMapping("/api/reservation/save")
    @ResponseBody
    public ResponseEntity<?> saveReservation(@RequestBody ReservationRequest request) {
        try {
            Reservation reservation = createReservation(request);

            reservation.setUserId("999");

            Long totalPrice = calculateTotalPrice(request);
            reservation.setPrice(String.valueOf(totalPrice));

            setAreaNumFromRequest(reservation, request);
            setThemNumFromRequest(reservation, request);

            // ✅ budgetWeights(%)를 금액(원)으로 환산하여 *_budget 컬럼에 세팅
            applyBudgetAllocationsByAmount(reservation, request, totalPrice);

            if (reservation.getPackname() == null) {
                reservation.setPackname("임시 패키지명");
            }

            List<Poi> pois = createPoiList(request);
            Long resNum = resService.saveNewReservation(reservation, pois);

            return ResponseEntity.ok(Map.of("resNum", resNum, "message", "일정 저장 성공"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(Map.of("message", "일정 저장 실패", "error", e.getMessage()));
        }
    }

    // =========================
    // 예약 상세 화면
    // =========================
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
            model.addAttribute("reservationJson", "{}");
            model.addAttribute("poiListJson", "[]");
        }

        return "reservation-view";
    }

    // =========================
    // 자동차 길찾기 (기존 ResService 재사용)
    // =========================
    @PostMapping("/api/route/build")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> buildCarRoute(@RequestBody RouteBuildRequest req) {
        try {
            if (req == null || req.getPois() == null || req.getPois().size() < 2) {
                return ResponseEntity.badRequest().body(Map.of("error", "최소 2개 지점이 필요합니다."));
            }

            List<Poi> poiList = req.getPois().stream().map(p -> {
                Poi poi = new Poi();
                poi.setContentId(p.getContentId());
                poi.setPlaceName(p.getName());
                poi.setMapX(p.getX()); // 경도
                poi.setMapY(p.getY()); // 위도
                return poi;
            }).collect(Collectors.toList());

            Map<String, Object> result = resService.buildCarRoute(poiList);
            if (result == null || ((List<?>) result.getOrDefault("points", List.of())).isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }

    // ---------- Helpers ----------

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

    /**
     * budgetWeights(% 등분) → 금액(원)으로 환산하여 Reservation의 *_budget 컬럼에 세팅
     * - 합계가 100이 아니어도 정규화
     * - 반올림 후 마지막 항목(act)에 잔차 보정
     */
    private void applyBudgetAllocationsByAmount(Reservation reservation, ReservationRequest request, long totalPrice) {
        Map<String, Integer> weights = request.getBudgetWeights();
        if (weights == null || totalPrice <= 0) {
            reservation.setEtcBudget(0f);
            reservation.setAccomBudget(0f);
            reservation.setFoodBudget(0f);
            reservation.setActBudget(0f);
            return;
        }

        Map<String, Integer> ordered = new LinkedHashMap<>();
        ordered.put("etc",   weights.getOrDefault("etc", 0));
        ordered.put("accom", weights.getOrDefault("accom", 0));
        ordered.put("food",  weights.getOrDefault("food", 0));
        ordered.put("act",   weights.getOrDefault("act", 0));

        int sum = ordered.values().stream().mapToInt(Integer::intValue).sum();
        if (sum <= 0) {
            reservation.setEtcBudget(0f);
            reservation.setAccomBudget(0f);
            reservation.setFoodBudget(0f);
            reservation.setActBudget(0f);
            return;
        }

        long etcAmt   = Math.round(totalPrice * (ordered.get("etc")   / (double) sum));
        long accomAmt = Math.round(totalPrice * (ordered.get("accom") / (double) sum));
        long foodAmt  = Math.round(totalPrice * (ordered.get("food")  / (double) sum));
        long partial  = etcAmt + accomAmt + foodAmt;
        long actAmt   = totalPrice - partial; // 잔차 보정

        reservation.setEtcBudget((float) etcAmt);
        reservation.setAccomBudget((float) accomAmt);
        reservation.setFoodBudget((float) foodAmt);
        reservation.setActBudget((float) actAmt);
    }

    /** 프론트 요청 DTO (내부 클래스) */
    @Data
    private static class RouteBuildRequest {
        private Long resNum;     // 로깅용
        private String day;      // "YYYY-MM-DD"
        private List<RoutePoiLite> pois;
        @Data
        private static class RoutePoiLite {
            private Long contentId;
            private String name;
            private double x; // 경도(lon)
            private double y; // 위도(lat)
        }
    }
}
