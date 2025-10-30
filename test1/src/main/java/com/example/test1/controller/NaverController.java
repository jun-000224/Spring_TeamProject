package com.example.test1.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class NaverController {
//	@Value("${naver_client_id}")
//	private String naver_client_id;
//	
//	@Value("${naver_client_secret}")
//	private String naver_client_secret;
//
//	@Value("${naver_redirect_uri}")
//	private String naver_redirect_uri;
//	
//	@RequestMapping(value = "/naver.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
//	@ResponseBody
//	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
//		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//
//		String tokenUrl = "https://nid.naver.com/oauth2.0/token";
//
//	    RestTemplate restTemplate = new RestTemplate();
//	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
//	    params.add("grant_type", "authorization_code");
//	    params.add("client_id", naver_client_id);
//	    params.add("client_secret", naver_client_secret);
//	    params.add("redirect_uri", naver_redirect_uri);
//	    params.add("code", (String)map.get("code"));
//
//	    HttpHeaders headers = new HttpHeaders();
//	    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//	    HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
//	    ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, request, Map.class);
//
//	    Map<String, Object> responseBody = response.getBody();
////	    return (String) responseBody.get("access_token");
//	    System.out.println(responseBody);
//	    resultMap = (HashMap<String, Object>) getUserInfo((String)responseBody.get("access_token"));
//	    System.out.println(resultMap);
//		
//		return new Gson().toJson(resultMap);
//	}
//	
//	private Map<String, Object> getUserInfo(String accessToken) {
//	    String userInfoUrl = "https://openapi.naver.com/v1/nid/me";
//
//	    RestTemplate restTemplate = new RestTemplate();
//	    HttpHeaders headers = new HttpHeaders();
//	    headers.setBearerAuth(accessToken);  // Authorization 헤더에 Bearer 토큰을 추가
//	    HttpEntity<String> entity = new HttpEntity<>(headers);
//
//	    ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);
//
//	    try {
//	        ObjectMapper objectMapper = new ObjectMapper();
//	        return objectMapper.readValue(response.getBody(), Map.class);
//	    } catch (Exception e) {
//	        e.printStackTrace();
//	        return null;  // 예외 발생 시 null 반환
//	    }
//	}

}
