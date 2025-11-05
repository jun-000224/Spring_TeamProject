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



}