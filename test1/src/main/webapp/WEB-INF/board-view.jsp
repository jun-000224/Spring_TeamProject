<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-images.css">
        <style>
            /* 🎨 기본 설정 */
body {
    font-family: 'Noto Sans KR', sans-serif;
    background: #f8f9fb;
    color: #333;
    margin: 0;
    padding: 0;
}

table {
    width: 80%;
    margin: 30px auto;
    border-collapse: collapse;
    background: #fff;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* ===========================
   📘 게시글 상세보기 테이블
=========================== */
table:not(#comment):not(#input) th {
    background-color: #0078FF;
    color: #fff;
    padding: 15px;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    border: none;
    width: 15%;
}

table:not(#comment):not(#input) td {
    padding: 15px 20px;
    border-bottom: 1px solid #eaeaea;
    font-size: 15px;
    text-align: center;
    vertical-align: top;
}

table:not(#comment):not(#input) td div {
    min-height: 100px;
    margin-top: 30px;
    line-height: 1.6;
}

/* 📎 게시글 수정/삭제 버튼 */
.post-actions {
    width: 80%;
    margin: 0 auto 30px auto;
    text-align: right;
}

/* ===========================
   📗 버튼 공통 스타일
=========================== */
button {
    background-color: #0078FF;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 10px 18px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.2s;
    margin-left: 8px;
}

button:hover {
    background-color: #005FCC;
}

/* 개별 버튼 색상 */
button.delete-btn {
    background-color: #d63b3b;
}

button.edit-btn {
    background-color: #00a769;
}

button.btn-success {
    background-color: #28a745;
}

button.btn-success:hover {
    background-color: #218838;
}

/* ===========================
   📙 댓글 목록
=========================== */
#comment {
    width: 80%;
    max-width: 900px;
    margin: 40px auto 20px;
    border-collapse: collapse;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

#comment tr {
    display: flex;
    align-items: center;
    border-bottom: 1px solid #eee;
    transition: background-color 0.2s;
}

#comment tr:hover {
    background-color: #f4f9ff;
}

#comment th,
#comment td {
    padding: 12px;
    font-size: 15px;
    text-align: center;
    color: #333;
}

#comment th:nth-child(1) {
    width: 120px;
    font-weight: bold;
}

#comment th:nth-child(2) {
    flex-grow: 1;
    text-align: left;
    padding: 12px 20px;
}

#comment td button {
    width: 100%;
    padding: 6px 8px;
    font-size: 13px;
}

/* 채택 표시 라벨 */
.adopted-label {
    color: #28a745;
    font-weight: bold;
}

/* ===========================
   📒 댓글 입력 영역
=========================== */
#input {
    width: 80%;
    background: #f4f9ff;
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    margin: 30px auto;
}

#input th {
    background-color: #0078FF;
    color: white;
    padding: 15px;
    width: 15%;
    border-radius: 8px 0 0 8px;
}

#input textarea {
    width: 100%;
    height: 80px;
    border-radius: 6px;
    border: 1px solid #ccc;
    padding: 10px;
    resize: none;
    font-size: 14px;
}

#input textarea:focus {
    outline: none;
    border-color: #0078FF;
    box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
}

/* ===========================
   📌 모달 (신고창)
=========================== */
.modal {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.45);
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal_body {
    background: #fff;
    padding: 25px;
    border-radius: 10px;
    width: 320px;
    text-align: center;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
}

.modal textarea {
    width: 100%;
    height: 120px;
    margin-top: 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    padding: 8px;
    resize: none;
}

.modal select {
    width: 100%;
    padding: 8px;
    margin-top: 8px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

/* ===========================
   📱 반응형
=========================== */
@media (max-width: 768px) {
    table, #comment, #input {
        width: 95%;
    }

    #comment tr {
        flex-wrap: wrap;
        padding: 10px 0;
    }

    #comment th:nth-child(1),
    #comment td {
        width: 100%;
        text-align: left;
    }

    #comment button {
        font-size: 12px;
        padding: 5px;
    }

    .modal_body {
        width: 90%;
    }
}

           
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <header>
                <div class="logo">
                    <a href="http://localhost:8081/main-list.do">
                        <!-- <img src="이미지.png" alt="Team Project"> -->
                    </a>
                </div>
                <h1 class="logo">
                    <a href="main-list.do" target="_blank">Team Project</a>
                </h1>
                <nav>
                    <ul>
                        <li class="main-menu"><a href="/main-Traveling.do">여행하기</a></li>
                        <li class="main-menu"><a href="/main-Community.do">커뮤니티</a></li>
                        <li class="main-menu"><a href="/main-Notice.do">공지사항</a></li>
                        <li class="main-menu"><a href="/main-Service.do">고객센터</a></li>
                        <!-- 마이페이지 / 관리자 페이지  -->
                        <li class="main-menu" v-if="status === 'U'">
                            <a href="/main-myPage.do">마이페이지</a>
                        </li>
                        <li class="main-menu" v-else-if="status === 'A'">
                            <a href="/admin-page.do">관리자 페이지</a>
                        </li>

                    </ul>
                </nav>

                <div style="display: flex; align-items: center; gap: 15px;">
                    <!-- 로그인 전 -->
                    <div class="login-btn" v-if="!isLoggedIn">
                        <button @click="goToLogin">로그인/회원가입</button>
                    </div>

                    <!-- 로그인 후 -->
                    <div class="user-info" v-else style="position: relative;">
                        <span @click="toggleLogoutMenu" class="nickname">{{ nickname }}님 환영합니다!</span>

                        <ul v-if="showLogoutMenu" class="logout-dropdown">
                            <li @click="goToMyPage">회원탈퇴</li>
                            <li @click="goToSettings">내 포인트 : </li>
                            <li @click="logout">로그아웃</li>
                        </ul>
                    </div>
                </div>

            </header>

            <table>

                <tr>
                    <th>제목</th>
                    <td>{{info.title}}</td>
                </tr>

                <tr>
                    <th>작성자</th>
                    <td>{{info.userId}}</td>

                </tr>
                <tr>
                    <th>조회수</th>
                    <td>{{info.cnt}}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        <div v-html="info.contents"></div>
                    </td>

                </tr>


                <!-- 게시글 모달 -->
                <div class="report">
  <button 
    v-if="!boardReportCheck" 
    @click="fnReport(info.userId)">
    🚨신고하기
  </button> 
  <button 
    v-else 
    disabled 
    style="color: gray; cursor: not-allowed;">
    ✅ 신고완료
  </button>
</div>


                <div v-if="reportFlg" class="modal">
                    <div class="modal_body">
                        <h2>🚨신고하기</h2>
                        <p>신고 대상: {{ reportedUserId }}</p>
                        <textarea v-model="reason" placeholder="신고 사유를 입력하세요"></textarea>

                        <div>● 신고유형 선택</div>
                        <div>
                            <select v-model="reportType">
                                <option value="E">오류제보</option>
                                <option value="I">불편사항</option>
                                <option value="S">사기신고</option>
                            </select>
                        </div>
                        <div>
                            <button @click="submitReport">제출</button>
                            <button @click="closeReportModal">취소</button>
                        </div>
                    </div>
                </div>





            </table>

            <div style="text-align:center;" v-if="info.userId == userId">
                <button class="delete-btn" @click="fnRemove">삭제</button>
                <button class="edit-btn" @click="fnUpdate">수정</button>
            </div>

            <hr>

            <!-- 댓글 코멘트 -->
            <table id="comment">
            <tr v-for="(item, index) in commentList" :key="item.commentNo">
                <th>{{ item.userId }}</th>
                <th>
                    <span v-if="editIndex !== index">
                        {{ item.contents }}
                    </span>
                    <input v-else type="text" v-model="item.contents">
                </th>
                <!-- 삭제 버튼 -->
                <td v-if="item.userId == userId || status == 'A'">
                    <button @click="fncRemove(item.commentNo)">삭제</button>
                </td>

                <!-- 수정 버튼 -->
                <td v-if="item.userId == userId || status =='A'" >
                    <button v-if="editIndex !== index" @click="editIndex = index">수정</button>
                    <button v-else @click="fncUpdate(item.commentNo, item.contents)">완료</button>
                </td>

                <!-- 채택 버튼 -->
                 <td>
                <div v-if="item.adopt === 'T' && info.type == 'Q '" class="adopted-label">✅ 채택된 댓글</div>
                <button
                    v-else-if="info.userId == userId && item.userId !== userId && !adoptedExists && info.type == 'Q '"
                    @click="fnAdopt(item.commentNo, item.userId)"
                    class="btn-success">
                    채택하기
                </button>
            </td>

                <!-- 🚨 신고 버튼 -->
                <td v-if="item.userId != userId">
  <button
    v-if="!item.reported && !reportedUsers.includes(item.userId)"
    @click="fnReport(item.userId, item.commentNo)">
    🚨 신고하기
  </button>
  <button
    v-else
    disabled
    style="color: gray; cursor: not-allowed;">
    ✅ 신고완료
  </button>
</td>
            </tr>
        </table>

<!-- ✅ 신고 모달 (테이블 밖으로 이동) -->
<div v-if="CoReportFlg" class="modal">
  <div class="modal_body">
    <h2>신고하기</h2>
    <p>신고 대상: {{ reportedUserId }}</p>
    <textarea v-model="comReason" placeholder="신고 사유를 입력하세요"></textarea>

    <div>● 신고유형 선택</div>
    <div>
      <select v-model="CreportType">
        <option value="E">오류제보</option>
        <option value="I">불편사항</option>
        <option value="S">사기신고</option>
      </select>
    </div>
    <div>
      <button @click="CsubmitReport">제출</button>
      <button @click="CcloseReportModal">취소</button>
    </div>
  </div>
</div>

            <!-- 댓글 작성 -->
            <table id="input">
                <th>댓글</th>
                <td>
                    <textarea cols="40" rows="4" v-model="contents" @keyup.enter="fnSave"></textarea>
                </td>
                <td>
                    <button @click="fnSave">저장</button>

                </td>

            </table>



            </table>
        </div>
        <footer>
            <div class="footer-content">
                <div class="footer-links" style="display: flex">
                    <div class="footer-section">
                        <h4>회사 소개</h4>
                        <ul>
                            <li><a href="#">회사 연혁</a></li>
                            <li><a href="#">인재 채용</a></li>
                            <li><a href="#">투자자 정보</a></li>
                            <li><a href="#">제휴 및 협력</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h4>지원</h4>
                        <ul>
                            <li><a href="#">고객센터</a></li>
                            <li><a href="#">자주 묻는 질문</a></li>
                            <li><a href="#">개인정보 처리방침</a></li>
                            <li><a href="#">이용 약관</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h4>여행 상품</h4>
                        <ul>
                            <li><a href="#">호텔</a></li>
                            <li><a href="#">항공권</a></li>
                            <li><a href="#">렌터카</a></li>
                            <li><a href="#">투어 & 티켓</a></li>
                        </ul>
                    </div>
                    <div class="footer-section">
                        <h4>문의 및 제휴</h4>
                        <ul>
                            <li><a href="#">파트너십 문의</a></li>
                            <li><a href="#">광고 문의</a></li>
                            <li><a href="#">이메일: team@project.com</a></li>
                            <li><a href="#">대표전화: 02-1234-5678</a></li>
                        </ul>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2025 Team Project. All Rights Reserved. | 본 사이트는 프로젝트 학습 목적으로 제작되었습니다.
                    </p>
                </div>
            </div>
        </footer>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    info: {},
                    boardNo: "${boardNo}",
                    userId: "${sessionId}",
                    contents: "",
                    editIndex:-1,
                    commentList: [],
                    commentNo: "${commentNo}",
                    type: "",
                    editFlg: false,


                    reportedUsers: [], //이미 신고한 사용자들의 ID저장용
                    reportFlg: false,   // 모달 표시 여부
                    reportedUserId: "",         // 신고 대상
                    reason: "",          // 신고 사유,
                    reportType: "E",
                    currentUserId: "${sessionId}", 

                    CoReportFlg: false,   // 모달 표시 여부
                    CReportTyle: "",         // 신고 유형
                    comReason: "",          // 신고 사유,
                    CreportType: "E",

                    adoptedExists: false,
                    boardReportCheck: false,      // 게시글 신고 여부
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnInfo: function () {

                    let self = this;
                    let param = {
                        boardNo: self.boardNo,
                        type: self.type,
                        userId:self.userId,
                        

                    };
                    $.ajax({
                        url: "board-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            self.info = data.info;
                            self.commentList = data.commentList;
                            self.commentList = data.commentList.map(c => ({
                                ...c,
                                reported: c.reported === true // boolean으로 변환
                            }));
                            self.adoptedExists = self.commentList.some(c => c.adopt === 'T')
                             self.boardReportCheck = data.boardReportCheck;
                            console.log(self.commentList);
                        }
                    });
                },
                fnSave: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo,
                        userId: self.userId,
                        contents: self.contents
                    };
                    $.ajax({
                        url: "/comment/add.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(self.boardNo, self.userId, self.contents);
                            self.contents = "";
                            self.editFlg = false;
                            self.fnInfo();
                        }
                    });
                },

                fnRemove: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo,
                    };
                    $.ajax({
                        url: "/view-delete.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                            if (confirm("정말로 삭제하시겠습니까?")) {
                                if (data.result == "success") {
                                    alert("삭제되었습니다!");
                                    location.href = "board-list.do";
                                }

                            } else {
                                alert("오류발생");
                            }
                        }
                    });
                },
                fnflg() {
                    let self = this;
                    if (self.userId == self.userId) {
                        self.editFlg = true;
                    } else {
                        self.editFlg = false;
                    }

                },

                fnUpdate: function () {

                    let self = this;
                    console.log(self.boardNo);
                    pageChange("board-edit.do", { boardNo: self.boardNo });

                },


                fncRemove: function (commentNo) {
                    let self = this;
                    if (!confirm("정말로 삭제하시겠습니까?")) {
                        return;
                    }
                    let param = {
                        commentNo: commentNo,
                    }
                    console.log(commentNo);

                    $.ajax({
                        url: "/view-cDelete.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {

                            if (data.result == "success") {
                                alert("삭제되었습니다!");
                                self.fnInfo();
                            } else {
                                alert("오류발생");
                            }
                        }
                    });
                },

                fncUpdate: function (commentNo, content) {
                    let self = this;
                    let param = {
                        commentNo: commentNo,
                        contents: content
                    }
                    $.ajax({
                        url: "/board-comment-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.fnInfo();
                            self.editIndex = -1;
                            self.editFlg = false;
                        }
                    });
                    // pageChange("board-comment-edit.do", { commentNo: commentNo, boardNo: boardNo });
                },


                fnAdopt(commentNo, commentUserId) {
  const self = this;
  $.ajax({
    url: "adopt-comment.dox",
    type: "POST",
    dataType: "json",
    data: { boardNo: self.boardNo, commentNo, userId: commentUserId },
    success(data) {
      if (data.result === "success") {
        alert("채택 완료!");
        self.fnInfo(); // ✅ 목록 다시 불러와 adoptedExists 갱신
      } else {
        alert(data.msg || "오류 발생");
      }
    }
  });
},

                //게시글 모달
                fnReport(reportedUserId) {
                    let self=this;
                    self.reportedUserId = reportedUserId;   // 신고 대상 지정
                    self.reportFlg = true;  // 모달 열기
                },
                closeReportModal() {
                    let self=this;
                    self.reportFlg = false; // 모달 닫기
                    self.reason = "";       // 신고이유
                },
                submitReport() {
                    let self=this;
                    const param = {
                        reportType: self.reportType,
                        reportedUserId: self.reportedUserId,
                        reason: self.reason,
                        boardNo: self.boardNo,
                        currentUserId : self.userId
                    };
                    // Ajax로 서버에 신고 정보 전송
                    $.ajax({
                        url: "/board-report-submit.dox",
                        type: "POST",
                        data: param,
                        dataType: "json",
                        success: (data) => {
                            console.log(self.reportType, self.reportedUserId, self.reason, self.boardNo, self.currentUserId);
                            if (confirm("정말 신고하시겠습니까?")) {
                                if (data.result == "success") {
                                    alert("신고가 접수되었습니다.");
                                    self.fnInfo();
                                    self.closeReportModal();
                                } else {
                                    alert("오류가 발생하였습니다.");
                                }
                            }
                        }
                    });
                },

                // 코멘트 모달
                fnCReport(reportedUserId, commentNo) {
    this.reportedUserId = reportedUserId; // 신고 대상
    this.commentNo = commentNo;
    this.CoReportFlg = true; // 모달 열기
},

CcloseReportModal() {
    this.CoReportFlg = false;
    this.comReason = "";
},

CsubmitReport() {
    const self = this;

    if (self.reportedUsers.includes(self.reportedUserId)) {
        alert("이미 신고한 사용자입니다.");
        self.CcloseReportModal();
        return;
    }

    if (!self.comReason) {
        alert("신고 사유를 입력해주세요.");
        return;
    }

    if (!confirm("정말 신고하시겠습니까?")) return;

    const param = {
        CreportType: self.CreportType,
        reportedUserId: self.reportedUserId,
        comReason: self.comReason,
        commentNo: self.commentNo,
        userId: self.currentUserId
    };

    $.ajax({
        url: "/board-Creport-submit.dox",
        type: "POST",
        data: param,
        dataType: "json",
        success: (data) => {
            if (data.result === "success") {
                alert("신고가 접수되었습니다.");

                // 신고한 유저 ID를 reportedUsers 배열에 추가
                self.reportedUsers.push(self.reportedUserId);

                // 모달 닫기 및 목록 갱신
                self.CcloseReportModal();
                self.fnInfo();
            } else if (data.result === "duplicate") {
                alert("이미 신고하신 댓글입니다.");
                self.reportedUsers.push(self.reportedUserId);
                self.CcloseReportModal();
            } else {
                alert("오류가 발생하였습니다.");
            }
        },
        error: () => {
            alert("서버와 통신 중 오류가 발생했습니다.");
        }
    });
}


            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnInfo();
            }
        });

        app.mount('#app');
    </script>