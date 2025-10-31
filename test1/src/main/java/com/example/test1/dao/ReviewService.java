package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.test1.mapper.ReviewMapper;

import com.example.test1.model.Reservation;


@Service
public class ReviewService{
	
	@Autowired
	ReviewMapper ReviewMapper;
	
	public HashMap<String, Object> getResList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Reservation> List = ReviewMapper.ResList(map);
		
		resultMap.put("list", List);
		return resultMap;
	}
	
	public HashMap<String, Object> updateRating(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt = ReviewMapper.rating(map);
		
		
		return resultMap;
	}
	
	
}
