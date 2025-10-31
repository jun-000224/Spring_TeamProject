package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.test1.controller.mainController;
import com.example.test1.mapper.ReviewMapper;

import com.example.test1.model.Reservation;
import com.example.test1.model.Review;


@Service
public class ReviewService{

	
	@Autowired
	ReviewMapper ReviewMapper;
	
	//나의예약리스트
	public HashMap<String, Object> getResList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Review> List = ReviewMapper.myResList(map);
		
		resultMap.put("list", List);
		return resultMap;
	}
	//리뷰게시판 리스트
	public HashMap<String, Object> getReviewList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Review> List = ReviewMapper.reviewList(map);
		
		resultMap.put("list", List);
		return resultMap;
	}
	
	public HashMap<String, Object> updateRating(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		System.out.println(map);
		int cnt = ReviewMapper.rating(map);
		resultMap.put("contentId", map.get("contentId"));

		return resultMap;
	}
	
	public HashMap<String, Object> addReview(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			int cnt = ReviewMapper.resInsert(map);
			resultMap.put("result", "success");
			resultMap.put("msg", "등록되었습니다");
			
		} catch (Exception e) {
			// TODO: handle exception
			System.out.print(e.getMessage());
			resultMap.put("result", "fail");
			resultMap.put("msg", "이미 등록한 글입니다.");
		}
		
		
		return resultMap;
	}
	
	public HashMap<String, Object> insertImg(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		int cnt = ReviewMapper.fileUpload(map);
		
		return resultMap;
	}
	
}
