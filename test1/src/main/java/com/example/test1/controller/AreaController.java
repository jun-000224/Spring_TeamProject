package com.example.test1.controller;

import java.net.URI;
import java.time.Duration;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class AreaController {

    private static final Logger log = LoggerFactory.getLogger(AreaController.class);
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final Gson GSON = new Gson();

    // === 행안부_행정표준코드_기관코드(StanOrgCd2) 설정 ===
    @Value("${areaApi.base}")
    private String base;                               // e.g. https://apis.data.go.kr/1741000/StanOrgCd2

    @Value("${areaApi.path}")
    private String path;                               // e.g. getStanOrgCdList2

    @Value("${areaApi.serviceKeyEncoded}")
    private String serviceKeyEncoded;                  // URL-Encoded ServiceKey

    @Value("${areaApi.type:json}")
    private String defaultType;                        // json

    @Value("${areaApi.defaultRows:1000}")
    private int defaultRows;                           // 페이지 사이즈

    @Value("${areaApi.stopSelt:0}")
    private String stopSelt;                           // 0=사용, 1=폐지

    private RestTemplate rt() {
        // 필요 시 타임아웃 팩토리로 교체 가능(간단 버전 유지)
        return new RestTemplate();
    }

    // ===================== [시/도 목록] =====================
    @GetMapping(value = "/api/tour/areas", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSidoList(@RequestParam(required = false) Map<String, String> params) {
        Instant st = Instant.now();
        try {
            URI uri = UriComponentsBuilder.fromHttpUrl(base + "/" + path)
                    .queryParam("ServiceKey", serviceKeyEncoded)
                    .queryParam("pageNo", params.getOrDefault("pageNo", "1"))
                    .queryParam("numOfRows", params.getOrDefault("numOfRows", String.valueOf(defaultRows)))
                    .queryParam("type", defaultType)
                    .queryParam("stop_selt", stopSelt)
                    .build(true)
                    .toUri();

            log.info("📡[AREAS] call: {}", uri);

            HttpHeaders headers = new HttpHeaders();
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
            ResponseEntity<String> res = rt().exchange(uri, HttpMethod.GET, new HttpEntity<>(headers), String.class);
            String body = res.getBody();

            log.debug("📦[AREAS] status={} length={}", res.getStatusCodeValue(), (body == null ? 0 : body.length()));
            log.info("🧾[AREAS] body(head)=\n{}", (body == null ? "null" : body.substring(0, Math.min(1000, body.length()))));

            JsonNode root = MAPPER.readTree(body);

            // 유연 파서로 item 목록 뽑기
            List<JsonNode> itemsNode = extractItems(root);
            if (itemsNode.isEmpty()) {
                log.warn("⚠️[AREAS] items empty");
            }

            // 소재지코드 앞 2자리(시/도)
            List<String> sidoCodes = itemsNode.stream()
                    .map(it -> it.path("locastd_cd").asText(""))
                    .filter(cd -> cd.length() >= 2)
                    .map(cd -> cd.substring(0, 2))
                    .distinct()
                    .sorted()
                    .collect(Collectors.toList());

            List<Map<String, Object>> items = new ArrayList<>();
            for (String code : sidoCodes) {
                items.add(row(code, code)); // 기관코드 API에는 지역명 텍스트가 없어 코드 그대로 사용
            }

            String out = wrapItems(items);
            log.info("🎯[AREAS] count={} elapsed={}ms", items.size(), Duration.between(st, Instant.now()).toMillis());
            return out;

        } catch (RestClientException e) {
            log.error("❌[AREAS] http error: {}", e.getMessage(), e);
            return fail(e);
        } catch (Exception e) {
            log.error("❌[AREAS] error: {}", e.getMessage(), e);
            return fail(e);
        }
    }

    // ===================== [시/군/구 목록] =====================
    @GetMapping(value = "/api/tour/sigungu", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getSigunguList(@RequestParam String areaCode,
                                 @RequestParam(required = false) Map<String, String> params) {
        Instant st = Instant.now();
        try {
            URI uri = UriComponentsBuilder.fromHttpUrl(base + "/" + path)
                    .queryParam("ServiceKey", serviceKeyEncoded)
                    .queryParam("pageNo", params.getOrDefault("pageNo", "1"))
                    .queryParam("numOfRows", params.getOrDefault("numOfRows", String.valueOf(defaultRows)))
                    .queryParam("type", defaultType)
                    .queryParam("stop_selt", stopSelt)
                    .build(true)
                    .toUri();

            log.info("📡[SIGUNGU] call: {} (areaCode={})", uri, areaCode);

            HttpHeaders headers = new HttpHeaders();
            headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
            ResponseEntity<String> res = rt().exchange(uri, HttpMethod.GET, new HttpEntity<>(headers), String.class);
            String body = res.getBody();

            log.debug("📦[SIGUNGU] status={} length={}", res.getStatusCodeValue(), (body == null ? 0 : body.length()));
            log.info("🧾[SIGUNGU] body(head)=\n{}", (body == null ? "null" : body.substring(0, Math.min(1000, body.length()))));

            JsonNode root = MAPPER.readTree(body);

            List<JsonNode> itemsNode = extractItems(root);
            if (itemsNode.isEmpty()) {
                log.warn("⚠️[SIGUNGU] items empty");
            }

            // 선택 시/도코드로 시작하는 5자리(시군구)만
            List<String> sggCodes = itemsNode.stream()
                    .map(it -> it.path("locastd_cd").asText(""))
                    .filter(cd -> cd.length() >= 5 && cd.startsWith(areaCode))
                    .map(cd -> cd.substring(0, 5))
                    .distinct()
                    .sorted()
                    .collect(Collectors.toList());

            List<Map<String, Object>> items = new ArrayList<>();
            for (String code : sggCodes) {
                items.add(row(code, code)); // 이름 대신 코드 출력
            }

            String out = wrapItems(items);
            log.info("🎯[SIGUNGU] count={} elapsed={}ms", items.size(), Duration.between(st, Instant.now()).toMillis());
            return out;

        } catch (RestClientException e) {
            log.error("❌[SIGUNGU] http error: {}", e.getMessage(), e);
            return fail(e);
        } catch (Exception e) {
            log.error("❌[SIGUNGU] error: {}", e.getMessage(), e);
            return fail(e);
        }
    }

    // ===================== 공통 유틸 =====================

    /** 행안부 API의 item 배열을 유연하게 추출 (표준 + 변형 구조 대응) */
    private List<JsonNode> extractItems(JsonNode root) {
        List<JsonNode> list = new ArrayList<>();

        // 1) 표준 구조: response.body.items.item
        JsonNode std = root.path("response").path("body").path("items").path("item");
        if (std.isArray()) {
            std.forEach(list::add);
            if (!list.isEmpty()) return list;
        }

        // 2) 데이터셋 루트명 형태: e.g., StanOrgCd2.row
        JsonNode row = root.path("StanOrgCd2").path("row");
        if (row.isArray()) {
            row.forEach(list::add);
            if (!list.isEmpty()) return list;
        }

        // 3) 최상위의 모든 하위 노드 탐색 (배열/row/items.item 등)
        Iterator<String> it = root.fieldNames();
        while (it.hasNext()) {
            String key = it.next();
            JsonNode val = root.path(key);

            if (val.isArray()) {
                List<JsonNode> cand = new ArrayList<>();
                val.forEach(cand::add);
                if (!cand.isEmpty() && looksLikeOrgRow(cand.get(0))) return cand;
            } else if (val.isObject()) {
                JsonNode maybeRow = val.path("row");
                if (maybeRow.isArray()) {
                    List<JsonNode> cand = new ArrayList<>();
                    maybeRow.forEach(cand::add);
                    if (!cand.isEmpty() && looksLikeOrgRow(cand.get(0))) return cand;
                }
                JsonNode maybeItems = val.path("items").path("item");
                if (maybeItems.isArray()) {
                    List<JsonNode> cand = new ArrayList<>();
                    maybeItems.forEach(cand::add);
                    if (!cand.isEmpty()) return cand;
                }
            }
        }

        return Collections.emptyList();
    }

    /** 레코드 형태 감지: 기관코드/소재지코드 필드가 있는지 */
    private boolean looksLikeOrgRow(JsonNode node) {
        return node.has("org_cd") || node.has("locastd_cd") || node.has("full_nm");
    }

    /** 프론트가 기대하는 구조로 래핑 */
    private String wrapItems(List<Map<String, Object>> items) {
        Map<String, Object> wrapped = Map.of(
                "response", Map.of(
                        "body", Map.of(
                                "items", Map.of("item", items)
                        )
                )
        );
        return GSON.toJson(wrapped);
    }

    private Map<String, Object> row(String code, String name) {
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("code", code == null ? "" : code);
        r.put("name", name == null ? "" : name);
        return r;
    }

    private String fail(Exception e) {
        Map<String, Object> err = new LinkedHashMap<>();
        err.put("result", "fail");
        err.put("message", e.getMessage());
        return GSON.toJson(err);
    }
}
