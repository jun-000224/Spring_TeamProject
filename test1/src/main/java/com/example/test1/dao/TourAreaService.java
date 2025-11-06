package com.example.test1.dao;

import com.example.test1.common.TourParsingUtil;
import com.example.test1.model.reservation.Area;
import com.example.test1.model.reservation.TourAreaEnvelope;
import com.example.test1.model.reservation.TourMenuInfoEnvelope;
import com.example.test1.model.reservation.TourPoiEnvelope;
import com.example.test1.model.reservation.TourPoiEnvelope.PoiItem;
import com.example.test1.model.reservation.TourRoomInfoEnvelope;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TourAreaService {

    private final RestTemplate restTemplate;
    private final TourParsingUtil tourParsingUtil;

    @Value("${tourapi.base-url}") private String baseUrl;
    @Value("${tourapi_key}") private String serviceKey;
    @Value("${tourapi.mobile-os:ETC}") private String mobileOs;
    @Value("${tourapi.mobile-app:READY}") private String mobileApp;
    @Value("${tourapi.type:json}") private String respType;
    @Value("${tourapi.rows:1000}") private int rows;

    /** [ 1. 시/도, 시/군/구용 ] - areaCode2 */
    private URI buildAreaUri(String areaCode) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                .pathSegment("areaCode2")
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
        logApiCall(uri, "Area");
        return uri;
    }

    /** [ 2. POI용 ] - areaBasedList2 */
    private URI buildPoiUri(String areaCode, String sigunguCode, String contentTypeId) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                .pathSegment("areaBasedList2")
                .queryParam("ServiceKey", serviceKey)
                .queryParam("MobileOS", mobileOs)
                .queryParam("MobileApp", mobileApp)
                .queryParam("_type", respType)
                .queryParam("pageNo", 1)
                .queryParam("numOfRows", rows);

        if (contentTypeId != null && !contentTypeId.isBlank()) b.queryParam("contentTypeId", contentTypeId);
        if (areaCode != null && !areaCode.isBlank()) b.queryParam("areaCode", areaCode);
        if (sigunguCode != null && !sigunguCode.isBlank()) b.queryParam("sigunguCode", sigunguCode);

        URI uri = b.build(true).toUri();
        logApiCall(uri, "POI");
        return uri;
    }
    
    /** Content ID 기반 상세 조회 URI 빌더 (detailCommon2 사용) */
    private URI buildDetailCommonUri(String contentId) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                .pathSegment("detailCommon2")
                .queryParam("ServiceKey", serviceKey) 
                .queryParam("MobileOS", mobileOs)
                .queryParam("MobileApp", mobileApp)
                .queryParam("_type", respType)
                .queryParam("contentId", contentId)
                .queryParam("defaultYN", "Y") 
                .queryParam("firstImageYN", "Y") 
                .queryParam("addrinfoYN", "Y") 
                .queryParam("mapinfoYN", "Y"); 

        URI uri = b.build(true).toUri(); 
        logApiCall(uri, "DetailCommon");
        return uri;
    }

    private URI buildDetailInfoUri(String contentId, String contentTypeId) {
        return null;
    }

    private void logApiCall(URI uri, String apiName) {
        String masked = uri.toString().replaceAll("(?i)(serviceKey)=[^&]+", "$1=****");
        log.info("[TourAPI::{}] GET {}", apiName, masked);
    }

    private List<Area> extractAreaItems(TourAreaEnvelope env) {
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
                || env.getResponse().getBody().getItems() == null) {
            log.warn("[TourAPI::Area] Response Body or Items is null.");
            return Collections.emptyList();
        }
        List<Area> items = env.getResponse().getBody().getItems().getItem();
        return (items == null) ? Collections.emptyList() : items;
    }

    private List<TourPoiEnvelope.PoiItem> extractPoiItems(TourPoiEnvelope env) {
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
                || env.getResponse().getBody().getItems() == null) {
            log.warn("[TourAPI::POI] Response Body or Items is null.");
            return Collections.emptyList();
        }
        List<TourPoiEnvelope.PoiItem> items = env.getResponse().getBody().getItems().getItem();
        if (items == null) return Collections.emptyList();
        return items.stream()
                .filter(it -> it.getContentid() != null && it.getContenttypeid() != null)
                .collect(Collectors.toList());
    }
    
    private List<PoiItem> extractSinglePoiItem(TourPoiEnvelope env) {
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
            || env.getResponse().getBody().getItems() == null) { 
            log.warn("[TourAPI::DetailCommon] Response Body or Items is null.");
            return Collections.emptyList();
        }
        return env.getResponse().getBody().getItems().getItem();
    }

    // ===== Public APIs (지역 목록 및 POI 목록 조회) =====
    public List<Area> listSido() {
        try {
            ResponseEntity<TourAreaEnvelope> res = restTemplate.getForEntity(buildAreaUri(null), TourAreaEnvelope.class);
            if (!res.getStatusCode().is2xxSuccessful()) return Collections.emptyList();
            TourAreaEnvelope env = res.getBody();
            if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) return Collections.emptyList();
            if (!"0000".equals(env.getResponse().getHeader().getResultCode())) return Collections.emptyList();
            return extractAreaItems(env);
        } catch (Exception e) {
            log.error("[TourAPI::Area] Sido RestTemplate 예외: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<Area> listSigungu(String areaCode) {
        try {
            ResponseEntity<TourAreaEnvelope> res = restTemplate.getForEntity(buildAreaUri(areaCode), TourAreaEnvelope.class);
            if (!res.getStatusCode().is2xxSuccessful()) return Collections.emptyList();
            TourAreaEnvelope env = res.getBody();
            if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) return Collections.emptyList();
            if (!"0000".equals(env.getResponse().getHeader().getResultCode())) return Collections.emptyList();
            return extractAreaItems(env);
        } catch (Exception e) {
            log.error("[TourAPI::Area] Sigungu RestTemplate 예외: {}", e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<TourPoiEnvelope.PoiItem> listPoisByArea(String areaCode, String sigunguCode) {
        if (areaCode == null || areaCode.isBlank()) {
            log.warn("[TourAPI::POI] areaCode 없음");
            return Collections.emptyList();
        }

        List<String> types = Arrays.asList("12", "32", "39");
        List<TourPoiEnvelope.PoiItem> all = new ArrayList<>();
        String sig = (sigunguCode == null || sigunguCode.isBlank()) ? null : sigunguCode;

        for (String typeId : types) {
            URI uri = buildPoiUri(areaCode, sig, typeId);
            log.info("[TourAPI::POI] 조회 시도 (areaCode={}, sigunguCode={}, contentTypeId={})", areaCode, sig, typeId);
            try {
                ResponseEntity<TourPoiEnvelope> res = restTemplate.getForEntity(uri, TourPoiEnvelope.class);
                if (!res.getStatusCode().is2xxSuccessful()) continue;

                TourPoiEnvelope env = res.getBody();
                if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
                    log.warn("[TourAPI::POI] (type={}) 응답 구조 이상", typeId);
                    continue;
                }
                String code = env.getResponse().getHeader().getResultCode();
                String msg  = env.getResponse().getHeader().getResultMsg();
                if (!"0000".equals(code)) {
                    if ("0001".equals(code) || "NODATA".equalsIgnoreCase(msg)) {
                        log.info("[TourAPI::POI] (type={}) 결과 없음", typeId);
                    } else {
                        log.error("[TourAPI::POI] (type={}) Error: Code={}, Msg={}", typeId, code, msg);
                    }
                    continue;
                }
                all.addAll(extractPoiItems(env));
            } catch (Exception e) {
                log.error("[TourAPI::POI] RestTemplate 예외(type={}): {}", typeId, e.getMessage());
            }
        }
        log.info("TourAPI 3회 호출 완료. 총 {}개의 POI 병합", all.size());
        return all;
    }

    /** 🛑 [신규 추가] Content ID 기반으로 단일 POI 상세 정보(좌표, 이름)를 조회합니다. */
    public Optional<PoiItem> getSinglePoiDetails(String contentId) {
        if (contentId == null || contentId.isBlank() || "null".equalsIgnoreCase(contentId)) {
            log.warn("[TourAPI::DetailCommon] Content ID가 유효하지 않아 호출 중단: {}", contentId);
            return Optional.empty();
        }
        URI uri = buildDetailCommonUri(contentId);
        try {
            ResponseEntity<TourPoiEnvelope> res = restTemplate.getForEntity(uri, TourPoiEnvelope.class); 
            
            if (!res.getStatusCode().is2xxSuccessful()) {
                log.error("[TourAPI::DetailCommon] 응답 실패: {}", res.getStatusCode());
                return Optional.empty();
            }

            TourPoiEnvelope env = res.getBody();
            if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null || !"0000".equals(env.getResponse().getHeader().getResultCode())) {
                log.warn("[TourAPI::DetailCommon] API 호출 실패 또는 결과 없음");
                return Optional.empty();
            }

            List<PoiItem> items = extractSinglePoiItem(env);
            
            return items.stream().findFirst();

        } catch (Exception e) {
            log.error("[TourAPI::DetailCommon] RestTemplate 예외 발생: {}", e.getMessage(), e); 
            return Optional.empty();
        }
    }


    // ===== 가격 조회 메소드 (더미 데이터 최종 적용) =====
    public int getPoiPrice(String contentId, Integer contentTypeId, boolean isWeekend) {
        if (contentTypeId == null || contentId == null) return 0;

        long id;
        try {
            id = Long.parseLong(contentId);
        } catch (NumberFormatException e) {
            log.error("ContentId 파싱 오류: {}", contentId);
            return 0;
        }

        int finalPrice;

        if (contentTypeId == 12) { // 관광지: 0원
            finalPrice = 0;
        } else if (contentTypeId == 32) { // 숙박: 더미 가격
            finalPrice = (int) tourParsingUtil.generateDummyPrice(id, 50000, 150000);
        } else if (contentTypeId == 39) { // 식당: 더미 가격
            finalPrice = (int) tourParsingUtil.generateDummyPrice(id, 15000, 40000);
        } else {
            finalPrice = 0;
        }

        log.info("[DummyPrice::{} ({})] contentId={}, 최종 가격: {}원",
            contentTypeId,
            (contentTypeId == 32) ? "숙박" : (contentTypeId == 39 ? "식당" : "기타"),
            id,
            finalPrice);

        return finalPrice;
    }
}