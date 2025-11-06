package com.example.test1.mapper;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList; 
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ResMapper {

    /**
     * 예약 정보 저장 (selectKey로 resNum 생성)
     */
    int insertReservation(ReservationList reservation);
    
    /**
     * POI를 개별적으로 삽입하기 위한 단일 삽입 메서드
     */
    int insertPoi(Poi poi); 

    /**
     * 예약 번호로 POI의 기본 정보를 조회합니다.
     */
    List<Poi> selectPoisByResNum(Long resNum); // Service에서 Long을 받도록 수정했으므로, 매퍼도 Long으로 변경

    /**
     * 🛑 [신규 추가] Content ID 기반으로 API 상세 정보를 조회하기 위한 매퍼 정의 (Service에서 API 호출로 구현)
     */
    Poi selectPoiDetailsByApi(@Param("contentId") String contentId);
}