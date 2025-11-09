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

import com.example.test1.dao.BoardService;
import com.google.gson.Gson;

@Controller
public class BoardController {

	@Autowired
	BoardService boardService;
	
	@RequestMapping("/board-list.do") 
    public String boardList(Model model) throws Exception{ 

        return "/board-list";
    }
	@RequestMapping("/board-view.do") 
	
    public String view(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		System.out.println(map);
		request.setAttribute("boardNo", map.get("boardNo"));
		request.setAttribute("status", map.get("status"));
        return "/board-view";
    }
	@RequestMapping("/board-add.do") 
    public String add(Model model) throws Exception{ 

        return "/board-add";
    }
	
	
	@RequestMapping("/board-edit.do") 
	
    public String upView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		System.out.println(map);
		request.setAttribute("boardNo", map.get("boardNo"));
        return "/board-edit";
    }
	
	@RequestMapping("/board-comment-edit.do") 
	
    public String commentUpdate(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		System.out.println(map);
		request.setAttribute("commentNo", map.get("commentNo"));
		request.setAttribute("boardNo", map.get("boardNo"));
        return "/board-comment-edit";
    }
	
	@RequestMapping("/board-report.do") 
	
    public String report(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{ 
		System.out.println(map);
		request.setAttribute("userId", map.get("userId"));
        return "/board-report";
    }
	
	@RequestMapping("/wishlist.do") 
    public String wishlistList(Model model) throws Exception{ 

        return "/wish-list";
    }
	
	
	
	@RequestMapping("/main-Notice-View.do") 
    public String noticeView(HttpServletRequest request, Model model, @RequestParam HashMap<String, Object> map) throws Exception{
		System.out.println(map);
	request.setAttribute("boardNo", map.get("boardNo"));
	request.setAttribute("status", map.get("status"));
        return "/main-Notice-View";
    }
	
	@RequestMapping(value = "/board-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoardList(map);
		
		return new Gson().toJson(resultMap);
	}
	
	
	@RequestMapping(value = "/board-view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String boardView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.getBoard(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/comment/add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String add(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.addComment(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String remove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.removeList(map);
		
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/board-add.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String addBoardList(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.addBoardList(map);
		
		return new Gson().toJson(resultMap);
	}
	@RequestMapping(value = "/view-delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String viewRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.RemoveView(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String upView(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.viewUpdate(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping("/fileUpload.dox")
	public String result(@RequestParam("file1") MultipartFile multi, @RequestParam("boardNo") int boardNo, HttpServletRequest request,HttpServletResponse response, Model model)
	{
		
		String url = null;
		String path="c:\\img";
		try {

			//String uploadpath = request.getServletContext().getRealPath(path);
			String uploadpath = path;
			String originFilename = multi.getOriginalFilename();
			String extName = originFilename.substring(originFilename.lastIndexOf("."),originFilename.length());
			long size = multi.getSize();
			String saveFileName = genSaveFileName(extName);
			
//			System.out.println("uploadpath : " + uploadpath);
			System.out.println("originFilename : " + originFilename);
			System.out.println("extensionName : " + extName);
			System.out.println("size : " + size);
			System.out.println("saveFileName : " + saveFileName);
			String path2 = System.getProperty("user.dir");
			System.out.println("Working Directory = " + path2 + "\\src\\webapp\\img");
			if(!multi.isEmpty())
			{
				File file = new File(path2 + "\\src\\main\\webapp\\img", saveFileName);
				multi.transferTo(file);
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("fileName", saveFileName);
				map.put("path", "/img/" + saveFileName);
				map.put("boardNo", boardNo);
				map.put("orgName", originFilename);
				
				
				// insert 쿼리 실행
				boardService.addBoardImg(map);
				
				model.addAttribute("fileName", multi.getOriginalFilename());
				model.addAttribute("uploadPath", file.getAbsolutePath());
				
				return "redirect:list.do";
			}
		}catch(Exception e) {
			System.out.println(e);
		}
		return "redirect:list.do";
	}
	    
	// 현재 시간을 기준으로 파일 이름 생성
	private String genSaveFileName(String extName) {
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

	@RequestMapping(value = "/view-cDelete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String commRemove(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = boardService.commentRemove(map);
		
		return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-comment-edit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String updateComment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap = boardService.commentUpdate(map);
		
		return new Gson().toJson(resultMap);
	}
	
//	11.02
	@RequestMapping(value = "/comment-view.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String commentView(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.getComment(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-report.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String report(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.getComment(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-adopt.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String givePoint(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.pointGive(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-report-submit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String BoardReport(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.reportBoard(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/whish-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String getWhishList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.getWhishList(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/board-Creport-submit.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String comReport(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.reportCom(map);
	    return new Gson().toJson(resultMap);
	}
//	댓글 채택하기 (게시글당 1개)
	@RequestMapping(value = "/adopt-comment.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String adoptComment(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.adoptComment(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/main-Notice.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.listNotice(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/main-Notice-View.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String noticeView(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.viewNotice(map);
	    return new Gson().toJson(resultMap);
	}
	
	@RequestMapping(value = "/bestList.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public String bestList(@RequestParam HashMap<String, Object> map) throws Exception {
	    HashMap<String, Object> resultMap = boardService.bestList(map);
	    return new Gson().toJson(resultMap);
	}
	
}

