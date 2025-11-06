package com.example.test1.mapper;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Mypage;
import com.example.test1.model.MypageEditBirth;
import com.example.test1.model.MypageEditEmail;
import com.example.test1.model.MypageEditPhone;

@Mapper
public interface MypageMapper {
	//사용자 정보 상세
	Mypage mypageInfo(HashMap<String, Object> map);
	//사용자 정보 수정
	int mypageEdit(HashMap<String, Object> map);
	//회원 탈퇴
	int mypageRelease(HashMap<String, Object> map);
	//탈퇴 전 확인(임시)(sms인증 복구 시 지울 예정)
	Mypage mypageConfirm(HashMap<String, Object> map);
	//구독 결제 성공 시, 등급 변경
	int updateStatus(HashMap<String, Object> map);
	//수정용 생일 데이터
	MypageEditBirth editBirth(HashMap<String, Object> map);
	//수정용 전화번호 데이터
	MypageEditPhone editPhone(HashMap<String, Object> map);
	//수정용 이메일 데이터
	MypageEditEmail editEmail(HashMap<String, Object> map);
}
