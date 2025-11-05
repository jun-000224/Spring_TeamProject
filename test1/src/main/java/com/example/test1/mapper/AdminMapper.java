package com.example.test1.mapper;

import com.example.test1.model.MainBoard;
import org.apache.ibatis.annotations.Mapper;

import java.util.HashMap;
import java.util.List;

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



}
