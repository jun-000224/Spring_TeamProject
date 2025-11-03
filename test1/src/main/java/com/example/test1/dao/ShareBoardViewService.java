package com.example.test1.dao;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.example.test1.mapper.ShareBoardMapper;
import com.example.test1.mapper.ReviewMapper;
import com.example.test1.model.Review;
import com.example.test1.model.Share;



@Service
public class ShareBoardViewService {

	@Value("${TOUR_KEY}")
	private String apiKey;
	
	@Autowired
	ShareBoardMapper ShareBoardMapper;
	
	@Autowired
	ReviewMapper reviewMapper;
	
    //디테일 정보
    public List<HashMap<String, Object>> getInfo(String contentId, String day , int dayNum)throws Exception {
		// TODO Auto-generated method stub
		List<HashMap<String, Object>> resultMap = new ArrayList<>();

		
		
			String url = "https://apis.data.go.kr/B551011/KorService2/detailCommon2"
                    + "?ServiceKey=" + apiKey
                    + "&MobileOS=ETC&MobileApp=AppTest"
                    + "&contentId=" + contentId;

            RestTemplate restTemplate = new RestTemplate();
            byte[] bytes = restTemplate.getForObject(url, byte[].class);
            String xmlResponse = new String(bytes); // 공공데이터가 EUC-KR인 경우

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            InputSource is = new InputSource(new StringReader(xmlResponse));

            Document doc = factory.newDocumentBuilder().parse(is);

            NodeList items = doc.getElementsByTagName("item");

            for (int i = 0; i < items.getLength(); i++) {
                Element item = (Element) items.item(i);
                HashMap<String, Object> map = new HashMap<>();
                map.put("title", getTag(item, "title"));
                map.put("addr1", getTag(item, "addr1"));
                map.put("mapx", getTag(item, "mapx"));
                map.put("mapy", getTag(item, "mapy"));
                map.put("firstimage", getTag(item, "firstimage"));
                map.put("contentid", getTag(item, "contentid"));
                map.put("tel", getTag(item, "tel"));
                map.put("overview",getTag(item, "overview"));
                map.put("homepage",getTag(item, "homepage"));
                map.put("day", day);
                map.put("dayNum", dayNum);
                resultMap.add(map);
            }
       
        return resultMap;
    }

    private String getTag(Element element, String tagName) {
        NodeList list = element.getElementsByTagName(tagName);
        if (list != null && list.getLength() > 0) {
            return list.item(0).getTextContent();
        }
        return "";
    }
  //contentId 리스트
    public Map<Integer, List<HashMap<String, Object>>> fetchAllInfo(HashMap<String, Object> map) {
        Map<Integer, List<HashMap<String, Object>>> dayMap = new HashMap<>();

        // DB에서 contentId 리스트 가져오기
        List<Share> shares = ShareBoardMapper.sharInfo(map);
       
        for (Share share : shares) {
            String contentId = String.valueOf(share.getContentId());
            if (contentId == null || contentId.isEmpty()) continue;

            int dayNum = share.getDayNum();
            String reserveDate = share.getDay();

            List<HashMap<String, Object>> infoList = new ArrayList<>();
            boolean success = false;
            int attempts = 0;
            int maxRetries = 5; // 최대 5번 재시도

            while (!success && attempts < maxRetries) {
                try {
                    infoList = getInfo(contentId, reserveDate, dayNum);
                    success = true; // 성공하면 반복 종료
                } catch (Exception e) {
                    attempts++;
                    
                    try {
                        Thread.sleep(1000); // 1초 대기 후 재시도
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                    }
                }
            }

            // 최대 재시도 후에도 실패하면 경고 출력하고 빈 리스트 처리
            if (!success) {
                infoList = new ArrayList<>();
            }
            Double rating = share.getRating();
            String content = share.getContent();
            // dayNum별로 안전하게 map에 추가
            for (HashMap<String, Object> infoMap : infoList) {
                if (infoMap.get("dayNum") != null) {
                    dayNum = Integer.parseInt(String.valueOf(infoMap.get("dayNum")));
                }
                if (rating != null) {
                    infoMap.put("rating", rating);
                    infoMap.put("content", content);
                } else {
                    infoMap.put("rating", 0); // 기본값
                }
                
                dayMap.computeIfAbsent(dayNum, k -> new ArrayList<>()).add(infoMap);
            }
        }

        return dayMap;
    }

  //디테일 정보
    public List<HashMap<String, Object>> DetailInfo(String contentId)throws Exception {
		// TODO Auto-generated method stub
		List<HashMap<String, Object>> resultMap = new ArrayList<>();

		
		
			String url = "https://apis.data.go.kr/B551011/KorService2/detailCommon2"
                    + "?ServiceKey=" + apiKey
                    + "&MobileOS=ETC&MobileApp=AppTest"
                    + "&contentId=" + contentId;

            RestTemplate restTemplate = new RestTemplate();
            byte[] bytes = restTemplate.getForObject(url, byte[].class);
            String xmlResponse = new String(bytes); // 공공데이터가 EUC-KR인 경우

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            InputSource is = new InputSource(new StringReader(xmlResponse));

            Document doc = factory.newDocumentBuilder().parse(is);

            NodeList items = doc.getElementsByTagName("item");
          
            HashMap<String, Object> map = new HashMap<>();
            for (int i = 0; i < items.getLength(); i++) {
                Element item = (Element) items.item(i);
                map.put("title", getTag(item, "title"));
                map.put("addr1", getTag(item, "addr1"));
                map.put("mapx", getTag(item, "mapx"));
                map.put("mapy", getTag(item, "mapy"));
                map.put("firstimage", getTag(item, "firstimage"));
                map.put("contentid", getTag(item, "contentid"));
                map.put("tel", getTag(item, "tel"));
                map.put("overview",getTag(item, "overview"));
                map.put("homepage",getTag(item, "homepage"));           
            }
            HashMap<String, Object> paramMap = new HashMap<>();
            paramMap.put("contentId", contentId);

            List<Review> reviewList = reviewMapper.detailReviewList(paramMap);
            List<Review> reviewImgList = reviewMapper.detailReviewImgList(paramMap);
            
           map.put("list", reviewList);
           map.put("imgList", reviewImgList);
          
           resultMap.add(map);
       
        return resultMap;
    }

	
}
