package com.example.test1.mapper;

import com.example.test1.model.reservation.Poi;
// import com.example.test1.model.reservation.ReservationList; // 🛑 [삭제] ReservationList DTO 사용 안 함
import com.example.test1.model.Reservation; // 🛑 [수정] Reservation DTO 사용
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ResMapper {


    Reservation selectReservationByResNum(Long resNum); // 🛑 [수정] Reservation DTO 사용

    int insertReservation(Reservation reservation);
    
    int insertPoi(Poi poi); 

    List<Poi> selectPoisByResNum(Long resNum);
}