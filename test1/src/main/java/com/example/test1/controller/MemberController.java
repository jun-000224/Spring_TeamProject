package com.example.test1.controller;

import java.util.HashMap;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
	@Value("${kakao_client_id}")
	private String kakao_client_id;

	@Value("${kakao_redirect_uri}")
	private String kakao_redirect_uri;
	
//	@Value("${naver_client_id}")
//	private String naver_client_id;
//	
//	@Value("${naver_client_secret}")
//	private String naver_client_secret;
//
//	@Value("${naver_redirect_uri}")
//	private String naver_redirect_uri;
	
	@Autowired
	MemberService memberService;

	//로그인 주소 생성
	@RequestMapping("/member/login.do") 
    public String login(Model model) throws Exception{
		String kakao_location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=" + kakao_client_id
				+ "&redirect_uri=" + kakao_redirect_uri;
		model.addAttribute("kakao_location", kakao_location);
		
//		String state = UUID.randomUUID().toString();
//		String naver_location = "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=" + naver_client_id + "&redirect_uri=" + naver_redirect_uri + "&state=" + state;
//		model.addAttribute("naver_location", naver_location);

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
	
	@RequestMapping("/member/find.do") 
    public String find(Model model) throws Exception{

    return "/member/find";
	      
	}
	
	@RequestMapping("/member/findId.do") 
    public String findId(Model model) throws Exception{

    return "/member/findId";
	      
	}
	
	@RequestMapping("/member/findPwd.do") 
    public String findPwd(Model model) throws Exception{

    return "/member/findPwd";
	      
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
	
	@RequestMapping(value = "/member/login.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberLogin(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.memberLogin(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/logout.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberLogout(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.memberLogout(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/findId.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberIdFind(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.idFind(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/pwdCheck.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String memberPwdCheck(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.memberPwdCheck(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/pwdChange.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pwdChange(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.changePwd(map);
		
		return new Gson().toJson(resultMap);
	}
}
