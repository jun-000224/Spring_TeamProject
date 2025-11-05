package com.example.test1.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.test1.dao.PointService;
import com.google.gson.Gson;

@Controller
public class PointController {
	@Autowired
	PointService pointService;
	
	@RequestMapping("/point/myPoint.do") 
    public String addr(Model model) throws Exception{

    return "/point/mypoint";
	      
	}
	
	@RequestMapping(value = "/point/recent.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pointRecent(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = pointService.pointRecent(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/point/list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String pointList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = pointService.pointIncdec(map);
		
		return new Gson().toJson(resultMap);
	}
}
