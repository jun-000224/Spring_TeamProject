package com.example.test1.dao;

import com.example.test1.model.Area;
import com.example.test1.model.TourAreaEnvelope;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.net.URI;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;

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

    private URI buildUri(String areaCode) {
        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl)
                .pathSegment("areaCode2")
                // (만약 ServiceKey(대문자 S)로 바꿔도 안되면 이 부분도 확인 필요)
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

        String masked = uri.toString().replaceAll("(?i)(serviceKey)=[^&]+", "$1=****");
        String head = serviceKey.length() >= 6 ? serviceKey.substring(0, 6) : serviceKey;
        String tail = serviceKey.length() >= 6 ? serviceKey.substring(serviceKey.length() - 6) : serviceKey;
        log.info("[TourAPI] GET {}", masked);
        log.info("[TourAPI] key(head..tail/len) = {}..{} / {}", head, tail, serviceKey.length());

        return uri;
    }

    private List<Area> extractItems(TourAreaEnvelope env) {
        // [ ⭐ 수정 사항 ] null 체크 경로 상세화
        if (env == null || env.getResponse() == null || env.getResponse().getBody() == null
                || env.getResponse().getBody().getItems() == null) {
            log.warn("[TourAPI] Sido Response Body or Items is null. (정상 응답이나 데이터가 0개일 수 있음)");
            return Collections.emptyList();
        }

        List<Area> items = env.getResponse().getBody().getItems().getItem();

        return items == null ? Collections.emptyList() : items;
    }

    /** 시/도 */
    public List<Area> listSido() {
        URI uri = buildUri(null);
        ResponseEntity<TourAreaEnvelope> res;
        
        try {
            res = restTemplate.getForEntity(uri, TourAreaEnvelope.class);
        } catch (Exception e) {
            log.error("[TourAPI] Sido RestTemplate 호출 중 예외 발생: {}", e.getMessage(), e);
            return Collections.emptyList();
        }

        if (!res.getStatusCode().is2xxSuccessful()) {
            log.error("[TourAPI] Sido non-2xx {} {}", res.getStatusCodeValue(),
                    Objects.toString(res.getBody(), ""));
            return Collections.emptyList();
        }

        TourAreaEnvelope env = res.getBody();

        // [ ⭐ 수정 사항 ] 모델 수정으로 이제 이 코드가 정상 동작합니다.
        if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
            log.warn("[TourAPI] Sido 응답 구조가 예상과 다릅니다. (env, response, or header is null)");
            return Collections.emptyList();
        }

        String resultCode = env.getResponse().getHeader().getResultCode();
        String resultMsg = env.getResponse().getHeader().getResultMsg();

        if (!"0000".equals(resultCode)) {
            log.error("[TourAPI] Sido API Application Error: Code={}, Msg={}", resultCode, resultMsg);
            return Collections.emptyList();
        }
        
        // 성공 시 아이템 추출
        return extractItems(env);
    }

    /** 시/군/구 */
    public List<Area> listSigungu(String areaCode) {
        URI uri = buildUri(areaCode);
        ResponseEntity<TourAreaEnvelope> res;

        try {
            res = restTemplate.getForEntity(uri, TourAreaEnvelope.class);
        } catch (Exception e) {
            log.error("[TourAPI] Sigungu RestTemplate 호출 중 예외 발생: {}", e.getMessage(), e);
            return Collections.emptyList();
        }

        if (!res.getStatusCode().is2xxSuccessful()) {
            log.error("[TourAPI] Sigungu non-2xx {} {}", res.getStatusCodeValue(),
                    Objects.toString(res.getBody(), ""));
            return Collections.emptyList();
        }

        TourAreaEnvelope env = res.getBody();

        // 모델 수정으로 이제 이 코드가 정상 동작합니다.
        if (env == null || env.getResponse() == null || env.getResponse().getHeader() == null) {
            log.warn("[TourAPI] Sigungu 응답 구조가 예상과 다릅니다. (env, response, or header is null)");
            return Collections.emptyList();
        }

        String resultCode = env.getResponse().getHeader().getResultCode();
        String resultMsg = env.getResponse().getHeader().getResultMsg();

        if (!"0000".equals(resultCode)) {
            log.error("[TourAPI] Sigungu API Application Error: Code={}, Msg={}", resultCode, resultMsg);
            return Collections.emptyList();
        }

        // 성공 시 아이템 추출
        return extractItems(env);
    }
}