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

    /**
     * 예약 정보와 POI 목록을 저장합니다.
     */
    @Transactional
    public Long saveNewReservation(ReservationList reservation, List<Poi> pois) {
        // 1. 예약 정보 저장 (RES_NUM은 selectKey로 먼저 생성되어 객체에 설정됨)
        resMapper.insertReservation(reservation);
        Long resNum = reservation.getResNum(); 

        // 2. POI 목록에 생성된 resNum 설정 후 저장
        for (Poi poi : pois) {
            poi.setResNum(resNum);
        }
        resMapper.insertPois(pois);

        return resNum;
    }

    /**
     * 예약 번호로 POI 기본 정보(ContentId, 좌표)를 조회합니다.
     */
    public List<Poi> getPoisByResNum(Long resNum) {
        return resMapper.selectPoisByResNum(resNum.intValue()); 
    }
    
    /**
     * 예약 목록 상세 조회 로직 
     */
    public ReservationList getReservationDetails(Long resNum) {
        List<Poi> pois = getPoisByResNum(resNum);

        ReservationList reservation = new ReservationList();
        reservation.setResNum(resNum);
        reservation.setPois(pois); 
        
        return reservation; 
    }
}