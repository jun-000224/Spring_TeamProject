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
	
	//게시글 등록
	int addBoard(HashMap<String , Object> map);
	
	//게시글 전체개수
	int selectBoardCnt(HashMap<String , Object> map);
	
	//게시글 조회수 증가
	int updateCnt(HashMap<String , Object> map);
	
	//view에서 게시글 삭제
	int viewRemove(HashMap<String , Object> map);
	
	//view에서 게시글 수정(board-edit)
	int updateView(HashMap<String , Object> map);
	
	//첨부파일(이미지) 업로드
	int insertBoardImg(HashMap<String, Object> map);
	
	//첨부파일 목록
	List<Board> selectFileList(HashMap<String, Object> map);
	
}
