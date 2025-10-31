package com.example.test1.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Member;

@Mapper
public interface MemberMapper {
	//아이디 중복 확인
	Member memberIdCheck(HashMap<String, Object> map);
	
	//회원 가입
	int memberAdd(HashMap<String, Object> map);
	
	//로그인
	Member memberLogin(HashMap<String, Object> map);
	
	//id 찾기
	Member memberIdFind(HashMap<String, Object> map);
	
	//비밀번호 재설정 전에 회원 확인
	Member memberPwdCheck(HashMap<String, Object> map);
	
	//비밀번호 변경
	int memberPwdChange(HashMap<String, Object> map);
	
	//로그인 실패 카운트
	int loginCntUp(HashMap<String, Object> map);
	
	//로그인 시도 횟수 초기화
	int loginCntReset(HashMap<String, Object> map);
	
	
}
