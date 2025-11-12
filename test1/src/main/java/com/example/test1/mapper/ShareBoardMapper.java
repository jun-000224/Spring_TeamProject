package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Board;
import com.example.test1.model.Comment;
import com.example.test1.model.Share;
import com.example.test1.model.User;

@Mapper
public interface ShareBoardMapper {

	// 상세보기
	List<Share> sharInfo(HashMap<String , Object> map);
	List<Share> shareActive(HashMap<String , Object> map);

}
