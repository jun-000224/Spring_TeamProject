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

import com.example.test1.dao.MypageService;
import com.google.gson.Gson;

@Controller
public class MypageController {
	@Autowired
	MypageService mypageService;
	
	
	
	@RequestMapping("/myReservation.do") 
    public String myReservation(Model model) throws Exception{

    return "/myReservation";
	      
	}
	
		
	
	@RequestMapping("/myInfo.do") 
    public String myInfo(Model model) throws Exception{

    return "/mypage/myInfo";
	      
	}

	@RequestMapping("/myInfo/detail.do") 
    public String infoDetail(Model model) throws Exception{

    return "/mypage/myInfo-detail";
	      
	}
	
	@RequestMapping("/myInfo/edit.do") 
    public String infoEdit(Model model) throws Exception{

    return "/mypage/myInfo-edit";
	      
	}
	
	@RequestMapping(value = "/mypage/myInfo.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String mymyinfo(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mypageService.mypageInfo(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/mypage/edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String myedit(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = mypageService.mypageEdit(map);
		
		return new Gson().toJson(resultMap);
	}

}
