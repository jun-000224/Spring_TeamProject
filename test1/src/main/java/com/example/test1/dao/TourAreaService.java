package com.example.test1.dao;

import com.example.test1.model.Area;
import com.example.test1.model.TourAreaEnvelope;
import com.example.test1.model.TourPoiEnvelope;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.ArrayList; // [ ⭐ 1. ArrayList 임포트 ]
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TourAreaService {

    private final RestTemplate restTemplate;

    @Value("${tourapi.base-url}")          private String baseUrl; 
    @Value("${tourapi_key}")               private String serviceKey;
    @Value("${tourapi.mobile-os:ETC}")     private String mobileOs;
    @Value("${tourapi.mobile-app:READY}")  private String mobileApp;
    @Value("${tourapi.type:json}")         private String respType;
    @Value("${tourapi.rows:1000}")         private int rows;

    /**
     * [기존] 지역코드(areaCode2)용 URI 빌더
     */
    private URI buildUri(String areaCode) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                .pathSegment("KorService2", "areaCode2") 
                .queryParam("ServiceKey", serviceKey) 
                .queryParam("MobileOS", mobileOs)
                .queryParam("MobileApp", mobileApp)
                .queryParam("_type", respType)
                .queryParam("pageNo", 1)
                .queryParam("numOfRows", rows);

        if (areaCode != null && !areaCode.isBlank()) {
            b.queryParam("areaCode", areaCode);
        }

        URI uri = b.build(true).toUri();
        logApiCall(uri);
        return uri;
    }

    /**
     * [ ⭐ 2. 수정 ] 관광정보 URI 빌더 (contentTypeId를 파라미터로 받음)
     */
    private URI buildPoiUri(String areaCode, String sigunguCode, String contentTypeId) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                // 404/500 오류를 피하기 위해 'KorService1' 경로 사용
                .pathSegment("KorService1", "areaBasedList")
                .queryParam("ServiceKey", serviceKey)
                .queryParam("MobileOS", mobileOs)
                .queryParam("MobileApp", mobileApp)
                .queryParam("_type", respType)
                .queryParam("pageNo", 1)
                .queryParam("numOfRows", rows)
                .queryParam("listYN", "Y")
                .queryParam("arrange", "A");
        
        // [ ⭐ 3. 수정 ] 콤마(,) 대신 단일 ID를 파라미터로 받음
        if (contentTypeId != null && !contentTypeId.isBlank()) {
            b.queryParam("contentTypeId", contentTypeId);
        }
        
        if (areaCode != null && !areaCode.isBlank()) {
            b.queryParam("areaCode", areaCode);
        }
        if (sigunguCode != null && !sigunguCode.isBlank()) {
            b.queryParam("sigunguCode", sigunguCode);
        }

        URI uri = b.build(true).toUri();
        logApiCall(uri);
        return uri;
    }

    // [공통] 로그 출력 공통 메소드
    private void logApiCall(URI uri) {
        String masked = uri.toString().replaceAll("(?i)(serviceKey)=[^&]+", "$1=****");
        // (로그 생략) ...
        log.info("[TourAPI] GET {}", masked);
    }

    // [기존] Area(지역) 추출
    private List<Area> extractItems(TourAreaEnvelope env) {
        // (코드 생략 - 동일)
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
                || env.getResponse().getBody().getItems() == null) {
            log.warn("[TourAPI] Area Response Body or Items is null.");
            return Collections.emptyList();
        }
        List<Area> items = env.getResponse().getBody().getItems().getItem();
        return items == null ? Collections.emptyList() : items;
    }
    
    // [기존] POI(관광지) 목록 추출
    private List<TourPoiEnvelope.PoiItem> extractPoiItems(TourPoiEnvelope env) {
        // (코드 생략 - 동일)
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
                || env.getResponse().getBody().getItems() == null) {
            log.warn("[TourAPI] POI Response Body or Items is null.");
            return Collections.emptyList();
        }
        List<TourPoiEnvelope.PoiItem> items = env.getResponse().getBody().getItems().getItem();
        
        if (items == null) {
            return Collections.emptyList();
        }
        return items.stream()
                .filter(it -> it.getContentid() != null && it.getContenttypeid() != null)
                .collect(Collectors.toList());
    }

    // [기존] 시/도
    public List<Area> listSido() {
        // (코드 생략 - 동일)
        URI uri = buildUri(null);
        ResponseEntity<TourAreaEnvelope> res;
        try {
            res = restTemplate.getForEntity(uri, TourAreaEnvelope.class);
        } catch (Exception e) {
            log.error("[TourAPI] Sido RestTemplate 호출 중 예외 발생: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
        if (!res.getStatusCode().is2xxSuccessful()) {
            log.error("[TourAPI] Sido non-2xx {} {}", res.getStatusCodeValue(), Objects.toString(res.getBody(), ""));
            return Collections.emptyList();
        }
        TourAreaEnvelope env = res.getBody();
        if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
            log.warn("[TourAPI] Sido 응답 구조가 예상과 다릅니다.");
            return Collections.emptyList();
        }
        String resultCode = env.getResponse().getHeader().getResultCode();
        String resultMsg = env.getResponse().getHeader().getResultMsg();
        if (!"0000".equals(resultCode)) {
            log.error("[TourAPI] Sido API Application Error: Code={}, Msg={}", resultCode, resultMsg);
            return Collections.emptyList();
        }
        return extractItems(env);
    }

    // [기존] 시/군/구
    public List<Area> listSigungu(String areaCode) {
        // (코드 생략 - 동일)
        URI uri = buildUri(areaCode);
        ResponseEntity<TourAreaEnvelope> res;
        try {
            res = restTemplate.getForEntity(uri, TourAreaEnvelope.class);
        } catch (Exception e) {
            log.error("[TourAPI] Sigungu RestTemplate 호출 중 예외 발생: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
        if (!res.getStatusCode().is2xxSuccessful()) {
            log.error("[TourAPI] Sigungu non-xx {} {}", res.getStatusCodeValue(), Objects.toString(res.getBody(), ""));
            return Collections.emptyList();
        }
        TourAreaEnvelope env = res.getBody();
        if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
            log.warn("[TourAPI] Sigungu 응답 구조가 예상과 다릅니다.");
            return Collections.emptyList();
        }
        String resultCode = env.getResponse().getHeader().getResultCode();
        String resultMsg = env.getResponse().getHeader().getResultMsg();
        if (!"0000".equals(resultCode)) {
            log.error("[TourAPI] Sigungu API Application Error: Code={}, Msg={}", resultCode, resultMsg);
            return Collections.emptyList();
        }
        return extractItems(env);
    }


    /**
     * [ ⭐ 4. 전면 수정 ] 
     * 지역 기반 POI 목록 조회 (API 3회 호출)
     */
    public List<TourPoiEnvelope.PoiItem> listPoisByArea(String areaCode, String sigunguCode) {
        if (areaCode == null || areaCode.isBlank()) {
            log.warn("[TourAPI] POI 조회를 위한 areaCode가 없습니다. 빈 목록을 반환합니다.");
            return Collections.emptyList();
        }

        // [수정] 12(관광지), 32(숙소), 39(식당) 3번을 나누어 호출
        List<String> contentTypesToFetch = List.of("12", "32", "39");
        List<TourPoiEnvelope.PoiItem> allPois = new ArrayList<>();

        for (String typeId : contentTypesToFetch) {
            log.info("[TourAPI] POI 조회 시도 (areaCode={}, contentTypeId={})", areaCode, typeId);
            
            // [수정] buildPoiUri에 typeId 전달
            URI uri = buildPoiUri(areaCode, sigunguCode, typeId);
            ResponseEntity<TourPoiEnvelope> res;
            
            try {
                res = restTemplate.getForEntity(uri, TourPoiEnvelope.class);
            } catch (Exception e) {
                // 500 오류 등이 발생해도, 다른 타입 조회를 위해 계속 진행
                log.error("[TourAPI] POI RestTemplate (type={}) 호출 중 예외: {}", typeId, e.getMessage());
                continue; 
            }

            if (!res.getStatusCode().is2xxSuccessful()) {
                log.error("[TourAPI] POI (type={}) non-2xx {}", typeId, res.getStatusCodeValue());
                continue;
            }

            TourPoiEnvelope env = res.getBody();
            if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
                log.warn("[TourAPI] POI (type={}) 응답 구조 이상", typeId);
                continue;
            }

            String resultCode = env.getResponse().getHeader().getResultCode();
            String resultMsg = env.getResponse().getHeader().getResultMsg();

            if (!"0000".equals(resultCode)) {
                if ("0001".equals(resultCode) || "NODATA".equalsIgnoreCase(resultMsg)) {
                    log.info("[TourAPI] POI API (type={}) 결과 없음", typeId);
                } else {
                    log.error("[TourAPI] POI API (type={}) Application Error: Code={}, Msg={}", typeId, resultCode, resultMsg);
                }
                continue; // 오류가 나거나 데이터가 없으면 다음 타입 조회
            }
            
            // [수정] 성공한 경우에만 전체 리스트에 추가
            allPois.addAll(extractPoiItems(env));
        }

        log.info("TourAPI 3회 호출 완료. 총 {}개의 POI를 병합했습니다.", allPois.size());
        return allPois;
    }
}