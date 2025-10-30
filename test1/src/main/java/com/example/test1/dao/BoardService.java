package com.example.test1.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.test1.mapper.BoardMapper;
import com.example.test1.mapper.UserMapper;
import com.example.test1.model.Board;
import com.example.test1.model.Comment;
import com.example.test1.model.User;

@Service
public class BoardService{
	
	@Autowired
	BoardMapper boardMapper;
	
	public HashMap<String, Object> getBoardList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List<Board> list = boardMapper.BoardList(map);
		int cnt = boardMapper.selectBoardCnt(map);
		
		resultMap.put("list", list);
		resultMap.put("cnt", cnt);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> getBoard(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			
			
			int cnt = boardMapper.updateCnt(map);
			Board info = boardMapper.selectBoard(map);
			List<Comment> commentList = boardMapper.selectCommentList(map);
			
			List<Board> fileList = boardMapper.selectFileList(map);
			resultMap.put("fileList", fileList);
			
			
			resultMap.put("info", info); 
			resultMap.put("commentList", commentList);
			resultMap.put("result", "success");
		}catch(Exception e) {
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}
	return resultMap;
	}
	
	
	
	
	
	
	public HashMap<String, Object> addComment(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			int cnt = boardMapper.insertComment(map);
			System.out.println(cnt);
			resultMap.put("result", "success");
			resultMap.put("msg", "댓글이 등록됨");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "서버오류 다시시도");
		}
		return resultMap;
	
	}
	public HashMap<String, Object> removeList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int list = boardMapper.removeList(map);
		
		
		resultMap.put("list", list);
		
		resultMap.put("result", "success");
		return resultMap;
	}
	
	public HashMap<String, Object> addBoardList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			int cnt = boardMapper.addBoard(map);
			System.out.println(cnt);
			resultMap.put("result", "success");
			resultMap.put("msg", "게시글 등록됨");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "서버오류 다시시도");
		}
		return resultMap;
	
	}
	public HashMap<String, Object> RemoveView(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int list = boardMapper.viewRemove(map);
		
		
		resultMap.put("list", list);
		
		resultMap.put("result", "success");
		return resultMap;
	}

	
	public HashMap<String, Object> viewUpdate(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			int cnt = boardMapper.updateView(map);
			
			resultMap.put("result", "success");
			resultMap.put("msg", "수정완료");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "서버오류 다시시도");
		}
		return resultMap;
	
	}
	
	
	
}
