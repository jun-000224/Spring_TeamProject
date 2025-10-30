package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Comment;
import com.example.test1.model.MainMyPage;

@Mapper
public interface MainMyPageMapper {
	
	MainMyPage selectMainMyPageInfo(String userId);

	
}
