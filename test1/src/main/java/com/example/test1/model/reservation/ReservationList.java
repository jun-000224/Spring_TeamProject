package com.example.test1.model.reservation;

import java.util.List;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ReservationList {
    
	private Long resNum;
	private String userId;
	private String packName; //패키지 이름 유저가 작성
	private Long price;
	private Integer areaNum;
	private String themNum; 
    
	private String descript;
	private String rdateTime;
	private String status;//결제 상태
	private String deadline;
	private String startDate;
	private String endDate;
	
	private List<Poi> pois; //연결된 poi리스트를 담는 핵심 필드
}