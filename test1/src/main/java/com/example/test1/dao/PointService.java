package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.PointMapper;
import com.example.test1.model.Point;

@Service
public class PointService {
	@Autowired
	PointMapper pointMapper;
	@Autowired
	HttpSession session;
	
	public HashMap<String, Object> pointRecent(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			Point point = pointMapper.recentPoint(map);
			
			session.setAttribute("sessionPoint", point.getTotalPoint());
			
			resultMap.put("info", point); 
			resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> pointIncdec(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
			List<Point> list = pointMapper.incdecPoint(map);
			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		return resultMap;
	}
}
