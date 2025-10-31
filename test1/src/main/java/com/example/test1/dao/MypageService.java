package com.example.test1.dao;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MypageMapper;
import com.example.test1.model.Mypage;

@Service
public class MypageService {
	@Autowired
	MypageMapper mypageMapper;
	@Autowired
	HttpSession session;
	
	public HashMap<String, Object> mypageInfo(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Mypage mypage = mypageMapper.mypageInfo(map);

		resultMap.put("info", mypage);
		resultMap.put("result", "success");
		
		return resultMap;
	}
	
	public HashMap<String, Object> mypageEdit(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		int edit = mypageMapper.mypageEdit(map);
		
		if(edit>0) {
			resultMap.put("msg", "변경되었습니다.");
			resultMap.put("result", "success");
		} else {
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
		}

		return resultMap;
	}
	
	public HashMap<String, Object> mypageRemove(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = mypageMapper.mypageRelease(map);

		try {
			if(cnt>0) {
				session.invalidate();
				resultMap.put("result", "success");
				resultMap.put("msg", "탈퇴되었습니다.");
			} else {
				resultMap.put("msg", "오류가 발생했습니다.");
				resultMap.put("result", "fail");
			}
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println(e.getMessage());
			resultMap.put("msg", "시스템 오류가 발생했습니다.");
			resultMap.put("result", "fail");
		}
		
		
		return resultMap;
	}
	
	//탈퇴 전 확인(임시)(sms인증 복구 시 지울 예정)
	public HashMap<String, Object> mypageTemp(HashMap<String, Object> map) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		Mypage mypage = mypageMapper.mypageConfirm(map);

		if(mypage != null) {
			resultMap.put("info", mypage);
			resultMap.put("msg", "확인되었습니다.");
			resultMap.put("result", "success");
		} else {
			resultMap.put("msg", "오류가 발생했습니다.");
			resultMap.put("result", "fail");
		}
		
		
		return resultMap;
	}
	
	
}
