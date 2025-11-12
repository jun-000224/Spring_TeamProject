package com.example.test1.model;

import lombok.Data;

@Data
public class Comment {
	private String commentNo;
	private int boardNo;
	private String userId;
	private String orgCmtNo;
	private String contents;
	private String adopt;
	private String cdateTime;
	private String udateTime;
	private String userNick;
	private boolean reported;
	
	private String title;
	private String storUrl;
	
	private String status;
}