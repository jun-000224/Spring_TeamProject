package com.example.test1.dao;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MypageMapper;
import com.example.test1.model.Mypage;

@Service
public class MypageService {
	@Autowired
	MypageMapper mypageMapper;
	
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
}
