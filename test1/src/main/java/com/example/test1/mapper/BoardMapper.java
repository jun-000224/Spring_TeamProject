package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Board;
import com.example.test1.model.Comment;
import com.example.test1.model.User;

@Mapper
public interface BoardMapper {
	
	//게시글 목록
	List<Board> BoardList(HashMap<String , Object> map);
	
	//게시글 상세보기
	Board selectBoard(HashMap<String , Object> map);
	
	
	//댓글 목록
	List<Comment> selectCommentList(HashMap<String , Object> map);
	
	//댓글 등록
	int insertComment(HashMap<String , Object> map);
	
	//댓글 삭제
	int removeList(HashMap<String , Object> map);
}
