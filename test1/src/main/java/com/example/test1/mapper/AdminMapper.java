package com.example.test1.mapper;

import com.example.test1.model.MainBoard;
import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Mapper
public interface AdminMapper {
    List<MainBoard> selectInquiryBoards();
    // 댓글달기
    void insertComment(MainBoard mainboard);

    List<MainBoard> selectCommentsByBoardNo(String boardNo);
    
    void deleteComment(HashMap<String, Object> map);
    
    void updateUserStatus(HashMap<String, Object> map);

    List<HashMap<String, Object>> selectBadUsers();
    
    void changeUserStatus(HashMap<String, Object> param);

    List<HashMap<String, Object>> selectReportList(HashMap<String, Object> param);
    // 내 게시글 조회
    List<HashMap<String, Object>> selectMyPosts(Map<String, Object> param);
    // 내 댓글 조회
	List<HashMap<String, Object>> selectMyComments(String userId);
   
    //수정 삭제
	void deletePost(String boardNo);

    //  댓글 삭제
    void deleteCommentById(String commentNo);

	void updateComment(Map<String, Object> map);

	void updatePost(MainBoard post);
	
	HashMap<String, Object> selectBoardDetail(String boardNo);
	List<MainBoard> selectByBoardNo(String boardNo);

	String selectUserStatus(String userId);


}
