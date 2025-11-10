package com.example.test1.model;

import lombok.Data;

@Data
public class Member {
	private String userId;
	private String name;
	private String password;
	private String nickname;
	private String phone;
	private String birth;
	private String addr;
	private String status;
	private String email;
	private String subgrade;
	private String gender;
	private int cnt;
	private String endSubs;
	
	private String storUrl;
	private int mediaId;
}
