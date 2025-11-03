package com.example.test1.controller;

import com.example.test1.dao.AdminService;
import com.example.test1.model.MainBoard;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

import javax.servlet.http.HttpSession;

@Controller
public class AdminController {
    private final AdminService adminService;
    
    @GetMapping("/admin-page.do")
    public String adminPage(HttpSession session, Model model) {
        // 세션 정보 설정
        model.addAttribute("sessionId", session.getAttribute("id"));
        model.addAttribute("sessionStatus", session.getAttribute("status"));
        model.addAttribute("sessionNickname", session.getAttribute("nickname"));
        model.addAttribute("sessionName", session.getAttribute("name"));
        model.addAttribute("sessionPoint", session.getAttribute("point"));

        return "/main-adminPage"; // JSP 파일 이름
    }
    
    
    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @GetMapping("/api/inquiries")
    @ResponseBody
    public List<MainBoard> getInquiryBoards() {
        return adminService.getInquiryBoards();
    }
}