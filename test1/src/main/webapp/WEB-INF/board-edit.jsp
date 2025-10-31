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
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
         <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-images.css">
        <style>
            table {
                width: 80%;
                margin: 30px auto;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
                overflow: hidden;
                text-align: center;
                font-family: 'Noto Sans KR', sans-serif;
            }

            th {
                background-color: #0078FF;
                color: white;
                font-weight: 600;
                padding: 14px;
                font-size: 15px;
                width: 120px;
            }

            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                font-size: 14px;
                text-align: left;
            }

            /* input, textarea 스타일 */
            input[type="text"],
            textarea {
                width: 100%;
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 10px;
                font-size: 14px;
                resize: vertical;
                font-family: 'Noto Sans KR', sans-serif;
            }

            input[type="text"]:focus,
            textarea:focus {
                outline: none;
                border-color: #0078FF;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.3);
            }

            /* 버튼 위치 중앙 정렬 */
            table+div {
                text-align: center;
                margin: 20px auto 40px;
            }

            /* 수정 버튼 스타일 */
            button {
                background-color: #0078FF;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 22px;
                font-size: 15px;
                cursor: pointer;
                transition: background-color 0.25s ease;
            }

            button:hover {
                background-color: #005FCC;
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
                    <td><input v-model="title"></td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td>{{userId}}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea v-model="contents" cols="50" rows="20"></textarea> </td>
                </tr>
                <div>
                    <button @click="fnUpdate">수정</button>
                </div>
            </table>
        </div>

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
                    boardNo: "${boardNo}",
                    title: "",
                    contents: "",
                    userId: "${sessionId}"
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnInfo: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo,
                        userId: self.userId
                    };
                    $.ajax({
                        url: "board-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                console.log(data);
                                self.title = data.info.title;
                                self.contents = data.info.contents;
                            } else {
                                alert("오류가 발생했습니다!");
                            }
                        }
                    });
                },





                fnUpdate: function () {
                    let self = this;
                    let param = {
                        title: self.title,
                        contents: self.contents,
                        boardNo: self.boardNo,
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/board-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("수정됨");
                                location.href = "board-list.do"
                            } else {
                                alert("오류발생");
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