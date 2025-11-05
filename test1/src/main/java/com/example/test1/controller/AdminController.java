package com.example.test1.controller;

import com.example.test1.dao.AdminService;
import com.example.test1.model.MainBoard;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdminController {
    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    // 관리자 페이지 진입 시 세션 값 전달
    @GetMapping("/admin-page.do")
    public String adminPage(HttpSession session, Model model) {
        model.addAttribute("sessionId", session.getAttribute("id"));
        model.addAttribute("sessionStatus", session.getAttribute("status"));
        model.addAttribute("sessionNickname", session.getAttribute("nickname"));
        model.addAttribute("sessionName", session.getAttribute("name"));
        model.addAttribute("sessionPoint", session.getAttribute("point"));
        return "/main-adminPage";
    }

    // 문의글 목록 조회
    @GetMapping("/api/inquiries")
    @ResponseBody
    public List<MainBoard> getInquiryBoards() {
        return adminService.getInquiryBoards();
    }

    // 댓글 등록 (MainBoard 사용)
    @PostMapping("/api/comment/write")
    @ResponseBody
    public String writeComment(@RequestParam String boardNo,
                               @RequestParam String userId,
                               @RequestParam String nickname,
                               @RequestParam String contents) {
        MainBoard mainboard = new MainBoard();
        mainboard.setBoardNo(boardNo);
        mainboard.setUserId(userId);
        mainboard.setNickname(nickname);
        mainboard.setContents(contents);
        mainboard.setAdopt("F"); // 기본값
        adminService.insertComment(mainboard);
        return "success";
    }

    // 댓글 목록 조회 (MainBoard 사용)
    @GetMapping("/api/comment/list")
    @ResponseBody
    public List<MainBoard> getComments(@RequestParam String boardNo) {
        return adminService.getCommentsByBoardNo(boardNo);
    }
    //삭제 구현
    @RequestMapping(value = "/comment-delete.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String deleteComment(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        resultMap = adminService.deleteComment(map);
        return new ObjectMapper().writeValueAsString(resultMap);
    }
    //불량유저
    @RequestMapping(value = "/user-block.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String blockUser(Model model, @RequestParam HashMap<String, Object> map) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();
        adminService.blockUser(map);
        resultMap.put("result", "success");
        return new ObjectMapper().writeValueAsString(resultMap);
    }
    //불량유저목록
    @RequestMapping(value = "/bad-users.dox", method = RequestMethod.GET, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getBadUsers(Model model) throws Exception {
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("badUsers", adminService.getBadUsers());
        return new ObjectMapper().writeValueAsString(resultMap);
    }
    //제한해제
    @RequestMapping(value = "/user-unblock.dox", method = RequestMethod.POST)
    @ResponseBody
    public String unblockUser(@RequestParam HashMap<String, Object> param) throws Exception {
        adminService.changeUserStatus(param);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", "success");
        return new ObjectMapper().writeValueAsString(resultMap);
    }

    // 신고 게시글
    @RequestMapping(value = "/report-list.dox", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String getReportList(@RequestParam HashMap<String, Object> param) throws Exception {
        List<HashMap<String, Object>> reportList = adminService.selectReportList(param);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("reportList", reportList);

        return new ObjectMapper().writeValueAsString(resultMap);
    }
    // 내게시글 / 내 댓글
    @RequestMapping("/myActivity.do")
    public String myActivityPage(HttpSession session, Model model) {
        String userId = (String) session.getAttribute("sessionId");
        model.addAttribute("sessionId", userId);
        return "/main-myComments";
    }

    @ResponseBody
    @RequestMapping("/getMyPosts.dox")
    public HashMap<String, Object> getMyPosts(@RequestParam String userId) {
        List<HashMap<String, Object>> posts = adminService.getMyPosts(userId);
        HashMap<String, Object> result = new HashMap<>();
        result.put("posts", posts);
        return result;
    }

    @ResponseBody
    @RequestMapping("/getMyComments.dox")
    public HashMap<String, Object> getMyComments(@RequestParam String userId) {
        List<HashMap<String, Object>> comments = adminService.getMyComments(userId);
        HashMap<String, Object> result = new HashMap<>();
        result.put("comments", comments);
        return result;
    }

    @PostMapping("/api/post/update")
    @ResponseBody
    public String updatePost(@RequestParam String boardNo,
                             @RequestParam String title,
                             @RequestParam String contents) {
        MainBoard post = new MainBoard();
        post.setBoardNo(boardNo);
        post.setTitle(title);
        post.setContents(contents);
        adminService.updatePost(post);
        return "success";
    }
    
    @PostMapping("/api/comment/delete")
    @ResponseBody
    public String deleteComment(@RequestParam String commentNo) {
    	adminService.deleteCommentById(commentNo);
        return "success";
    }
    
    @PostMapping("/api/comment/update")
    @ResponseBody
    public String updateComment(@RequestParam String commentNo,
                                @RequestParam String contents) {
        adminService.updateComment(commentNo, contents);
        return "success";
    }

}
