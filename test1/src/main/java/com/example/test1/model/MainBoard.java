package com.example.test1.model;

import lombok.Data;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

@Data
public class MainBoard {
    private String boardNo;
    private String userId;
    private String title;
    private String contents;
    private int fav;
    private int cnt;
    private String cdatetime;
    private String udatetime;
    private String type;
    private int reportCnt;
	private String commentNo;
	private String orgCmtNo;
	private String adopt;
	private String nickname;
	private String nickName; // ✅ 댓글용 닉네임 필드 추가
	
}
