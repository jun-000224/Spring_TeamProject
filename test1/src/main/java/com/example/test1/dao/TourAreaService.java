package com.example.test1.dao;

import com.example.test1.model.Area;
import com.example.test1.model.TourAreaEnvelope;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TourAreaService {

    private final RestTemplate restTemplate;

    @Value("${tourapi.base-url}")        private String baseUrl;
    @Value("${TOUR_KEY}")                private String rawServiceKey;
    @Value("${tourapi.mobile-os:ETC}")   private String mobileOs;
    @Value("${tourapi.mobile-app:READY}")private String mobileApp;
    @Value("${tourapi.type:json}")       private String type;
    @Value("${tourapi.rows:1000}")       private int rows;

    private String serviceKeyParamName = "ServiceKey"; // ✅ 대문자 S 우선

    private String serviceKeyForQuery() {
        // 키가 이미 인코딩되어(예: %2B 포함) 있으면 그대로 사용, 아니면 한 번만 인코딩
        if (rawServiceKey.contains("%")) return rawServiceKey;
        return UriComponentsBuilder.newInstance()
                .queryParam("k", rawServiceKey)
                .build(true) // no encoding of already-encoded parts
                .getQueryParams().getFirst("k");
    }

    private String buildUrl(String areaCode) {
        String key = serviceKeyForQuery();

        UriComponentsBuilder b = UriComponentsBuilder.fromHttpUrl(baseUrl + "/areaCode2")
                // ✅ 파라미터명: ServiceKey (대문자 S)
                .queryParam(serviceKeyParamName, key)
                .queryParam("MobileOS",   mobileOs)
                .queryParam("MobileApp",  mobileApp)
                .queryParam("_type",      type)
                .queryParam("numOfRows",  rows);
        if (areaCode != null && !areaCode.isBlank()) {
            b.queryParam("areaCode", areaCode);
        }

        // ✅ 이미 인코딩된 값 보존
        return b.build(true).toUriString();
    }

    public List<Area> listSido() {
        String url = buildUrl(null);
        logUrlForDebug(url); // 마스킹 로깅

        TourAreaEnvelope env = restTemplate.getForObject(url, TourAreaEnvelope.class);
        if (env == null || env.getResponse() == null ||
            env.getResponse().getBody() == null ||
            env.getResponse().getBody().getItems() == null ||
            env.getResponse().getBody().getItems().getItem() == null) {
            return Collections.emptyList();
        }
        return env.getResponse().getBody().getItems().getItem();
    }

    public List<Area> listSigungu(String areaCode) {
        String url = buildUrl(areaCode);
        logUrlForDebug(url);

        TourAreaEnvelope env = restTemplate.getForObject(url, TourAreaEnvelope.class);
        if (env == null || env.getResponse() == null ||
            env.getResponse().getBody() == null ||
            env.getResponse().getBody().getItems() == null ||
            env.getResponse().getBody().getItems().getItem() == null) {
            return Collections.emptyList();
        }
        return env.getResponse().getBody().getItems().getItem();
    }

    private void logUrlForDebug(String url) {
        // 키 마스킹 로그 (개발 중 문제 파악용)
        String masked = url.replaceAll("(?i)(ServiceKey|serviceKey)=[^&]+", "$1=****");
        System.out.println("[TourAPI] GET " + masked);
    }
}
