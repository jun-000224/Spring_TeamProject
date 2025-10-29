package com.example.test1.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MemberMapper;
import com.example.test1.model.Member;

@Service
public class MemberService {
	@Autowired
	MemberMapper memberMapper;
	
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
		int cnt = memberMapper.memberAdd(map);

		if(cnt<1) {
			resultMap.put("result", "fail");
		} else {
			resultMap.put("result", "success");
		}
		
		return resultMap;
	}
}
