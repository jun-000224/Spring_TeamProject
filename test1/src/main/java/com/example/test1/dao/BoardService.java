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
	    HashMap<String, Object> resultMap = new HashMap<>();

	    try {
	        // 1️⃣ 게시글 조회수 증가
	        boardMapper.updateCnt(map);

	        // 2️⃣ 게시글 정보 + 댓글 목록
	        Board info = boardMapper.selectBoard(map);
	        List<Comment> commentList = boardMapper.selectCommentList(map);

	        // 3️⃣ 게시글 신고 여부 확인
	        int boardReportCheck = boardMapper.reportCheckBoard(map);

	        // 4️⃣ 각 댓글별 신고 여부 확인
	        for (Comment c : commentList) {
	            HashMap<String, Object> param = new HashMap<>();
	            param.put("userId", map.get("userId"));
	            param.put("commentNo", c.getCommentNo());

	            int commentReportCheck = boardMapper.reportCheckComment(param);
	            c.setReported(commentReportCheck > 0); // Comment VO에 boolean 필드 reported 추가
	        }

	        // 5️⃣ 결과 반환
	        resultMap.put("info", info);
	        resultMap.put("commentList", commentList);
	        resultMap.put("boardReportCheck", boardReportCheck > 0);
	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
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
		
		
try {
			int list = boardMapper.removeList(map);
			resultMap.put("list", list);
			resultMap.put("result", "success");
			resultMap.put("msg", "댓글이 삭제됨");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "서버오류 다시시도");
		}
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
	public void addBoardImg(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		int cnt = boardMapper.insertBoardImg(map);
		
	}
	
	public HashMap<String, Object> commentRemove(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
try {
			int num = boardMapper.viewComRemove(map);
			
			resultMap.put("result", "success");
			resultMap.put("msg", "삭제완료");
			System.out.println(map);
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "서버오류 다시시도");
		}
		return resultMap;
	}
	
	
	public HashMap<String, Object> commentUpdate(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			
			int comment = boardMapper.updateComment(map);
			
			resultMap.put("result", "success");
			resultMap.put("msg", "수정완료");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			resultMap.put("msg", "서버오류 다시시도");
		}
		return resultMap;
	
	}
	
//	11.02
	public HashMap<String, Object> getComment(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        int info = boardMapper.selectComment(map);
	        resultMap.put("result", "success");
	        resultMap.put("info", info);
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("msg", "댓글 조회 오류");
	    }
	    return resultMap;
	}
	
	
	public HashMap<String, Object> pointGive(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        int info = boardMapper.givePoint(map);
	        resultMap.put("result", "success");
	        resultMap.put("info", info);
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	        resultMap.put("msg", "포인트 지급 안됨");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> reportBoard(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	        int info = boardMapper.BoardReport(map);
	        resultMap.put("result", "success");
	        resultMap.put("info", info);
	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("msg", "게시글 신고 오류");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> reportCom(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    System.out.println("댓글 신고 파라미터: " + map);

	    try {
	        // 1️⃣ 이미 신고한 적 있는지 확인
	        int exists = boardMapper.reportCheckComment(map);

	        if (exists > 0) {
	            // 이미 신고한 경우 → 신고 불가 처리
	            resultMap.put("result", "fail");
	            resultMap.put("msg", "이미 신고하신 댓글입니다.");
	            return resultMap;
	        }

	        // 2️⃣ 처음 신고하는 경우 → INSERT
	        boardMapper.comReport(map);
	        resultMap.put("result", "success");

	    } catch (Exception e) {
	        e.printStackTrace();
	        resultMap.put("result", "fail");
	        resultMap.put("msg", "댓글 신고 오류");
	    }

	    return resultMap;
	}
	
	public HashMap<String, Object> getWhishList(HashMap<String, Object> map) {
	    HashMap<String, Object> resultMap = new HashMap<>();
	    try {
	    	List<Board> list = boardMapper.whishList(map);
	    	int cnt =boardMapper.cntWhishList(map);
	        resultMap.put("list", list);
	        resultMap.put("cnt", cnt);
	    } catch (Exception e) {
	        resultMap.put("result", "fail");
	    }
	    return resultMap;
	}
	
	public HashMap<String, Object> adoptComment(HashMap<String, Object> map) {
	    HashMap<String, Object> result = new HashMap<>();

	    try {
	        // ✅ boardNo를 Integer로 변환 (예외 방지)
	        if (map.get("boardNo") != null) {
	            map.put("boardNo", Integer.parseInt(map.get("boardNo").toString()));
	        }

	        // ✅ 이미 채택된 댓글이 있는지 확인
	        int alreadyAdopted = boardMapper.checkAlreadyAdopted(map);
	        if (alreadyAdopted > 0) {
	            result.put("result", "fail");
	            result.put("msg", "이미 채택된 댓글이 있습니다.");
	            return result;
	        }

	        // ✅ 댓글 채택 처리 (ADOPT = 'T')
	        boardMapper.updateAdoptStatus(map);

	        // ✅ 포인트 지급
	        boardMapper.givePoint(map);

	        result.put("result", "success");
	        result.put("msg", "댓글이 성공적으로 채택되었습니다!");

	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("result", "error");
	        result.put("msg", "오류가 발생했습니다: " + e.getMessage());
	    }

	    return result;
	}


	
}
