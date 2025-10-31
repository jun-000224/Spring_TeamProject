package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Reservation;


@Mapper
public interface ReviewMapper {
	
	List<Reservation> ResList(HashMap<String , Object> map);  
	
	int rating(HashMap<String , Object>map);
	
	
	
}
