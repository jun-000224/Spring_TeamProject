package com.example.test1.controller;

import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.*;
import org.xml.sax.InputSource;

import com.example.test1.dao.ShareBoardViewService;
import com.google.gson.Gson;

@Controller
public class ShareBoardViewController {

	@Autowired
	ShareBoardViewService ShareBoardViewService;
	
    @GetMapping("/share.do")
    public String share() {
        return "/share-board-view";
    }

    @GetMapping(value = "/share.dox", produces = "application/json;charset=UTF-8")
//    @ResponseBody
//    public ResponseEntity<List<HashMap<String, Object>>> searchTour(@RequestParam String keyword) {
//        List<HashMap<String, Object>> data = ShareBoardViewService.getTourData(keyword);
//        return ResponseEntity.ok(data);
//    }
    
    //디테일
//    @ResponseBody
//    public ResponseEntity<List<HashMap<String, Object>>> searchTour(@RequestParam String keyword) {
//        List<HashMap<String, Object>> data = ShareBoardViewService.getTourData(keyword);
//        return ResponseEntity.ok(data);
//    }
    
	@ResponseBody
	public Map<Integer, List<HashMap<String, Object>>> getAllInfo(@RequestParam Map<String,Object> params) {
	    return ShareBoardViewService.fetchAllInfo(new HashMap<>(params));
	}

   
}
