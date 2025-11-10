package com.example.test1.mapper;

import com.example.test1.model.reservation.Poi;
import com.example.test1.model.Reservation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ResMapper {

    Reservation selectReservationByResNum(@Param("resNum") Long resNum);

    int insertReservation(Reservation reservation);

    int insertPoi(Poi poi);

    List<Poi> selectPoisByResNum(@Param("resNum") Long resNum);

    int updatePackname(@Param("resNum") Long resNum, @Param("packName") String packName);

    int deleteReservation(@Param("resNum") Long resNum);

    int deletePoisByResNum(@Param("resNum") Long resNum);
}
