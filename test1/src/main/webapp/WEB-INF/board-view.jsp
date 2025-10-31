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
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
                overflow: hidden;
                text-align: center;
            }

            th {
                background-color: #0078FF;
                color: white;
                font-weight: bold;
                padding: 12px;
                font-size: 15px;
                text-align: center;
                width: 20%;
            }

            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                font-size: 14px;
                text-align: center;
                font-weight: bold;
            }

           
            td:nth-child(2) {
                text-align: center;
            }

            /* 버튼 영역 */
            table+div {
                display: inline-block;
                margin: 10px 5px;
            }

            button {
                background-color: #0078FF;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 8px 14px;
                font-size: 14px;
                cursor: pointer;
                transition: 0.2s;
            }

            button:hover {
                background-color: #005FCC;
            }

            /* 📗 삭제, 수정 버튼 따로 색 지정 */
            button.delete-btn {
                background-color: #ff5252;
            }

            button.delete-btn:hover {
                background-color: #d63b3b;
            }

            button.edit-btn {
                background-color: #00A86B;
            }

            button.edit-btn:hover {
                background-color: #008f5a;
            }

            /* 📙 댓글 목록 */
            #comment {
                width: 80%;
                margin: 40px auto 20px auto;
                border-collapse: collapse;
                background: #f9fbff;
                border-radius: 10px;
                overflow: hidden;
                text-align: center;
            }

            #comment th,
            #comment td {
                padding: 12px;
                border-bottom: 1px solid #eee;
                font-size: 14px;
                color: #ffffff;
            }

            #comment tr:hover {
                background-color: #f4f9ff;
            }

            /* 📒 댓글 입력 영역 */
            #input {
                width: 80%;
                margin: 30px auto;
                border-collapse: collapse;
                background: #f4f9ff;
                border-radius: 10px;
                padding: 15px;
                text-align: center;
            }

            #input th {
                background-color: #0078FF;
                color: white;
                padding: 10px;
                width: 100px;
            }

            #input td {
                padding: 10px;
                vertical-align: middle;
            }

            #input textarea {
                width: 100%;
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
                padding: 8px 16px;
                cursor: pointer;
            }

            #input button:hover {
                background-color: #005FCC;
            }

            /* 📌 수평선 */
            hr {
                width: 80%;
                margin: 40px auto;
                border: 1px solid #ddd;
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
                <div style="text-align:center;" v-if="info.userId == sessionId">
                    <button class="delete-btn" @click="fnRemove">삭제</button>
                    <button class="edit-btn" @click="fnUpdate">수정</button>
                </div>





            </table>

            <hr>

            <!-- 댓글 코멘트 -->
            <table id="comment">
                <tr v-for="item in commentList" :key="item.commentNo">
                    

                    <th>{{item.commentNo}}</th>

                    <th>{{item.userId}}</th>

                    <th>
                        {{item.contents}}
                    </th>

                    <!--수정사항-->
                    <div v-if="info.userId == sessionId">
                        <td><button @click="fncRemove(item.commentNo)">삭제</button></td>
                        <td><button @click="fncUpdate(item.commentNo)">수정</button></td>

                    </div>

                </tr>


            </table>

            <!-- 댓글 작성 -->
            <table id="input">
                <th>댓글 입력</th>
                <td>
                    <textarea cols="40" rows="4" v-model="contents"></textarea>
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
                    sessionId: "${sessionId}",
                    contents: "",
                    commentList : [],
                    commentNo : "${commentNo}"
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnInfo: function () {

                    let self = this;
                    let param = {
                        boardNo: self.boardNo,

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
                        sessionId : self.sessionId,
                        contents: self.contents
                    };
                    $.ajax({
                        url: "/comment/add.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.contents = "";
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
                            alert("정말로 삭제하시겠습니까?");
                            if(data.result == "success"){
                                alert("삭제되었습니다!");
                                location.href = "board-list.do";
                            }else{
                                alert("오류발생");
                            }
                            
                            
                        }
                    });
                },

                fnUpdate: function () {

                    let self = this;
                    console.log(self.boardNo);
                    pageChange("board-edit.do", { boardNo: self.boardNo });

                },
                

                fncRemove: function (commentNo) {
                    let self = this;
                    let param = {
                        commentNo: commentNo,
                    }
                    console.log(self.commentNo);
                    
                    $.ajax({
                        url: "/view-cDelete.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                           alert("정말로 삭제하시겠습니까?");
                            if(data.result == "success"){
                                alert("삭제되었습니다!");
                                self.fnInfo();
                            }else{
                                alert("오류발생");
                            }
                        }
                    });
                },

                fncUpdate: function (commentNo) {
                    let self = this;
                    console.log("수정 요청댓글번호",commentNo);
                    pageChange("board-comment-edit.do", { commentNo: self.commentNo });
                },

            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnInfo();
            }
        });

        app.mount('#app');
    </script>