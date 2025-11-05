package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.test1.model.Review;


@Mapper
public interface ReviewMapper {
	//나의 예약리스트
	List<Review> myResList(HashMap<String , Object> map);
	//후기게시판리스트
	List<Review> reviewList(HashMap<String , Object> map);
	
	//사용자후기리스트
	List<Review>  detailReviewList(HashMap<String , Object> map);
	
	//사용자 후기 이미지 리스트
	List<Review>  detailReviewImgList(HashMap<String , Object> map);
	//sortNo 구하기
	int selectMaxSortNo(@Param("contentId") int contentId);
	
	//평점 업데이트
	int rating(HashMap<String , Object>map);
	
	//조회수 업데이트
	int reviewCnt(HashMap<String , Object>map);
	//좋아요 리스트
	List<Review> selectFavorite(HashMap<String ,Object>map);
	
	//좋아요
	int favorite(HashMap<String, Object>map);
	
	//좋아요 개수
	int reviewFavorite(HashMap<String , Object>map);
	
	//좋아요 삭제
	
	int deletefavorite(HashMap<String , Object>map);
	
	//후기등록하기
	int resInsert(HashMap<String , Object>map);
	
	
	
	//사진업로드
	int fileUpload(HashMap<String , Object>map);
	//사진 이름
	List<String> selectOldImg(HashMap<String, Object> map);
	//사진 삭제
	int deleteImg(HashMap<String, Object> map);
	
	
}
