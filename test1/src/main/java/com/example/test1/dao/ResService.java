package com.example.test1.dao;

import com.example.test1.mapper.ResMapper;
import com.example.test1.model.reservation.Poi;
import com.example.test1.model.Reservation; // 🛑 [수정] Reservation DTO 사용
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class ResService {

    @Autowired
    private ResMapper resMapper;
    
    // TourAreaService 의존성 제거됨

    @Transactional
    public Long saveNewReservation(Reservation reservation, List<Poi> pois) {
        resMapper.insertReservation(reservation);
        Long resNum = Long.parseLong(reservation.getResNum()); 

        for (Poi poi : pois) {
            poi.setResNum(resNum);
            resMapper.insertPoi(poi); 
        }

        return resNum;
    }

    public List<Poi> getPoisByResNum(Long resNum) {
        return resMapper.selectPoisByResNum(resNum); 
    }
    
    public Reservation getReservationDetails(Long resNum) { // 🛑 [수정] Reservation DTO 반환
        // 1. DB에서 Reservation 기본 정보를 가져옵니다. 
        Reservation reservation = resMapper.selectReservationByResNum(resNum);
        
        if (reservation == null) {
            return null; 
        }

        // 2. POI 목록을 조회하여 DTO에 설정합니다.
        List<Poi> pois = getPoisByResNum(resNum);
        
        // 3. POI 목록을 Reservation 객체에 설정합니다.
        reservation.setPois(pois); 
        
        return reservation; 
    }
}