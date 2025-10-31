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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TourAreaService {

    private final RestTemplate restTemplate;

    // .../KorService2 경로
    @Value("${tourapi.base-url}")          private String baseUrl; 
    @Value("${tourapi_key}")               private String serviceKey;
    @Value("${tourapi.mobile-os:ETC}")     private String mobileOs;
    @Value("${tourapi.mobile-app:READY}")  private String mobileApp;
    @Value("${tourapi.type:json}")         private String respType;
    @Value("${tourapi.rows:1000}")         private int rows;

    /** [ 1. 시/도, 시/군/구용 ] - areaCode2 (정상) */
    private URI buildUri(String areaCode) {
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

    /** [ 2. POI(관광지)용 ] - areaBasedList2 */
    private URI buildPoiUri(String areaCode, String sigunguCode, String contentTypeId) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                .pathSegment("areaBasedList2") 
                .queryParam("ServiceKey", serviceKey)
                .queryParam("MobileOS", mobileOs)
                .queryParam("MobileApp", mobileApp)
                .queryParam("_type", respType)
                .queryParam("pageNo", 1)
                .queryParam("numOfRows", rows);
                
        // [ ⭐ 1. (핵심 수정) ]
        // 'INVALID_REQUEST_PARAMETER_ERROR(listYN)' 오류 해결을 위해
        // listYN과 arrange 파라미터 2줄 제거
        // .queryParam("listYN", "Y")
        // .queryParam("arrange", "A");
        
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
        logApiCall(uri, "POI");
        return uri;
    }

    // (로그, extractItems, extractPoiItems, listSido, listSigungu 생략 - 이전과 동일)
    private void logApiCall(URI uri, String apiName) {
        String masked = uri.toString().replaceAll("(?i)(serviceKey)=[^&]+", "$1=****");
        log.info("[TourAPI::{}] GET {}", apiName, masked);
    }
    private List<Area> extractItems(TourAreaEnvelope env) {
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
                || env.getResponse().getBody().getItems() == null) {
            log.warn("[TourAPI::Area] Response Body or Items is null.");
            return Collections.emptyList();
        }
        List<Area> items = env.getResponse().getBody().getItems().getItem();
        return items == null ? Collections.emptyList() : items;
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
    public List<Area> listSido() {
        URI uri = buildUri(null);
        ResponseEntity<TourAreaEnvelope> res;
        try { res = restTemplate.getForEntity(uri, TourAreaEnvelope.class); } 
        catch (Exception e) { log.error("[TourAPI::Area] Sido RestTemplate 호출 중 예외: {}", e.getMessage()); return Collections.emptyList(); }
        if (!res.getStatusCode().is2xxSuccessful()) { log.error("[TourAPI::Area] Sido non-2xx {}", res.getStatusCodeValue()); return Collections.emptyList(); }
        TourAreaEnvelope env = res.getBody();
        if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) { log.warn("[TourAPI::Area] Sido 응답 구조 이상"); return Collections.emptyList(); }
        String resultCode = env.getResponse().getHeader().getResultCode();
        String resultMsg = env.getResponse().getHeader().getResultMsg();
        if (!"0000".equals(resultCode)) { log.error("[TourAPI::Area] Sido API Error: Code={}, Msg={}", resultCode, resultMsg); return Collections.emptyList(); }
        return extractItems(env);
    }
    public List<Area> listSigungu(String areaCode) {
        URI uri = buildUri(areaCode);
        ResponseEntity<TourAreaEnvelope> res;
        try { res = restTemplate.getForEntity(uri, TourAreaEnvelope.class); } 
        catch (Exception e) { log.error("[TourAPI::Area] Sigungu RestTemplate 호출 중 예외: {}", e.getMessage()); return Collections.emptyList(); }
        if (!res.getStatusCode().is2xxSuccessful()) { log.error("[TourAPI::Area] Sigungu non-xx {}", res.getStatusCodeValue()); return Collections.emptyList(); }
        TourAreaEnvelope env = res.getBody();
        if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) { log.warn("[TourAPI::Area] Sigungu 응답 구조 이상"); return Collections.emptyList(); }
        String resultCode = env.getResponse().getHeader().getResultCode();
        String resultMsg = env.getResponse().getHeader().getResultMsg();
        if (!"0000".equals(resultCode)) { log.error("[TourAPI::Area] Sigungu API Error: Code={}, Msg={}", resultCode, resultMsg); return Collections.emptyList(); }
        return extractItems(env);
    }

    /**
     * [ ⭐ 2. (핵심 수정) ] 
     * 원본 JSON 로깅 코드를 -> DTO 파싱 코드로 복원
     */
    public List<TourPoiEnvelope.PoiItem> listPoisByArea(String areaCode, String sigunguCode) {
        if (areaCode == null || areaCode.isBlank()) {
            log.warn("[TourAPI::POI] 조회를 위한 areaCode가 없습니다. 빈 목록을 반환합니다.");
            return Collections.emptyList();
        }

        List<String> contentTypesToFetch = Arrays.asList("12", "32", "39");
        List<TourPoiEnvelope.PoiItem> allPois = new ArrayList<>();
        
        String finalSigunguCode = (sigunguCode == null || sigunguCode.isBlank()) ? null : sigunguCode;

        for (String typeId : contentTypesToFetch) {
            URI uri = buildPoiUri(areaCode, finalSigunguCode, typeId); 
            
            log.info("[TourAPI::POI] 조회 시도 (areaCode={}, sigunguCode={}, contentTypeId={})", areaCode, finalSigunguCode, typeId);
            
            try {
                // [ ⭐ 2-1. ] String.class -> TourPoiEnvelope.class로 복원
                ResponseEntity<TourPoiEnvelope> res = restTemplate.getForEntity(uri, TourPoiEnvelope.class);
                
                if (!res.getStatusCode().is2xxSuccessful()) {
                    log.error("[TourAPI::POI] (type={}) non-2xx {}", typeId, res.getStatusCodeValue());
                    continue; 
                }

                // [ ⭐ 2-2. ] DTO 파싱 로직 복원
                TourPoiEnvelope env = res.getBody();
                if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
                    log.warn("[TourAPI::POI] (type={}) 응답 구조 이상", typeId);
                    continue; 
                }

                String resultCode = env.getResponse().getHeader().getResultCode();
                String resultMsg = env.getResponse().getHeader().getResultMsg();

                // [ ⭐ 2-3. ] "10" (파라미터 오류)도 에러로 처리
                if (!"0000".equals(resultCode)) {
                    if ("0001".equals(resultCode) || "NODATA".equalsIgnoreCase(resultMsg)) {
                        log.info("[TourAPI::POI] API (type={}) 결과 없음", typeId);
                    } else {
                        // (resultCode=10, resultMsg=INVALID_...) 등이 여기에 해당
                        log.error("[TourAPI::POI] API (type={}) Error: Code={}, Msg={}", typeId, resultCode, resultMsg);
                    }
                    continue; 
                }
                
                allPois.addAll(extractPoiItems(env));

            } catch (Exception e) {
                // (e.g., JSON 파싱 실패 시)
                log.error("[TourAPI::POI] RestTemplate (type={}) 호출 중 예외: {}", typeId, e.getMessage());
                continue; 
            }
        } // end for loop

        log.info("TourAPI 3회 호출 완료. 총 {}개의 POI를 병합했습니다.", allPois.size());
        return allPois;
    }
}