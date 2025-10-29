package com.example.test1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReservationController {

    @GetMapping("/reservation.do")
    public String reservationView() {
        // /WEB-INF/views/reservation.jsp 로 포워딩
        return "reservation";
    }
}
