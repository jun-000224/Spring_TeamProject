package com.example.test1.dao;

import com.example.test1.mapper.AdminMapper;
import com.example.test1.model.Comment;
import com.example.test1.model.MainBoard;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {
    private final AdminMapper adminMapper;

    public AdminService(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    public List<MainBoard> getInquiryBoards() {
        return adminMapper.selectInquiryBoards();
    }

    public void insertComment(MainBoard mainboard) {
        adminMapper.insertComment(mainboard);
    }

    public List<MainBoard> getCommentsByBoardNo(String boardNo) {
        return adminMapper.selectCommentsByBoardNo(boardNo);
    }
    public HashMap<String, Object> deleteComment(HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> result = new HashMap<>();
        adminMapper.deleteComment(map);
        result.put("result", "success");
        return result;
    }
    
    public void blockUser(HashMap<String, Object> map) throws Exception {
    	adminMapper.updateUserStatus(map);
    }


    public List<HashMap<String, Object>> getBadUsers() throws Exception {
        return adminMapper.selectBadUsers();
    }
    
    public void changeUserStatus(HashMap<String, Object> param) throws Exception {
        adminMapper.changeUserStatus(param);
    }

    public List<HashMap<String, Object>> selectReportList(HashMap<String, Object> param) throws Exception {
        return adminMapper.selectReportList(param);
    }
    
    // ✅ 내 게시글 조회
    public List<HashMap<String, Object>> getMyPosts(String userId) {
        return adminMapper.selectMyPosts(userId);
    }

    // ✅ 내 댓글 조회
    public List<HashMap<String, Object>> getMyComments(String userId) {
        return adminMapper.selectMyComments(userId);
    }

    // 댓글 리스트 조회
    public List<MainBoard> getCommentsByBoardNo1(String boardNo) {
        return adminMapper.selectCommentsByBoardNo(boardNo);
    }
    
    // 수정 삭제
    public void deletePost(String boardNo) {
        adminMapper.deletePost(boardNo);
    }

    //  댓글 삭제
    public void deleteCommentById(String commentNo) {
        adminMapper.deleteCommentById(commentNo);
    }
 
    public void updateComment(String commentNo, String contents) {
        Map<String, Object> map = new HashMap<>();
        map.put("commentNo", commentNo);
        map.put("contents", contents);
        adminMapper.updateComment(map);
    }

    public void updatePost(MainBoard post) {
        adminMapper.updatePost(post);
    }
    // 신고된 게시글 번호
    public HashMap<String, Object> getBoardDetail(String boardNo) {
        return adminMapper.selectBoardDetail(boardNo);
    }

    public List<MainBoard> selectByBoardNo(String boardNo) {
        return adminMapper.selectCommentsByBoardNo(boardNo);
    }

    

}