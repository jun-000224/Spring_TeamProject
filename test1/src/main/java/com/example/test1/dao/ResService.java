package com.example.test1.dao;

import com.example.test1.mapper.ResMapper;
import com.example.test1.model.reservation.Poi;
import com.example.test1.model.Reservation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.*;

@Service
public class ResService {

    @Autowired
    private ResMapper resMapper;

    // Kakao Mobility Directions
    @Value("${kakao.navi.base-url:https://apis-navi.kakaomobility.com/v1/directions}")
    private String kakaoDirectionsBase;

    @Value("${kakao.navi.rest-key}")
    private String kakaoRestKey;

    @Value("${kakao.navi.priority:RECOMMEND}")
    private String kakaoPriority;

    private final RestTemplate routeRt = new RestTemplate();

    // -------- 예약 저장/조회 --------
    @Transactional
    public Long saveNewReservation(Reservation reservation, List<Poi> pois) {
        resMapper.insertReservation(reservation);
        Long resNum = Long.parseLong(reservation.getResNum());
        for (Poi poi : pois) {
            poi.setResNum(resNum);
            resMapper.insertPoi(poi);
        }
        return resNum;
    }

    public List<Poi> getPoisByResNum(Long resNum) {
        return resMapper.selectPoisByResNum(resNum);
    }

    public Reservation getReservationDetails(Long resNum) {
        Reservation reservation = resMapper.selectReservationByResNum(resNum);
        if (reservation == null) return null;
        reservation.setPois(getPoisByResNum(resNum));
        return reservation;
    }

    // -------- 코스명/메모 업데이트 --------
    @Transactional
    public boolean updatePackname(Long resNum, String packName, String userId, String descript) {
        return resMapper.updatePackname(resNum, packName, userId, descript) > 0;
    }

    // -------- 여행 포기(예약 삭제) --------
    @Transactional
    public boolean deleteReservationCascade(Long resNum) {
        // FK 문제 방지: 자식(POI) → 부모(RESERVATION) 순서 삭제
        resMapper.deletePoisByResNum(resNum);
        return resMapper.deleteReservation(resNum) > 0;
    }

    // -------- 자동차 경로 --------
    public Map<String, Object> buildCarRoute(List<Poi> pois) {
        List<Map<String, Object>> points = new ArrayList<>();
        long totalDist = 0, totalDur = 0, totalToll = 0;
        int segments = 0;

        Double lastX = null, lastY = null;
        for (int i = 0; i < pois.size() - 1; i++) {
            Poi o = pois.get(i);
            Poi d = pois.get(i + 1);
            if (o.getMapX() == null || o.getMapY() == null || d.getMapX() == null || d.getMapY() == null) continue;

            Segment seg = callKakaoDirections(o.getMapX(), o.getMapY(), d.getMapX(), d.getMapY());

            for (Map<String, Object> p : seg.points) {
                double x = (double) p.get("x");
                double y = (double) p.get("y");
                if (lastX == null || lastY == null || !lastX.equals(x) || !lastY.equals(y)) {
                    points.add(p);
                    lastX = x; lastY = y;
                }
            }
            totalDist += seg.distance;
            totalDur  += seg.duration;
            totalToll += seg.toll;
            segments++;
        }

        Map<String, Object> summary = new HashMap<>();
        summary.put("distance", totalDist);
        summary.put("duration", totalDur);
        summary.put("toll", totalToll);
        summary.put("segments", segments);

        Map<String, Object> resp = new HashMap<>();
        resp.put("points", points);
        resp.put("summary", summary);
        return resp;
    }

    private Segment callKakaoDirections(double ox, double oy, double dx, double dy) {
        URI uri = UriComponentsBuilder.fromHttpUrl(kakaoDirectionsBase)
                .queryParam("origin", ox + "," + oy)
                .queryParam("destination", dx + "," + dy)
                .queryParam("priority", kakaoPriority)
                .queryParam("alternatives", false)
                .queryParam("road_details", false)
                .build(true).toUri();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + kakaoRestKey);
        headers.setAccept(List.of(MediaType.APPLICATION_JSON));

        ResponseEntity<Map> res = routeRt.exchange(uri, HttpMethod.GET, new HttpEntity<>(headers), Map.class);
        if (!res.getStatusCode().is2xxSuccessful() || res.getBody() == null) {
            throw new RuntimeException("Kakao Directions API 실패: " + res.getStatusCode());
        }
        return parseDirections(res.getBody());
    }

    @SuppressWarnings("unchecked")
    private Segment parseDirections(Map body) {
        List<Map<String, Object>> routes = (List<Map<String, Object>>) body.get("routes");
        if (routes == null || routes.isEmpty()) throw new RuntimeException("routes 비어 있음");
        Map<String, Object> r0 = routes.get(0);

        long distance = 0, duration = 0, toll = 0;
        Map<String, Object> summary = (Map<String, Object>) r0.get("summary");
        if (summary != null) {
            Number dist = (Number) summary.get("distance");
            Number dur  = (Number) summary.get("duration");
            distance = dist == null ? 0 : dist.longValue();
            duration = dur  == null ? 0 : dur.longValue();
            Map<String, Object> fare = (Map<String, Object>) summary.get("fare");
            if (fare != null) {
                Number t = (Number) fare.get("toll");
                toll = t == null ? 0 : t.longValue();
            }
        }

        List<Map<String, Object>> outPoints = new ArrayList<>();
        List<Map<String, Object>> sections = (List<Map<String, Object>>) r0.get("sections");
        if (sections != null) {
            for (Map<String, Object> sec : sections) {
                List<Map<String, Object>> roads = (List<Map<String, Object>>) sec.get("roads");
                if (roads == null) continue;
                for (Map<String, Object> road : roads) {
                    List<Double> vtx = (List<Double>) road.get("vertexes");
                    if (vtx == null || vtx.size() < 2) continue;
                    for (int i = 0; i < vtx.size() - 1; i += 2) {
                        outPoints.add(Map.of("x", vtx.get(i), "y", vtx.get(i + 1)));
                    }
                }
            }
        }
        if (outPoints.isEmpty()) throw new RuntimeException("vertexes 파싱 결과 0개");

        Segment seg = new Segment();
        seg.points = outPoints;
        seg.distance = distance;
        seg.duration = duration;
        seg.toll = toll;
        return seg;
    }

    private static class Segment {
        List<Map<String, Object>> points;
        long distance, duration, toll;
    }
}
