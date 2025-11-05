package com.example.test1.controller;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;



@Controller
public class mainController {
	
	@RequestMapping("/main-list.do") 
    public String list(Model model) throws Exception{ 
		
        return "main-list";
    }
	
//  --------------- 로그인 	
	@RequestMapping("/main-login.do") 
    public String login(Model model) throws Exception{ 
		
        return "main-login";
    }
	
//  --------------- 마이페이지	

	
//  --------------- 후기 게시판	
	@RequestMapping("/review-list.do") 
    public String review(Model model) throws Exception{ 
		
        return "review-list";
    }
	
//  --------------- 공지사항	
	@RequestMapping("/main-Notice.do") 
    public String Notice(Model model) throws Exception{ 
		
        return "main-Notice";
    }	
	
//  --------------- 커뮤니티	
	@RequestMapping("/main-Community.do") 
    public String Community(Model model) throws Exception{ 
		
        return "main-Community";
    }		
	
//  --------------- 여행하기	
	@RequestMapping("/reservation.do") 
    public String reservation(Model model) throws Exception{ 
		
        return "reservation";
    }	
	
    @RequestMapping("/logout.do")
    public String logout(HttpSession session) {
        session.removeAttribute("sessionNickname"); // 닉네임만 제거
        return "redirect:/main-list.do"; // 메인 페이지로 이동
    }
    
    @RequestMapping("/myComments.do")
    public String myCommentsPage(HttpServletRequest request, Model model) {
        // 로그인 세션 확인 등 필요한 처리
        return "main-myComments"; // main-myComments.jsp로 이동
    }
    

}
