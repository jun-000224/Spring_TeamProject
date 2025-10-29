package com.example.test1.controller;

import java.util.HashMap;

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
	@RequestMapping("/main-myPage.do") 
    public String myPage(Model model) throws Exception{ 
		
        return "main-myPage";
    }
	
//  --------------- 고객센터	
	@RequestMapping("/main-Service.do") 
    public String Service(Model model) throws Exception{ 
		
        return "main-Service";
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
	@RequestMapping("/main-Traveling.do") 
    public String Traveling(Model model) throws Exception{ 
		
        return "main-Traveling";
    }	
	
    @RequestMapping("/logout.do")
    public String logout(HttpSession session) {
        session.removeAttribute("sessionNickname"); // 닉네임만 제거
        return "redirect:/main-list.do"; // 메인 페이지로 이동
    }

}
