package com.example.test1.controller;

import java.util.HashMap;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ShareBoardViewController {

	
	@RequestMapping("/share.do") 
    public String share(Model model) throws Exception{

        return "/share-board-view";
    }
	
	
}
