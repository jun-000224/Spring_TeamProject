package com.example.test1.dao;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MemberMapper;
import com.example.test1.model.Member;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	@Autowired
	PasswordEncoder passwordEncoder;
	@Autowired
	HttpSession session;
	
	public HashMap<String, Object> idCheck(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Member member = memberMapper .memberIdCheck(map);
			String message = member != null ? "이미 사용중인 아이디 입니다." : "사용 가능한 아이디 입니다.";
			String result = member != null ? "true" : "false";
			
			resultMap.put("msg", message);
			resultMap.put("result", result);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); // e에 어떤 오류인지 담겨져 있음 -> 개발자가 오류를 확인하기 위해 사용하는 코드
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> insertJoin(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		System.out.println(map);
		String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
		map.put("hashPwd", hashPwd);
		
		int cnt = memberMapper.memberAdd(map);

		if(cnt<1) {
			resultMap.put("result", "fail");
		} else {
			resultMap.put("result", "success");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> memberLogin(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		System.out.println(map);
		
		Member member = memberMapper .memberLogin(map);
//		System.out.println(map);
		String message = "";
		String result = "";
		
		
		if(member != null) {
			Boolean loginFlg = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
//			System.out.println(loginFlg);
			
			if(loginFlg) {
				session.setAttribute("sessionId", member.getUserId());
				session.setAttribute("sessionName", member.getName());
				session.setAttribute("sessionNickname", member.getNickname());
				session.setAttribute("sessionStatus", member.getStatus());
				
				message = "로그인되었습니다.";
				result = "success";
			} else {
				message = "비밀번호가 틀립니다.";
				result = "success";
			}

			
		} else {
			Member idCheck = memberMapper.memberIdCheck(map);
			
			
			message = "아이디가 존재하지 않습니다.";
			result = "fail";
		}
		
		resultMap.put("msg", message);
		resultMap.put("result", result);
		
		return resultMap;
	}
	
	public HashMap<String, Object> idFind(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Member member = memberMapper .memberIdFind(map);
			String message = ""; 
			String result = "";
			
			if(member != null) {
				resultMap.put("info", member);
				message = "확인되었습니다.";
				result = "success";
			} else {
				message = "가입된 계정이 없습니다.";
				result = "fail";
			}
			
			resultMap.put("msg", message);
			resultMap.put("result", result);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); // e에 어떤 오류인지 담겨져 있음 -> 개발자가 오류를 확인하기 위해 사용하는 코드
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> memberPwdCheck(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			Member member = memberMapper .memberPwdCheck(map);
			String message = member != null ? "확인되었습니다." : "없는 계정입니다.";
			String result = member != null ? "success" : "fail";
			
			resultMap.put("msg", message);
			resultMap.put("result", result);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
			System.out.println(e.getMessage()); // e에 어떤 오류인지 담겨져 있음 -> 개발자가 오류를 확인하기 위해 사용하는 코드
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> changePwd(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		System.out.println(map);
//		String message = "";
		try {
			Member member = memberMapper.memberIdCheck(map);
//			System.out.println(member.getPassword());
			boolean pwdFlg = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
			
			if(pwdFlg) {
				resultMap.put("result", "fail");
				resultMap.put("msg", "기존 비밀번호와 같습니다.");
			} else {
				String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
				map.put("hashPwd", hashPwd);
				int cnt = memberMapper .memberPwdChange(map);
				resultMap.put("result", "success");
				resultMap.put("msg", "변경되었습니다.");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "오류가 발생했습니다.");
			System.out.println(e.getMessage()); // e에 어떤 오류인지 담겨져 있음 -> 개발자가 오류를 확인하기 위해 사용하는 코드
		}
		
		return resultMap;
	}
	
}
