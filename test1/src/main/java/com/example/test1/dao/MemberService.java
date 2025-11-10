package com.example.test1.dao;

import java.util.HashMap;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MemberMapper;
import com.example.test1.mapper.PointMapper;
import com.example.test1.model.Member;
import com.example.test1.model.Point;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	@Autowired
	PointMapper pointMapper;
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
			System.out.println(e.getMessage());
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
//		System.out.println(member.getStatus());
		String message = "";
		String result = "";
		
		
		
		
		if(member != null) {
			Boolean loginFlg = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
//			System.out.println(loginFlg);
			
			if(loginFlg) {
				
				if(member.getCnt() >= 5) {
					message = "로그인 불가(비밀번호를 5회 이상 잘못 입력하셨습니다.)";
					result = "fail";
				} else {
					if(member.getStatus().equals("B")) {
						message = "접속이 제한된 계정입니다.";
						result = "fail";
					} else {
						int cntReset = memberMapper.loginCntReset(map);
						
						Point point = pointMapper.recentPoint(map);
						
						message = "로그인되었습니다.";
						result = "success";
						
						session.setAttribute("sessionId", member.getUserId());
						session.setAttribute("sessionName", member.getName());
						session.setAttribute("sessionNickname", member.getNickname());
						session.setAttribute("sessionStatus", member.getStatus());
						
						session.setAttribute("sessionPoint", point.getTotalPoint());
						
						System.out.println(point.getTotalPoint());
						
					}
					
				}
				
			} else {
				Member idCheck = memberMapper.memberIdCheck(map);
				int cntUp = memberMapper.loginCntUp(map);
				
				if(idCheck.getCnt()>=5) {
					message = "비밀번호를 5회 이상 잘못 입력하셨습니다.";
					result = "fail";
				} else {
					if(idCheck.getCnt()==4) {
						message = "비밀번호를 5회 틀리셨습니다. \n로그인이 제한됩니다. \n관리자에게 문의해주세요.";
						result = "fail";
					} else {
						message = "비밀번호가 틀립니다.\n" + (4-member.getCnt()) + "회 남으셨습니다.";
						result = "fail";
					}
				}
			}
		} else {
			message = "아이디가 존재하지 않습니다.";
			result = "fail";
		}
		
		resultMap.put("msg", message);
		resultMap.put("result", result);
		
//		System.out.println(resultMap);
		
		return resultMap;
	}
	
	public HashMap<String, Object> memberLogout(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();

		String message = session.getAttribute("sessionNickname") + "님 로그아웃 되었습니다.";
		resultMap.put("msg", message);
		
		session.invalidate();//세션정보 전체 삭제
		
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
	
	public HashMap<String, Object> discMember(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			Member member = memberMapper.memberLogin(map);
			Point point = pointMapper.recentPoint(map);

			if(member != null) {
				session.setAttribute("sessionId", member.getUserId());
				session.setAttribute("sessionName", member.getName());
				session.setAttribute("sessionNickname", member.getNickname());
				session.setAttribute("sessionStatus", member.getStatus());
				
				session.setAttribute("sessionPoint", point.getTotalPoint());
				
				resultMap.put("msg", "로그인되었습니다.");
				resultMap.put("result", "success");
			} else {
				resultMap.put("msg", "로그인에 실패했습니다.");
				resultMap.put("result", "fail");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> joinKakao(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Random ran = new Random();
		String randomPwd = "";
		for(int i=0;i<8;i++) {
			int num = ran.nextInt(10);
			if(i==0 && num==0) {
				i--;
				continue;
			}
			randomPwd += num;
		}
//		System.out.println(randomPwd);
		String hashPwd = passwordEncoder.encode((String) randomPwd);
//		System.out.println(hashPwd);
		
		try {
			map.put("randomPwd", hashPwd);
			int cnt = memberMapper.kakaoMemberAdd(map);

			if(cnt > 0) {
				
				resultMap.put("msg", "가입되었습니다.");
				resultMap.put("result", "success");
			} else {
				resultMap.put("msg", "가입에 실패했습니다.");
				resultMap.put("result", "fail");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
		return resultMap;
	}
	
	public HashMap<String, Object> pwdConfirm(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
//		System.out.println(map);
//		String message = "";
		try {
			Member member = memberMapper.memberIdCheck(map);
//			System.out.println(member.getPassword());
			boolean pwdFlg = passwordEncoder.matches((String) map.get("pwd"), member.getPassword());
			
			if(pwdFlg) {
				resultMap.put("result", "success");
			} else {
//				String hashPwd = passwordEncoder.encode((String) map.get("pwd"));
//				map.put("hashPwd", hashPwd);
//				int cnt = memberMapper .memberPwdChange(map);
				resultMap.put("result", "fail");
				resultMap.put("msg", "기존 비밀번호와 다릅니다.");
//				resultMap.put("msg", "변경되었습니다.");
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "오류가 발생했습니다.");
			System.out.println(e.getMessage()); // e에 어떤 오류인지 담겨져 있음 -> 개발자가 오류를 확인하기 위해 사용하는 코드
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> addProfileImg(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		int cnt = memberMapper.insertProfileImg(map);
		if(cnt >0) {
			resultMap.put("result", "success");
		} else {
			resultMap.put("result", "fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> updateProfileImg(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		int cnt = memberMapper.updateProfileImg(map);
		
		if(cnt >0) {
			resultMap.put("result", "success");
			System.out.println("success");
		} else {
			resultMap.put("result", "fail");
			System.out.println("fail");
		}
		
		return resultMap;
	}
	
	public HashMap<String, Object> profileImgPath(HashMap<String, Object> map){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Member profileImgPath = memberMapper.profileImgPath(map);
		
		if(profileImgPath != null) {
			resultMap.put("result", "success");
			resultMap.put("info", profileImgPath);
		} 

		return resultMap;
	}
}
