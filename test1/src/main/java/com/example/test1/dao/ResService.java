package com.example.test1.dao;

import com.example.test1.mapper.ResMapper;
import com.example.test1.model.reservation.Poi;
import com.example.test1.model.reservation.ReservationList;
import com.example.test1.model.reservation.TourPoiEnvelope.PoiItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Service
public class ResService {

    @Autowired
    private ResMapper resMapper;
    
    @Autowired
    private TourAreaService tourAreaService; 

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
    
    /*
    public Poi getPoiDetailsByContentId(String contentId) {
        Optional<PoiItem> optionalDetails = tourAreaService.getSinglePoiDetails(contentId);

        if (optionalDetails.isPresent()) {
            PoiItem data = optionalDetails.get();
            Poi poi = new Poi();
            
            poi.setContentId(Long.parseLong(contentId));
            poi.setPlaceName(data.getTitle()); 
            
            return poi;
        }
        return null;
    }
    */

    public ReservationList getReservationDetails(Long resNum) {
        List<Poi> pois = getPoisByResNum(resNum);

        ReservationList reservation = new ReservationList();
        reservation.setResNum(resNum);
        reservation.setPois(pois); 
        
        return reservation; 
    }
}