
나의 말:
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>게시글 상세 | READY</title>

  <!-- Vendor -->
  <script src="https://code.jquery.com/jquery-3.7.1.js"
          integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
          crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <script src="/js/page-change.js"></script>

  <!-- Global CSS (있으면 유지) -->
  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">

  <!-- ===== READY Brand Overwrite ===== -->
  <style>
    :root{
      --brand:#1890FF;        /* 브랜드 블루 (맑고 가벼운 톤) */
      --brand-600:#1478D6;
      --bg:#F7F9FC;           /* 대시보드형 배경 */
      --card:#FFFFFF;
      --text:#1F2A37;         /* 차콜 계열 본문 */
      --muted:#6B7280;        /* 설명/보조 텍스트 */
      --line:#E5EAF0;
      --success:#16A34A;
      --danger:#DC3A3A;
      --shadow:0 8px 24px rgba(16,24,40,.06);
      --radius:14px;
    }

    /* Base */
    html,body{height:100%}
    body{
      margin:0;
      font-family: ui-sans-serif, -apple-system, BlinkMacSystemFont, 'Noto Sans KR', 'Segoe UI', Roboto, Arial, 'Apple SD Gothic Neo', sans-serif;
      color:var(--text);
      background:var(--bg);
      -webkit-font-smoothing:antialiased;
      -moz-osx-font-smoothing:grayscale;
    }

    /* Layout */
    .wrap{ width:min(1080px, 92vw); margin: 20px auto 72px; }
    .page-head{
      margin: 6px 0 18px;
    }
    .crumb{
      font-size:12px; color:var(--muted);
      display:flex; gap:8px; align-items:center; margin-bottom:10px;
    }
    .title{
      font-weight:800; font-size:24px; letter-spacing:-.2px;
      display:flex; align-items:flex-start; gap:12px; flex-wrap:wrap;
      margin:4px 0 6px;
    }
    .meta{
      display:flex; flex-wrap:wrap; gap:10px 16px; align-items:center;
      color:var(--muted); font-size:13px;
    }
    .meta .dot{ width:3px; height:3px; background:#C9D2DD; border-radius:50%; display:inline-block }

    /* Subtle link-like action (신고를 눈에 안 띄게) */
    .subtle-action{
      color:#9AA3AF; font-weight:600; font-size:12px;
      background:transparent; border:none; padding:4px 6px; border-radius:8px;
      cursor:pointer; text-decoration:none;
    }
    .subtle-action:hover{ color:#7D8896; background:#F3F5F9 }
    .subtle-action[disabled]{ opacity:.55; cursor:default }

    /* Card */
    .card{
      background:var(--card); border:1px solid var(--line); border-radius:var(--radius);
      box-shadow:var(--shadow); overflow:hidden;
    }

    /* Post body */
    .post{
      padding: 6px 20px 8px;
    }
    .post .table{
      width:100%; border-collapse:separate; border-spacing:0;
      border-radius:var(--radius);
      overflow:hidden;
    }
    .post .table tr{ border-bottom:1px solid var(--line) }
    .post .table tr:last-child{ border-bottom:0 }
    .post .table th{
      width:150px; text-align:left; color:#3A6EA5; background:#F5F9FF;
      padding:14px 16px; font-size:13px; font-weight:800; vertical-align:top;
      border-right:1px solid var(--line);
    }
    .post .table td{
      padding:14px 16px; font-size:15px; color:#2B3441;
    }
    .content{
      line-height:1.78; font-size:16px; word-break:break-word;
    }
    .content img{ max-width:100%; height:auto; border-radius:10px; display:block; margin:8px 0 }

    /* Actions (삭제/수정) */
    .actions{
      display:flex; justify-content:flex-end; gap:10px; margin:16px 4px 24px;
    }

    /* Buttons */
    .btn{
      appearance:none; border:none; cursor:pointer; user-select:none;
      padding:10px 14px; border-radius:12px; font-weight:700; font-size:14px;
      transition:transform .04s ease, background-color .18s ease, box-shadow .18s ease;
    }
    .btn:hover{ transform:translateY(-1px) }
    .btn:active{ transform:translateY(0) }
    .btn-primary{ background:var(--brand); color:#fff }
    .btn-primary:hover{ background:var(--brand-600) }
    .btn-success{ background:var(--success); color:#fff }
    .btn-danger{ background:var(--danger); color:#fff }
    .btn-ghost{ background:#fff; border:1px solid var(--line); color:#2b3441 }
    .btn-ghost:hover{ background:#F7FAFF }

    /* Badge */
    .badge{
      display:inline-flex; align-items:center; gap:6px;
      font-size:12px; font-weight:800; padding:6px 10px; border-radius:999px;
      background:#EAF7F1; color:var(--success); border:1px solid #D8F0E4;
    }

    /* Comment list */
    .comment-card{ margin-top:18px }
    #comment{
      width:100%; border-collapse:separate; border-spacing:0;
      background:var(--card); border:1px solid var(--line);
      border-radius:var(--radius); box-shadow:var(--shadow); overflow:hidden;
    }
    #comment tr{
      display:grid; grid-template-columns:160px 1fr auto auto auto auto; /* 마지막은 신고 */
      align-items:center; border-bottom:1px solid var(--line);
    }
    #comment tr:last-child{ border-bottom:0 }
    #comment th, #comment td{ padding:14px 16px; font-size:14px }
    #comment th:nth-child(1){ font-weight:800; color:#2b3441 }
    #comment th:nth-child(2){ font-weight:500; color:#2b3441 }
    #comment tr:hover{ background:#FAFCFF }

    .comment-text{ line-height:1.6; word-break:break-word }
    .comment-input{
      width:100%; border:1px solid var(--line); border-radius:10px; padding:10px 12px; font-size:14px;
      transition: box-shadow .18s ease, border-color .18s ease;
    }
    .comment-input:focus{
      outline:none; border-color:var(--brand); box-shadow:0 0 0 4px rgba(24,144,255,.12);
    }

    .comment-actions .btn{ padding:8px 12px; font-size:13px }

    /* 신고 셀: 링크형, 흐리게 */
    .comment-report-cell{
      text-align:right; padding-right:18px;
    }
    .comment-report-cell .subtle-action{ font-size:12px; padding:4px 6px }

    /* Composer */
    .composer{
      background:var(--card); border:1px solid var(--line); border-radius:var(--radius);
      box-shadow:var(--shadow); margin-top:18px; overflow:hidden;
    }
    #input{ width:100%; border-collapse:separate; border-spacing:0 }
    #input th{
      width:140px; background:#F5F9FF; color:#3A6EA5; text-align:left; padding:16px 18px; font-size:13px;
      border-right:1px solid var(--line); font-weight:800;
    }
    #input td{ padding:16px 18px }
    #input textarea{
      width:100%; min-height:92px; border:1px solid var(--line); border-radius:12px;
      padding:12px 14px; font-size:14px; line-height:1.6; resize:none;
      transition: box-shadow .18s ease, border-color .18s ease;
    }
    #input textarea:focus{ outline:none; border-color:var(--brand); box-shadow:0 0 0 4px rgba(24,144,255,.12) }
    #input td:last-child{ width:160px; text-align:center }

    /* Modal (톤다운) */
    .modal{
      position:fixed; inset:0; background:rgba(17,24,39,.38);
      display:flex; align-items:center; justify-content:center; z-index:999;
    }
    .modal_body{
      width:min(420px, 92vw);
      background:#fff; border-radius:16px; border:1px solid var(--line);
      box-shadow:0 20px 50px rgba(17,24,39,.18);
      padding:20px;
    }
    .modal_header{ font-size:18px; font-weight:800; margin-bottom:8px }
    .modal_desc{ font-size:13px; color:var(--muted); margin-bottom:10px }
    .modal textarea, .modal select{
      width:100%; border:1px solid var(--line); border-radius:12px; padding:10px 12px; font-size:14px;
    }
    .modal textarea{ min-height:130px; resize:none; line-height:1.6 }
    .modal_actions{ display:flex; gap:10px; justify-content:flex-end; margin-top:14px }

    /* Responsive */
    @media (max-width: 900px){
      #comment tr{ grid-template-columns:120px 1fr auto auto auto }
      .comment-report-cell{ grid-column: -2/-1; text-align:left; padding-left:16px }
    }
  </style>
</head>
<body>
<div id="app">
  <%@ include file="components/header.jsp" %>

  <div class="wrap">
    <!-- 상단: 크럼브 + 제목 + 메타 + 신고(링크형, 옆에) -->
    <div class="page-head">
      <div class="crumb">커뮤니티 <span class="dot"></span> 게시글</div>
      <div class="title">{{ info.title }}</div>
      <div class="meta">
        <span>작성자 {{ info.userId }}</span>
        <span class="dot"></span>
        <span>조회수 {{ info.cnt }}</span>
        <!-- 신고: 시선 분산을 위해 옅은 회색 링크형 + 아이콘 제거 -->
        <button v-if="!boardReportCheck" class="subtle-action" @click="fnReport(info.userId)">신고</button>
        <button v-else class="subtle-action" disabled>신고 완료</button>
      </div>
    </div>

    <!-- 본문 카드 -->
    <div class="card post">
      <table class="table">
        <tr>
          <th>제목</th>
          <td>{{ info.title }}</td>
        </tr>
        <tr>
          <th>작성자</th>
          <td>{{ info.userId }}</td>
        </tr>
        <tr>
          <th>조회수</th>
          <td>{{ info.cnt }}</td>
        </tr>
        <tr>
          <th>내용</th>
          <td><div class="content" v-html="info.contents"></div></td>
        </tr>
      </table>
    </div>

    <!-- 수정/삭제 -->
    <div class="actions" v-if="info.userId == userId || sessionStatus == 'A'">
      <button class="btn btn-danger" @click="fnRemove">삭제</button>
      <button class="btn btn-primary" @click="fnUpdate">수정</button>
    </div>

    <!-- 댓글 목록 -->
    <div class="comment-card">
      <table id="comment">
        <tr v-for="(item, index) in commentList" :key="item.commentNo">
          <th>{{ item.userId }}</th>

          <th class="comment-text">
            <span v-if="editIndex !== index">{{ item.contents }}</span>
            <input v-else class="comment-input" type="text" v-model="item.contents" />
          </th>

          <!-- 삭제 -->
          <td class="comment-actions" v-if="item.userId == userId || sessionStatus == 'A'">
            <button class="btn btn-ghost" @click="fncRemove(item.commentNo)">삭제</button>
          </td>

          <!-- 수정 -->
          <td class="comment-actions" v-if="item.userId == userId || sessionStatus == 'A'">
            <button class="btn btn-ghost" v-if="editIndex !== index" @click="editIndex = index">수정</button>
            <button class="btn btn-primary" v-else @click="fncUpdate(item.commentNo, item.contents)">완료</button>
          </td>

          <!-- 채택 -->
          <td>
            <span v-if="item.adopt === 'T' && info.type == 'Q '" class="badge">채택됨</span>
            <button
              v-else-if="info.userId == userId && item.userId !== userId && !adoptedExists && info.type == 'Q '"
              class="btn btn-success"
              @click="fnAdopt(item.commentNo, item.userId)">
              채택하기
            </button>
          </td>

          <!-- 신고 (링크형, 흐리게) -->
          <td class="comment-report-cell" v-if="item.userId != userId">
            <button
              v-if="!commentReportMap[item.commentNo]"
              class="subtle-action"
              @click="fnCReport(item.commentNo, item.userId)">
              신고
            </button>
            <button v-else class="subtle-action" disabled>신고 완료</button>
          </td>
        </tr>
      </table>
    </div>

    <!-- 댓글 작성 -->
    <div class="composer">
      <table id="input">
        <tr>
          <th>댓글</th>
          <td>
            <textarea v-model="contents" @keyup.enter="fnSave" placeholder="서로를 존중하는 댓글 문화를 지켜주세요."></textarea>
          </td>
          <td><button class="btn btn-primary" @click="fnSave">저장</button></td>
        </tr>
      </table>
    </div>
  </div>

  <!-- 게시글 신고 모달 (톤다운) -->
  <div v-if="reportFlg" class="modal" role="dialog" aria-modal="true">
    <div class="modal_body">
      <div class="modal_header">신고하기</div>
      <div class="modal_desc">신고 대상: <b>{{ reportedUserId }}</b></div>
      <select v-model="reportType">
        <option value="E">오류 제보</option>
        <option value="I">불편 사항</option>
        <option value="S">사기 신고</option>
      </select>
      <textarea class="mt-12" v-model="reason" placeholder="신고 사유를 입력하세요"></textarea>
      <div class="modal_actions">
        <button class="btn btn-ghost" @click="closeReportModal">취소</button>
        <button class="btn btn-primary" @click="submitReport">제출</button>
      </div>
    </div>
  </div>

  <!-- 댓글 신고 모달 (톤다운) -->
  <div v-if="CoReportFlg" class="modal" role="dialog" aria-modal="true">
    <div class="modal_body">
      <div class="modal_header">댓글 신고</div>
      <div class="modal_desc">신고 대상: <b>{{ reportedUserId }}</b></div>
      <select v-model="CreportType">
        <option value="E">오류 제보</option>
        <option value="I">불편 사항</option>
        <option value="S">사기 신고</option>
      </select>
      <textarea class="mt-12" v-model="comReason" placeholder="신고 사유를 입력하세요"></textarea>
      <div class="modal_actions">
        <button class="btn btn-ghost" @click="CcloseReportModal">취소</button>
        <button class="btn btn-primary" @click="CsubmitReport">제출</button>
      </div>
    </div>
  </div>

  <%@ include file="components/footer.jsp" %>
</div>

<script>
  const app = Vue.createApp({
    data(){
      return {
        info: {},
        boardNo: "${boardNo}",
        userId: "${sessionId}",
        status : "${sessionStatus}",
        sessionStatus : window.sessionData ? window.sessionData.status : "${sessionStatus}",

        contents: "",
        editIndex: -1,
        commentList: [],
        commentNo: "",
        type: "",
        editFlg: false,

        reportedUsers: [],
        reportFlg: false,
        reportedUserId: "",
        reason: "",
        reportType: "E",
        currentUserId: "${sessionId}",

        CoReportFlg: false,
        CReportTyle: "",
        comReason: "",
        CreportType: "E",

        adoptedExists: false,
        boardReportCheck: false,
        commentReportMap: {},
      };
    },
    methods:{
      fnInfo(){
        const self=this;
        $.ajax({
          url: "board-view.dox",
          type: "POST",
          dataType: "json",
          data: { boardNo: self.boardNo, userId: self.userId },
          success(data){
            self.info = data.info;
            self.commentList = data.commentList.map(c => ({ ...c, reported: c.reported === true }));
            self.commentReportMap = {};
            self.commentList.forEach(c => { if (c.reported) self.commentReportMap[c.commentNo] = true; });
            self.adoptedExists = self.commentList.some(c => c.adopt === 'T');
            self.boardReportCheck = data.boardReportCheck;
          }
        });
      },
      fnSave(){
        const self=this;
        const param = { boardNo:self.boardNo, userId:self.userId, contents:self.contents };
        $.ajax({
          url:"/comment/add.dox", type:"POST", dataType:"json", data:param,
          success(){
            self.contents=""; self.editFlg=false; self.fnInfo();
          }
        });
      },
      fnRemove(){
        const self=this;
        if(!confirm("정말로 삭제하시겠습니까?")) return;
        $.ajax({
          url:"/view-delete.dox", type:"POST", dataType:"json", data:{ boardNo:self.boardNo },
          success(data){
            if(data.result==="success"){ alert("삭제되었습니다!"); location.href="board-list.do"; }
            else{ alert("오류발생"); }
          }
        });
      },
      fnUpdate(){
        const self=this;
        pageChange("board-edit.do", { boardNo: self.boardNo });
      },
      fncRemove(commentNo){
        if(!confirm("정말로 삭제하시겠습니까?")) return;
        $.ajax({
          url:"/view-cDelete.dox", type:"POST", dataType:"json", data:{ commentNo },
          success(data){
            if(data.result==="success"){ alert("삭제되었습니다!"); this.fnInfo(); }
            else{ alert("오류발생"); }
          }
        });
      },
      fncUpdate(commentNo, content){
        $.ajax({
          url:"/board-comment-edit.dox", type:"POST", dataType:"json",
          data:{ commentNo, contents:content },
          success:()=>{ this.fnInfo(); this.editIndex=-1; this.editFlg=false; }
        });
      },
      fnAdopt(commentNo, commentUserId){
        $.ajax({
          url:"adopt-comment.dox", type:"POST", dataType:"json",
          data:{ boardNo:this.boardNo, commentNo, userId:commentUserId },
          success:(data)=>{
            if(data.result==="success"){ alert("채택 완료!"); this.fnInfo(); }
            else{ alert(data.msg || "오류 발생"); }
          }
        });
      },
      // 게시글 신고 (제목/메타 옆, 링크형)
      fnReport(reportedUserId){ this.reportedUserId = reportedUserId; this.reportFlg = true; },
      closeReportModal(){ this.reportFlg=false; this.reason=""; },
      submitReport(){
        const p = {
          reportType:this.reportType, reportedUserId:this.reportedUserId, reason:this.reason,
          boardNo:this.boardNo, userId:this.userId
        };
        $.ajax({
          url:"/board-report-submit.dox", type:"POST", dataType:"json", data:p,
          success:(data)=>{
            if(confirm("정말 신고하시겠습니까?")){
              if(data.result==="success"){ alert("신고가 접수되었습니다."); this.fnInfo(); this.closeReportModal(); }
              else{ alert("오류가 발생하였습니다."); }
            }
          }
        });
      },
      // 댓글 신고 (행 우측, 링크형)
      fnCReport(commentNo, reportedUserId){ this.reportedUserId=reportedUserId; this.commentNo=commentNo; this.CoReportFlg=true; },
      CcloseReportModal(){ this.CoReportFlg=false; this.comReason=""; },
      CsubmitReport(){
        if(!this.comReason){ alert("신고 사유를 입력해주세요."); return; }
        if(!confirm("정말 신고하시겠습니까?")) return;
        const p = {
          CreportType:this.CreportType, reportedUserId:this.reportedUserId, comReason:this.comReason,
          commentNo:this.commentNo, userId:this.userId
        };
        $.ajax({
          url:"/board-Creport-submit.dox", type:"POST", dataType:"json", data:p,
          success:(data)=>{
            if(data.result==="success"){
              alert("댓글 신고가 접수되었습니다.");
              this.commentReportMap[this.commentNo]=true;
              this.reportedUsers.push(this.reportedUserId);
              this.CcloseReportModal(); this.fnInfo();
            }else if (data.result==="duplicate"){
              alert("이미 신고하신 댓글입니다.");
              this.commentReportMap[this.commentNo]=true;
              this.CcloseReportModal();
            }else{
              alert("오류가 발생하였습니다.");
            }
          },
          error:()=> alert("서버와 통신 중 오류가 발생했습니다.")
        });
      }
    },
    mounted(){ this.fnInfo(); }
  });
  app.mount('#app');
</script>
</body>
</html> 