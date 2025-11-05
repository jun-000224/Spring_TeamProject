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

	@ResponseBody
	public Map<Integer, List<HashMap<String, Object>>> getAllInfo(@RequestParam Map<String,Object> params) {
	    return ShareBoardViewService.fetchAllInfo(new HashMap<>(params));
	}

    @GetMapping(value = "/review-detail.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String Detail(@RequestParam HashMap<String, Object> map) throws Exception {
        String contentId = String.valueOf(map.get("contentId"));
        List<HashMap<String, Object>> resultList = ShareBoardViewService.DetailInfo(contentId);
        return new Gson().toJson(resultList);
    }
    
    @GetMapping(value = "/thumbnail.dox", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String, Object> thumbnail(@RequestParam HashMap<String, Object> param) {
        Map<String, Object> map = new HashMap<>();
        try {
            Map<Integer, HashMap<String, Object>> result = ShareBoardViewService.thumbnailMap(param);
            map.put("list", result);
            map.put("status", "success");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("status", "error");
        }
        return map;
    }
   
}
