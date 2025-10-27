package com.example.test1.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Member;

@Mapper
public interface MemberMapper {
	Member memberIdCheck(HashMap<String, Object> map);
	
	int memberAdd(HashMap<String, Object> map);
}
