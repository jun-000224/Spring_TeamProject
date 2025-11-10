package com.example.test1.controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.test1.dao.ReviewService;
import com.google.gson.Gson;

@Controller
public class ReviewController {
	
	@Value("${kakao_javascript_key}")
    private String kakaoAppKey;
		
	@Autowired
	ReviewService ReviewService;
	
	@RequestMapping("/review-view.do") 
    public String reviewView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		request.setAttribute("resNum", map.get("resNum"));
		
        return "/review-view";
    }
	
	@RequestMapping("/review-add.do") 
    public String boardList(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		request.setAttribute("resNum", map.get("resNum"));
        return "/review-add";
    }
	
	@RequestMapping("review-detail.do") 
    public String reviewDetail(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		request.setAttribute("contentId", map.get("contentId"));
		
        return "/review-detail";
    }
	
	@RequestMapping("/review-rating.do") 
    public String rating(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		request.setAttribute("resNum", map.get("resNum"));
		
        return "/review-rating";
    }
	
	

	
	@RequestMapping(value = "/reservation-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.getResList(map);
		
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/review-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String reviewList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.getReviewList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/update-rating.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateRating(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.updateRating(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/review-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addReview(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.addReview(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/review-cnt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateReviewCnt(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = ReviewService.updateReviewCnt(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/review-favorite.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String favorite(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		boolean liked = ReviewService.favorite(map);
		resultMap.put("liked", liked);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/review-fileUpload.dox")
	public String file(
	        @RequestParam("file1") MultipartFile[] files, // 여러 파일 받기
	        @RequestParam("contentId") int contentId,
	        @RequestParam("userId") String userId,
	        @RequestParam(value="boardNo", required=false) Integer boardNo,
	        @RequestParam("title") String title,
	        HttpServletRequest request,
	        Model model) {

	    // 저장 경로
	    String path2 = System.getProperty("user.dir") + "\\src\\main\\webapp\\img";
	    int boardNoValue = (boardNo != null) ? boardNo : 0;

	    try {
	        // 1️ 기존 파일 삭제
	        HashMap<String, Object> delMap = new HashMap<>();
	        delMap.put("contentId", contentId);
	        delMap.put("boardNo", boardNoValue);
	        delMap.put("userId", userId);

	        List<String> oldFiles = ReviewService.selectImgs(delMap);
	        for(String filename : oldFiles) {
	            File oldFile = new File(path2, filename);
	            if(oldFile.exists()) oldFile.delete();
	        }
	        ReviewService.deleteImg(delMap);

	        // 2️ 새 파일 반복 처리
	        for(MultipartFile multi : files) {
	            if(!multi.isEmpty()) {
	                String originFilename = multi.getOriginalFilename();
	                String extName = originFilename.substring(originFilename.lastIndexOf("."));
	                String saveFileName = SaveFileName(extName);

	                // 파일 저장
	                File file = new File(path2, saveFileName);
	                multi.transferTo(file);

	                // DB insert
	                HashMap<String,Object> map = new HashMap<>();
	                map.put("filename", saveFileName);
	                map.put("path", "../img/" + saveFileName);
	                map.put("contentId", contentId);
	                map.put("userId", userId);
	                map.put("boardNo", boardNoValue);
	                map.put("title", title);

	                ReviewService.insertImg(map);
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return "redirect:list.do";
	}

	// 현재 시간을 기준으로 파일 이름 생성
	private String SaveFileName(String extName) {
	    Calendar calendar = Calendar.getInstance();
	    return "" +
	            calendar.get(Calendar.YEAR) +
	            calendar.get(Calendar.MONTH) +
	            calendar.get(Calendar.DATE) +
	            calendar.get(Calendar.HOUR) +
	            calendar.get(Calendar.MINUTE) +
	            calendar.get(Calendar.SECOND) +
	            calendar.get(Calendar.MILLISECOND) +
	            extName;
	}

	
	
}
