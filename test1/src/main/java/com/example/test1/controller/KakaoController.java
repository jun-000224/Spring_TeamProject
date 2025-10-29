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
public class KakaoController {
	//main 연결 시, properties에 있는 redirect_uri 를 http://localhost:8081/main-list.do 로 바꾸기
	
	@Value("${kakao_client_id}")
	// properties에 있는 client id
	// properties에 있는 것과 이름이 같아야 함
	private String kakao_client_id;

	@Value("${kakao_redirect_uri}")
	// properties에 있는 redirect url
	// properties에 있는 것과 이름이 같아야 함
	private String kakao_redirect_uri;
	
	@RequestMapping(value = "/kakao.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String selectBbsList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String tokenUrl = "https://kauth.kakao.com/oauth/token";

		RestTemplate restTemplate = new RestTemplate();
		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		
//		System.out.println(map);
		
		params.add("grant_type", "authorization_code");
		params.add("client_id", kakao_client_id);
		params.add("redirect_uri", kakao_redirect_uri);
		params.add("code", (String)map.get("code"));
			//map 안에서 code 호출, String형태로
		
//		String serviceType = (String) map.get("service"); 
//	    String code = (String) map.get("code");
//	    System.out.println(serviceType);
//	    System.out.println(code);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
		ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, request, Map.class);

		Map<String, Object> responseBody = response.getBody();
		System.out.println(responseBody);
		resultMap = (HashMap<String, Object>) getUserInfo((String)responseBody.get("access_token"));
			//String으로 다운 캐스팅
		System.out.println(resultMap);

		
		return new Gson().toJson(resultMap);
	}
	
	private Map<String, Object> getUserInfo(String accessToken) {
	    String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

	    RestTemplate restTemplate = new RestTemplate();
	    HttpHeaders headers = new HttpHeaders();
	    headers.setBearerAuth(accessToken);
	    HttpEntity<String> entity = new HttpEntity<>(headers);

	    ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

	    try {
	        ObjectMapper objectMapper = new ObjectMapper();
	        return objectMapper.readValue(response.getBody(), Map.class);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null; // 예외 발생 시 null 반환
	    }
	}
}
