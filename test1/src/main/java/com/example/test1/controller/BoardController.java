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
	

	
	
}
