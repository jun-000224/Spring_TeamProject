package com.example.test1.model;

import lombok.Data;

@Data
public class Comment {
	private String commentNo;
	private String boardNo;
	private String userId;
	private String orgCmtNo;
	private String contents;
	private String adopt;
	private String cdateTime;
	private String udateTime;
	private String nickName;
	
}
