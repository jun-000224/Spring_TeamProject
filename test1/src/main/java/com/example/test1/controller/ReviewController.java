package com.example.test1.controller;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
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
	
	@RequestMapping("/review-fileUpload.dox")
	public String file(
	        @RequestParam("file1") MultipartFile multi,
	        @RequestParam("contentId") int contentId,
	        @RequestParam("userId") String userId,
	        @RequestParam(value="boardNo", required=false) Integer boardNo,
	        @RequestParam("title") String title,
	        HttpServletRequest request,
	        Model model) {

	    String path = "c:\\img";

	    try {
	        String originFilename = multi.getOriginalFilename();
	        String extName = originFilename.substring(originFilename.lastIndexOf("."));
	        String saveFileName = SaveFileName(extName);

	        System.out.println("uploadpath : " + path);
	        System.out.println("userId : " + userId);
	        System.out.println("boardNo : " + boardNo);
	        System.out.println("title : " + title);
	        System.out.println("saveFileName : " + saveFileName);

	        String path2 = System.getProperty("user.dir");
	        System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");

	        if (!multi.isEmpty()) {
	            // 파일 저장
	            File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
	            multi.transferTo(file);

	            // boardNo가 null이면 0으로 처리
	            int boardNoValue = (boardNo != null) ? boardNo : 0;

	            // 현재 boardNo 기준 max sortNo 조회
	            int maxSortNo = ReviewService.selectMaxSortNo(contentId);
	            int  newSortNo= maxSortNo + 1;
	          
	            HashMap<String, Object> map = new HashMap<>();
	            map.put("filename", saveFileName);
	            map.put("path", "../img/" + saveFileName);
	            map.put("contentId", contentId);
	            map.put("userId", userId);
	            map.put("boardNo", boardNoValue);
	            map.put("title", title);
	            map.put("sortNo", newSortNo);

	            System.out.println("Insert Map: " + map);
	            ReviewService.insertImg(map);

	            model.addAttribute("filename", originFilename);
	            model.addAttribute("uploadPath", file.getAbsolutePath());

	            return "redirect:list.do";
	        }

	    } catch (Exception e) {
	        System.out.println(e);
	    }

	    return "redirect:list.do";
	}
	    
	// 현재 시간을 기준으로 파일 이름 생성
	private String SaveFileName(String extName) {
		String fileName = "";
		
		Calendar calendar = Calendar.getInstance();
		fileName += calendar.get(Calendar.YEAR);
		fileName += calendar.get(Calendar.MONTH);
		fileName += calendar.get(Calendar.DATE);
		fileName += calendar.get(Calendar.HOUR);
		fileName += calendar.get(Calendar.MINUTE);
		fileName += calendar.get(Calendar.SECOND);
		fileName += calendar.get(Calendar.MILLISECOND);
		fileName += extName;
		
		return fileName;
	}

	
	
}
