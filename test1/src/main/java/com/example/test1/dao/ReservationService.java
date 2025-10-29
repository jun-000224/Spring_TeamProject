package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.ReservationMapper;
import com.example.test1.model.Board;
import com.example.test1.model.Comment;
import com.example.test1.model.User;

@Service
public class ReservationService {
	
	@Autowired
	ReservationMapper reservationMapper;
	


}
