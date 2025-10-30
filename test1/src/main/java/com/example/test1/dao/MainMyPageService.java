package com.example.test1.dao;

import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.MainMyPageMapper;
import com.example.test1.model.MainMyPage;

@Service
public class MainMyPageService {

    @Autowired
    private MainMyPageMapper mainMyPageMapper;

    @Autowired
    private HttpSession session; 

    public HashMap<String, Object> getMainMyPageInfo(HashMap<String, Object> map) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String userId = (String) map.get("userId");

        MainMyPage userInfo = mainMyPageMapper.selectMainMyPageInfo(userId);

        if (userInfo != null) {
           
            session.setAttribute("sessionNickname", userInfo.getNickname());
            session.setAttribute("sessionStatus", userInfo.getStatus());
            session.setAttribute("sessionPoint", userInfo.getPointTotal());

            resultMap.put("result", "success");
            resultMap.put("data", userInfo);
        } else {
            resultMap.put("result", "fail");
        }

        return resultMap;
    }
}
