package com.example.test1.model;

import lombok.Data;

@Data
public class Review {
	private int resNum;
	private String userId;
	private String packname;
	private String price;
	private String themNum;
	private String descript;
	private String rdatetime;
	
	private int fav;
	private int cnt;
	private String cdatetime;
	private int boardNo;
	
	
}
