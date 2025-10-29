package com.example.test1.dao;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
import com.example.test1.model.Share;



@Service
public class ShareBoardViewService {

	@Value("${TOUR_KEY}")
	private String apiKey;
	
	@Autowired
	ShareBoardMapper ShareBoardMapper;
	
	//키워드로 검색하기
	public List<HashMap<String, Object>> getTourData(String keyword) {
		// TODO Auto-generated method stub
		List<HashMap<String, Object>> resultMap = new ArrayList<>();


		try {
           String url = "https://apis.data.go.kr/B551011/KorService2/searchKeyword2"			
                    + "?ServiceKey=" + apiKey
                    + "&MobileOS=ETC&MobileApp=AppTest"
                    + "&keyword=" + keyword;

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
                map.put("title", getTagValue(item, "title"));
                map.put("addr1", getTagValue(item, "addr1"));
                map.put("mapx", getTagValue(item, "mapx"));
                map.put("mapy", getTagValue(item, "mapy"));
                map.put("firstimage", getTagValue(item, "firstimage"));
                map.put("contentid", getTagValue(item, "contentid"));
                map.put("tel", getTagValue(item, "tel"));
                map.put("overview",getTagValue(item, "overview"));
                map.put("contentTypeId",getTagValue(item, "contentTypeId"));
                resultMap.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return resultMap;
    }

    private String getTagValue(Element element, String tagName) {
        NodeList list = element.getElementsByTagName(tagName);
        if (list != null && list.getLength() > 0) {
            return list.item(0).getTextContent();
        }
        return "";
    }
    //디테일 정보
    public List<HashMap<String, Object>> getInfo(String contentId) {
		// TODO Auto-generated method stub
		List<HashMap<String, Object>> resultMap = new ArrayList<>();

		
		try {
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
                resultMap.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
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
    public HashMap<String, Object> contentid(HashMap<String, Object> map){
    	HashMap<String, Object> resultMap = new HashMap<String, Object>();
    	
    	List<Share> info =ShareBoardMapper.sharInfo(map);
    	System.out.println(info);
    	
    	return resultMap;
    }
	
}
