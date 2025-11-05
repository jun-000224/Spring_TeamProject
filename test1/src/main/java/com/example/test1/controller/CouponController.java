package com.example.test1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CouponController {
	@RequestMapping("/coupon/myCoupon.do") 
    public String addr(Model model) throws Exception{

    return "/coupon/myCoupon";
	      
	}
}
