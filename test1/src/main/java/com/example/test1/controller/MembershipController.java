package com.example.test1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MembershipController {
	@RequestMapping("/membership.do") 
    public String join(Model model) throws Exception{

    return "/membership/main";
	      
	}
}
