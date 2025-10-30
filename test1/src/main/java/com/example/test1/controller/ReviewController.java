package com.example.test1.controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.test1.dao.ReviewService;
import com.google.gson.Gson;

@Controller
public class ReviewController {
		
	@Autowired
	ReviewService ReviewService;
	
	@RequestMapping("/review-list.do") 
    public String reviewList(Model model) throws Exception{ 

        return "/review";
    }
	@RequestMapping("/review-add.do") 
    public String boardList(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		request.setAttribute("resNum", map.get("resNum"));
		
        return "/review-add";
    }
	
	@RequestMapping("/review-rating.do") 
    public String rating(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		request.setAttribute("resNum", map.get("resNum"));
		
        return "/review-rating";
    }
	
	

	
	@RequestMapping(value = "/reservation-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.getResList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/update-rating.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRating(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.updateRating(map);
		
		return new Gson().toJson(resultMap);
	}
	
	

	
	
}
