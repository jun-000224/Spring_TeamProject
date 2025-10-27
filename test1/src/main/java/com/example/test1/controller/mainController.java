package com.example.test1.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class mainController {
	
	@RequestMapping("/main-list.do") 
    public String login(Model model) throws Exception{ 
		
        return "main-list";
    }

}
