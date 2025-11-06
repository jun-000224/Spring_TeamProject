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
            /* 📘 게시글 상세보기 테이블 */
            table {
                width: 80%;
                margin: 30px auto;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                overflow: hidden;

            }

            /* 게시글 테이블 헤더 (제목, 작성자, 조회수, 내용) */
            table:not(#comment):not(#input) th {
                background-color: #0078FF;
                /* 메인 색상 */
                color: white;
                font-weight: bold;
                padding: 15px;
                font-size: 16px;
                text-align: center;
                width: 15%;
                /* 헤더 너비 조정 */
                border: none;
            }

            /* 게시글 테이블 데이터 */
            table:not(#comment):not(#input) td {
                padding: 15px 20px;
                border-bottom: 1px solid #e0e0e0;
                font-size: 15px;
                text-align: center;
                font-weight: bold;
                vertical-align: top;
                font-weight: auto;

            }

            /* 제목과 내용이 들어가는 두 번째 칸 센터 */
            table:not(#comment):not(#input) tr:first-child td,
            table:not(#comment):not(#input) tr:nth-last-child(2) td {
                text-align: center;
                font-weight: bold;


            }

            /* 내용 표시 영역 (v-html 사용) */
            table:not(#comment):not(#input) td div {
                min-height: 100px;
                /* 내용 영역 최소 높이 확보 */
                line-height: 1.6;
                margin-top: 50px;
            }

            /* 버튼 영역 감싸는 div (게시글 수정/삭제) */
            .post-actions {
                width: 80%;
                margin: 0px auto 30px auto;
                text-align: left;
                /* 버튼을 오른쪽으로 배치 */

            }
            
            /* 버튼 스타일 통일 */
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
                margin-left: 10px;
                /* 버튼 간격 추가 */
            }

            button:hover {
                background-color: #005FCC;
            }

            /* 📗 삭제, 수정 버튼 따로 색 지정 */
            button.delete-btn {
                background-color: #d63b3b;
                margin-left: 1390px;
            }
            



            button.edit-btn {
                background-color: #00a769;
            }



            /* 📙 댓글 목록 (개선된 스타일) */
            #comment {
                width: 80%;
                /* 게시글 테이블과 너비 통일 */
                max-width: 900px;
                /* 최대 너비 설정 */
                margin: 40px auto 20px auto;
                /* 중앙 정렬 */
                border-collapse: collapse;
                background: #ffffff;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                overflow: hidden;
            }

            /* 댓글 목록의 행 (tr) - flex로 레이아웃 관리 */
            #comment tr {
                display: flex;
                align-items: center;
                /* 세로 중앙 정렬 */
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s;
            }

            #comment tr:last-child {
                border-bottom: none;
                /* 마지막 줄 하단 선 제거 */
            }

            /* 마우스 호버 효과 */
            #comment tr:hover {
                background-color: #f4f9ff;
            }

            /* 댓글 셀 (th, td 통합 스타일) */
            #comment tr th,
            #comment tr td {
                padding: 12px;
                font-size: 18px;
                color: #333;
                vertical-align: middle;
                font-weight: normal;
                text-align: center;
                box-sizing: border-box;
            }

            /* 1. 작성자 (TH) */
            #comment tr th:nth-child(1) {
                width: 150px;
                /* 작성자 너비 고정 */
                font-weight: bold;
                /* 작성자 강조 */
            }

            /* 2. 내용 (TH) */
            #comment tr th:nth-child(2) {
                flex-grow: 1;
                /* 남은 공간 모두 사용 */
                text-align: left;
                padding: 12px 20px;
            }

            /* 3. 삭제 버튼 (TD) */
            #comment tr td:nth-child(1) {
                width: 60px;
                /* 버튼 공간 확보 */
                padding: 12px 5px;
            }

            /* 4. 수정 버튼 (TD) */
            #comment tr td:nth-child(2) {
                width: 60px;
                /* 버튼 공간 확보 */
                padding: 12px 5px;
            }


            /* 댓글 버튼 공통 스타일 */
            #comment tr button {
                padding: 5px 8px;
                font-size: 16px;
                margin: 0;
                width: 100%;
                box-sizing: border-box;
            }

            /* --- 📱 모바일 환경 최적화 --- */
            @media (max-width: 768px) {
                #comment {
                    width: 95%;
                    /* 모바일에서 너비 확장 */
                }

                #comment tr {
                    flex-wrap: wrap;
                    /* 요소들을 줄바꿈 허용 */
                    padding: 10px 0;
                }

                /* 작성자와 내용 세로 배치 */
                #comment tr th:nth-child(1) {
                    /* 작성자 */
                    width: 30%;
                    text-align: left;
                    padding-left: 15px;
                }

                #comment tr th:nth-child(2) {
                    /* 내용 */
                    flex-basis: 100%;
                    /* 한 줄 전체 사용 */
                    text-align: left;
                    order: 3;
                    /* 내용을 맨 아래로 이동 */
                }

                /* 버튼들을 한 줄에 모아서 오른쪽으로 */
                #comment tr td:nth-child(1),
                #comment tr td:nth-child(2) {
                    width: 35%;
                    /* 버튼 영역을 좀 더 넓게 */
                    order: 2;
                    /* 작성자 옆에 배치 */
                    padding: 5px;
                }

                #comment tr button {
                    font-size: 10px;
                    padding: 5px;
                }
            }

            /* 📒 댓글 입력 영역 */
            #input {
                width: 30%;
                margin: 30px 650px;
                border-collapse: collapse;
                background: #f4f9ff;
                border-radius: 10px;
                padding: 15px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                display: flex;

            }

            #input th {
                background-color: #0078FF;
                color: white;
                padding: 15px;
                width: 100px;
                vertical-align: middle;
                border-radius: 8px 0 0 8px;
            }

            #input td:first-of-type {
                flex-grow: 1;
                padding: 15px;
                vertical-align: top;
            }

            #input td:last-of-type {
                width: 100px;
                padding: 15px;
                vertical-align: bottom;
            }

            #input textarea {
                width: 100%;
                height: 80px;
                border-radius: 6px;
                border: 1px solid #ccc;
                padding: 10px;
                resize: none;
                font-family: 'Noto Sans KR', sans-serif;
                font-size: 14px;
            }

            #input textarea:focus {
                outline: none;
                border-color: #0078FF;
                box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            }

            #input button {
                background-color: #0078FF;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 16px;
                cursor: pointer;
                height: 40px;
            }

            #input button:hover {
                background-color: #005FCC;
            }

            /* 📌 수평선 */
            hr {
                width: 80%;
                margin: 40px auto;
                border: 0;
                height: 1px;
                background-color: #ddd;
            }

            footer {
                margin-top: 30px;
            }

            .report {
                margin-left: 1600px;
                
            }

            /* 모달 css */
            .modal {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .modal_body {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                width: 300px;
            }

            .modal textarea {
                width: 300px;
                height: 300px;
            }

            .modal button {
                margin-left: 60px;

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
                    <button @click="fnReport(info.userId)">🚨신고하기</button> 
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
                <tr v-for="item in commentList" :key="item.commentNo">




                    <th>{{item.userId}}</th>

                    <th>
                        <span v-if="!editFlg">
                            {{item.contents}}
                        </span>
                        <input v-else type="text" v-model="item.contents">
                    </th>


                    <td v-if="item.userId == userId || status == 'A'">
                        <button @click="fncRemove(item.commentNo)">삭제</button>
                    </td>
                    <td v-if="item.userId == userId || status =='A'">
                        <button v-if="!editFlg" @click="fnflg">수정</button>
                        <button v-else @click="fncUpdate(item.commentNo,item.contents)">완료</button>
                    </td>

                    <td v-if="item.userId != userId || status =='A'">
                        <button @click="fnAdopt(item.commentNo, item.userId)">✅채택하기</button>
                    </td>

                    <!-- 코멘트 모달 -->
                    <td v-if="item.userId != userId">
                        <button @click="fnCReport(item.userId, item.commentNo)"
                            :disabled="reportedUsers.includes(item.userId)">
                            {{ reportedUsers.includes(item.userId) ? "신고완료" : "🚨신고하기" }}
                        </button>
                        
                    </td>
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
                </tr>


            </table>

            <!-- 댓글 작성 -->
            <table id="input">
                <th>댓글 입력</th>
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
                            self.editFlg = false;
                        }
                    });
                    // pageChange("board-comment-edit.do", { commentNo: commentNo, boardNo: boardNo });
                },


                fnAdopt: function (commentNo, userId) {
                    console.log("채택된 댓글 번호:", commentNo);
                    console.log("채택 대상 userId:", userId);

                    let self=this;
                    let param = {
                        userId: userId,  // 채택될 사람의 userId
                    };

                    $.ajax({
                        url: "/board-adopt.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);

                            if (confirm("정말로 채택하시겠습니까?")) {
                                if (data.result === "success") {
                                    alert("상대방에게 100pt가 지급되었습니다!");
                                    self.fnInfo();
                                } else {
                                    alert("오류가 발생했습니다");
                                }
                            }
                        }
                    });
                },

                //게시글 모달
                fnReport(reportedUserId, currentUserId) {
                    let self=this;
                    self.reportedUserId = reportedUserId;   // 신고 대상 지정
                    self.reportFlg = true;  // 모달 열기
                    self.currentUserId = self.sessionId;
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
                                    self.closeReportModal();
                                } else {
                                    alert("오류가 발생하였습니다.");
                                }
                            }
                        }
                    });
                },

                // 코멘트 모달
                fnCReport(reportedUserId, commentNo, currentUserId) {
                    let self=this;
                    
                    console.log(reportedUserId);
                    self.reportedUserId = reportedUserId;   // 신고 대상 지정
                    self.commentNo = commentNo;
                    
                    self.CoReportFlg = true;  // 모달 열기
                    self.currentUserId = sessionId;
                },
                CcloseReportModal() {
                    let self=this;
                    self.CoReportFlg = false; // 모달 닫기
                    self.comReason = "";       // 신고이유
                },
                CsubmitReport() {
                    let self = this;
                    const param = {
                        CreportType: self.CreportType,
                        reportedUserId: self.reportedUserId,
                        comReason: self.comReason,
                        commentNo: self.commentNo,
                        currentUserId : self.currentUserId
                    };
                    // Ajax로 서버에 신고 정보 전송
                    $.ajax({
                        url: "/board-Creport-submit.dox",
                        type: "POST",
                        data: param,
                        dataType: "json",
                        success: (data) => {
                            console.log(self.CreportType, self.reportedUserId, self.comReason, self.commentNo, self.currentUserId);
                            if (confirm("정말 신고하시겠습니까?")) {
                                //만약 reportedUsers에 해당하는 userId가 있으면 신고가 안되게 하고 만약 없으면 신고가 접수되게
                                if (data.result == "success") {
                                    alert("신고가 접수되었습니다.");

                                    //신고한 유저 ID를 reportedUsers 배열에 추가
                                    if (!self.reportedUsers.includes(self.reportedUserId)) {
                                        self.reportedUsers.push(self.reportedUserId);
                                        console.log(self.reportedUsers);
                                    }

                                    self.CcloseReportModal();
                                } else {
                                    alert("오류가 발생하였습니다.");
                                }
                            }
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