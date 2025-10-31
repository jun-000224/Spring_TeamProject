package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;


import com.example.test1.model.Review;


@Mapper
public interface ReviewMapper {
	//나의 예약리스트
	List<Review> myResList(HashMap<String , Object> map);
	//후기리스트
	List<Review> reviewList(HashMap<String , Object> map);
	
	//평점 업데이트
	int rating(HashMap<String , Object>map);
	//후기등록하기
	int resInsert(HashMap<String , Object>map);
	//사진업로드
	int fileUpload(HashMap<String , Object>map);
	
	
}
