package com.example.test1.mapper;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList; 
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ResMapper {

    /**
     * 🛑 [신규 추가] 예약 상세 정보 조회
     */
    ReservationList selectReservationByResNum(Long resNum);

    int insertReservation(ReservationList reservation);
    
    int insertPoi(Poi poi); 

    List<Poi> selectPoisByResNum(Long resNum);
    
}