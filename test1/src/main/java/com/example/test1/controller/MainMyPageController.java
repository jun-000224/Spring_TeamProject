package com.example.test1.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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

import com.example.test1.dao.MainMyPageService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
public class MainMyPageController {
    @Autowired
    MainMyPageService mainMyPageService;

    // 마이페이지 화면 이동
    @RequestMapping("/main-myPage.do")
    public String viewMyPage(Model model) throws Exception {
        return "/main-myPage"; // JSP 경로
    }

    // 마이페이지 정보 조회 (JSON 응답)
    @RequestMapping(value = "/main-myPage/info.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getMyPageInfo(Model model, HttpSession session, @RequestParam HashMap<String, Object> map) throws Exception {
        String userId = (String) session.getAttribute("sessionId"); // 로그인된 사용자 ID
        map.put("userId", userId); // 서비스에 전달

        HashMap<String, Object> resultMap = mainMyPageService.getMainMyPageInfo(map);
        return new Gson().toJson(resultMap); // JSON 응답
    }
}