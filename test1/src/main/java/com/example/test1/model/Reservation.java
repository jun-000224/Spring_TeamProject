package com.example.test1.model;

import com.example.test1.model.reservation.Poi;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class Reservation {
    
	private String resNum;
	private String userId;
	private String packname; // 패키지 이름
	private String price;
	private String areaNum;
	private String themNum;
	private String descript; 
	private String rdatetime; // 예약한 날짜 (주문서 작성 날짜)
	private String startDate; // 여행 시작 날짜
	private String endDate; // 여행 종료 날짜
	private String status; // 결제 상태
    
	// 🛑 예산 관련 필드는 Float 타입
	private Float foodBudget;    // 식사 예산
	private Float accomBudget;   // 숙박 예산
	private Float etcBudget;     // 기타 예산
	private Float actBudget;     // 관광지 예산
    
    private String etcContent;   // 기타 사항 메모
    
	private List<Poi> pois; 
}