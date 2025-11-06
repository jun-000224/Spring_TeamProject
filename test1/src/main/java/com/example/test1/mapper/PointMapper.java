package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Point;

@Mapper
public interface PointMapper {
	//최신일 기준 포인트 총량 조회
	Point recentPoint(HashMap<String, Object> map);
	//사용자별 포인트 증감량 조회
	List<Point> incdecPoint(HashMap<String, Object> map);
}
