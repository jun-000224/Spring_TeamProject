package com.example.test1.mapper;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList; // 🎯 ReservationList 사용
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ResMapper {

    /**
     * 예약 정보 저장 (ReservationList 사용, resNum이 keyProperty로 반환되어야 함)
     */
    int insertReservation(ReservationList reservation);
    
    /**
     * 예약에 포함된 POI 목록 저장 (List<Poi> 사용)
     */
    int insertPois(@Param("list") List<Poi> pois);

    /**
     *예약 번호로 POI의 기본 정보(ContentId, 좌표)를 조회합니다.
     * 반환 타입: List<Poi>
     */
    List<Poi> selectPoisByResNum(int resNum);

    // ReservationList의 다른 필드를 조회하는 메서드도 필요할 수 있습니다 (예시)
    // ReservationList selectReservationDetails(Long resNum);
}