package com.example.test1.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Mypage;

@Mapper
public interface MypageMapper {
	//사용자 정보 상세
	Mypage mypageInfo(HashMap<String, Object> map);
	//사용자 정보 수정
	int mypageEdit(HashMap<String, Object> map);
}
