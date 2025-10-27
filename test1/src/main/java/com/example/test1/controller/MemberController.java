package com.example.test1.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.test1.dao.MemberService;
import com.google.gson.Gson;

@Controller
public class MemberController {
	@Autowired
	MemberService memberService;

	//로그인 주소 생성
	@RequestMapping("/member/login.do") 
    public String login(Model model) throws Exception{
//		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=" + client_id
//				+ "&redirect_uri=" + redirect_uri;
//		model.addAttribute("location", location);
    return "/member/login";
	      
	}
	
	//회원가입 주소 생성
	@RequestMapping("/member/join.do") 
    public String join(Model model) throws Exception{

    return "/member/join";
	      
	}
	
	//주소 입력
	@RequestMapping("/member/addr.do") 
    public String addr(Model model) throws Exception{

    return "/jusoPopup";
	      
	}

	@RequestMapping(value = "/member/idCheck.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberIdCheck(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.idCheck(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/join.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberJoin(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.insertJoin(map);
		
		return new Gson().toJson(resultMap);
	}
}
