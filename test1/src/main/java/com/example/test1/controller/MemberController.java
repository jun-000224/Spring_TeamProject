package com.example.test1.controller;

import java.io.File;
import java.util.HashMap;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

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
//		System.out.println(map);
		
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
		
		resultMap.put("kakaoClientId", kakao_client_id);
        resultMap.put("kakaoRedirectUri", kakao_redirect_uri);
		
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
	

	@RequestMapping(value = "/member/kakaoDisc.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String kDisc(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.discMember(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/kakaoJoin.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String kJoin(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.joinKakao(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/member/pwdConfirm.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pwdConfirm(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.pwdConfirm(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/member/profileUpload.dox")
	public String result(@RequestParam("file1") MultipartFile multi, @RequestParam("userId") String userId, HttpServletRequest request,HttpServletResponse response, Model model)
//	기존 방식처럼 map으로 받는 것도 가능
	{
		String url = null;
		String path="c:\\img\\profile";
		try {

			//String uploadpath = request.getServletContext().getRealPath(path);
			String uploadpath = path;
			String originFilename = multi.getOriginalFilename();
//				업로드 할 당시의 이름
			String extName = originFilename.substring(originFilename.lastIndexOf("."),originFilename.length());
//				lastIndexOf(".") => 마지막 점의 위치로부터, length인 마지막까지를 substring=> 잘라내겠다.
//				=> 확장자만 extName으로 때어내겠다
			long size = multi.getSize();
			//String saveFileName = genSaveFileName(extName);
			
			String saveFileName = userId + "_profile" + extName;
			
			
//			System.out.println("uploadpath : " + uploadpath);
			System.out.println("originFilename : " + originFilename);
			System.out.println("extensionName : " + extName);
			System.out.println("size : " + size);
//				단위는 kb
			System.out.println("saveFileName : " + saveFileName);
			String path2 = System.getProperty("user.dir");
			System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");
			if(!multi.isEmpty())
			{
				File file = new File(path2 + "\\src\\main\\webapp\\img\\profile", saveFileName);
//					파일 저장 경로
				multi.transferTo(file);
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("fileName", saveFileName);
				map.put("path", "/img/profile/" + saveFileName);
				map.put("userId", userId);
				map.put("orgName", originFilename);
				map.put("size", size);
				map.put("ext", extName);
				
				// insert 쿼리 실행
			    memberService.addProfileImg(map);
				
				model.addAttribute("filename", multi.getOriginalFilename());
				model.addAttribute("uploadPath", file.getAbsolutePath());
				
				System.out.println("업로드 성공");
				
				return "redirect:/member/login.do";
			}
		}catch(Exception e) {
			System.out.println(e);
		}
		return "redirect:/member/login.do";
	}
	
	@RequestMapping(value = "/member/profilePath.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String profilePath(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = memberService.profileImgPath(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/member/profileUpdate.dox")
	public String result2(@RequestParam("file1") MultipartFile multi, @RequestParam("userId") String userId, @RequestParam("mediaId") int mediaId, HttpServletRequest request,HttpServletResponse response, Model model)
//	기존 방식처럼 map으로 받는 것도 가능
	{
		String url = null;
		String path="c:\\img\\profile";
		try {

			//String uploadpath = request.getServletContext().getRealPath(path);
			String uploadpath = path;
			String originFilename = multi.getOriginalFilename();
//				업로드 할 당시의 이름
			String extName = originFilename.substring(originFilename.lastIndexOf("."),originFilename.length());
//				lastIndexOf(".") => 마지막 점의 위치로부터, length인 마지막까지를 substring=> 잘라내겠다.
//				=> 확장자만 extName으로 때어내겠다
			long size = multi.getSize();
			//String saveFileName = genSaveFileName(extName);
			
			String saveFileName = userId + "_profile" + extName;
			
			
//			System.out.println("uploadpath : " + uploadpath);
			System.out.println("originFilename : " + originFilename);
			System.out.println("extensionName : " + extName);
			System.out.println("size : " + size);
//				단위는 kb
			System.out.println("saveFileName : " + saveFileName);
			String path2 = System.getProperty("user.dir");
			System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");
			if(!multi.isEmpty())
			{
				File file = new File(path2 + "\\src\\main\\webapp\\img\\profile", saveFileName);
//					파일 저장 경로
				multi.transferTo(file);
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("fileName", saveFileName);
				map.put("path", "/img/profile/" + saveFileName);
				map.put("userId", userId);
				map.put("orgName", originFilename);
				map.put("size", size);
				map.put("ext", extName);
				map.put("mediaId", mediaId);
				
				// update 쿼리 실행
			    memberService.updateProfileImg(map);
				
				model.addAttribute("filename", multi.getOriginalFilename());
				model.addAttribute("uploadPath", file.getAbsolutePath());
				
				System.out.println("업데이트 성공");
				
				return "redirect:/myInfo/edit.do";
			}
		}catch(Exception e) {
			System.out.println(e);
		}
		return "redirect:/myInfo/edit.do";
	}

}
