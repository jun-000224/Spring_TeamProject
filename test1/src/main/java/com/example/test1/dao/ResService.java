package com.example.test1.dao;

import com.example.test1.mapper.ResMapper;
import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class ResService {

    @Autowired
    private ResMapper resMapper;

    @Transactional
    public Long saveNewReservation(ReservationList reservation, List<Poi> pois) {
        resMapper.insertReservation(reservation);
        Long resNum = reservation.getResNum(); 

        for (Poi poi : pois) {
            poi.setResNum(resNum);
            resMapper.insertPoi(poi); 
        }

        return resNum;
    }

    public List<Poi> getPoisByResNum(Long resNum) {
        return resMapper.selectPoisByResNum(resNum); 
    }
    

 
    public ReservationList getReservationDetails(Long resNum) {
        // 1. DB에서 Reservation 기본 정보를 가져옵니다. (price, themNum 등 포함)
        ReservationList reservation = resMapper.selectReservationByResNum(resNum);
        
        if (reservation == null) {
            // 예외 처리 (예: 해당 예약이 없음)
            return null; 
        }

        // 2. DB에서 POI 목록을 가져옵니다.
        List<Poi> pois = getPoisByResNum(resNum);
        
        // 3. POI 목록을 Reservation 객체에 설정합니다.
        reservation.setPois(pois); 
        
        return reservation; 
    }
}