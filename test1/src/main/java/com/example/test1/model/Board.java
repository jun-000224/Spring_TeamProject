package com.example.test1.model;

import lombok.Data;

@Data
public class Board {
	private String boardNo;
	private String userId;
	private String title;
	private String contents;
	private String fav;
	private String cnt;
	private String cdateTime;
	private String udateTime;
	private String type;
	private int commentCnt;
	private int commentNo;
	private String cdate;
	
	
	
	private String fileNo;
	private String filePath;
	private String fileName;
	
	private String themNum;
	private String descript;
	
	private String liked;
	private int resNum;
	private int price;
	private String Iduser;
}
