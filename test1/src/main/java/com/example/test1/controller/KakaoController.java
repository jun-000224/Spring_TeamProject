package com.example.test1.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

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
import org.springframework.web.bind.annotation.GetMapping;
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
	public String kakaoLogin(Model model, @RequestParam HashMap<String, Object> map, HttpSession session) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

//		if (session.getAttribute("kakaoAccessToken") != null) {
//            System.out.println("⚠️ 이미 세션에 kakaoAccessToken 존재. 토큰 재요청 생략.");
//            resultMap.put("result", "already_logged_in");
//            return new Gson().toJson(resultMap);
//        }
		
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
		
		String code = (String) map.get("code");
		System.out.println("인가코드 : " + code);
	    if (code == null || code.isEmpty()) {
	        System.out.println("⚠️ Kakao 인가 코드가 없습니다. 요청 중단");
	        resultMap.put("error", "인가 코드가 없습니다.");
	        return new Gson().toJson(resultMap);
	    } 
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
		ResponseEntity<Map> response = restTemplate.postForEntity(tokenUrl, request, Map.class);

		Map<String, Object> responseBody = response.getBody();
		
		System.out.println(responseBody);
		
		String accessToken = (String) responseBody.get("access_token");
	    String refreshToken = (String) responseBody.get("refresh_token");
	    session.setAttribute("kakaoAccessToken", accessToken);
	    session.setAttribute("kakaoRefreshToken", refreshToken);
		
		resultMap = (HashMap<String, Object>) getUserInfo((String)responseBody.get("access_token"));
			//String으로 다운 캐스팅
		
//		System.out.println(resultMap);

		
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
	
	@GetMapping("/api/session/kakao")
	@ResponseBody
	public Map<String, Object> hasKakaoSession(HttpSession session) {
	    boolean has = session.getAttribute("kakaoAccessToken") != null;
	    Map<String, Object> res = new HashMap<>();
	    res.put("hasKakaoSession", has);
	    return res;
	}
	
//	@RequestMapping(value = "/kakaoLogout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
//	@ResponseBody
//	public String kakaoLogout(HttpSession session) {
//	    HashMap<String, Object> resultMap = new HashMap<>();
//
//	    String accessToken = (String) session.getAttribute("kakaoAccessToken");
//	    
//	    //accesstoken은 나옴
////	    System.out.println(accessToken);
//	    
//	    if (accessToken == null) {
//	        System.out.println("⚠️ 세션에 Kakao Access Token 없음.");
//	        resultMap.put("result", "no_token");
////	        return new Gson().toJson(resultMap);
//	    } 
//
//	    try {
//	    	
//	        String logoutUrl = "https://kapi.kakao.com/v1/user/logout";
//	        RestTemplate restTemplate = new RestTemplate();
//
//	        HttpHeaders headers = new HttpHeaders();
//	        headers.setBearerAuth(accessToken);
//
//	        HttpEntity<String> entity = new HttpEntity<>(headers);
//	        ResponseEntity<String> response = restTemplate.exchange(logoutUrl, HttpMethod.POST, entity, String.class);
//
//	        System.out.println("✅ 카카오 로그아웃 응답: " + response.getBody());
//
//	        // 서버 세션 종료
//	        session.invalidate();
//
//	        resultMap.put("result", "ok");
//	        resultMap.put("kakaoResponse", response.getBody());
//	    } catch (Exception e) {
//	    	resultMap.put("msg", "오류가 발생했습니다.");
//			resultMap.put("result", "fail");
//			System.out.println(e.getMessage()); // e에 어떤 오류인지 담겨져 있음 -> 개발자가 오류를 확인하기 위해 사용하는 코드
//	    }
////
//	    return new Gson().toJson(resultMap);
//	}


}
