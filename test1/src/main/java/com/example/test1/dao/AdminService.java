package com.example.test1.dao;

import com.example.test1.mapper.AdminMapper;
import com.example.test1.model.MainBoard;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AdminService {
    private final AdminMapper adminMapper;

    public AdminService(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    public List<MainBoard> getInquiryBoards() {
        return adminMapper.selectInquiryBoards();
    }
}