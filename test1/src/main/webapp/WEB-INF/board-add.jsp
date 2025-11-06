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
                font-size: 20px;
                text-align: center;
                font-weight: bold;
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
                padding: 10px 30px;
                font-size: 15px;
                cursor: pointer;
                transition: background-color 0.25s ease;
                margin: 0 5px;
            }

            button:hover {
                background-color: #005FCC;
            }

            /* -------------------- 이전 버튼 스타일 (추가) -------------------- */
            /* 취소/이전 버튼에 다른 색상 적용 */
            button.cancel-btn {
                background-color: #95a5a6;
                /* 회색 계열 */
            }

            button.cancel-btn:hover {
                background-color: #7f8c8d;
            }

            .button-container {
                margin-left: 170px;
            }


            /* ... 기존 스타일 유지 ... */

            /* 제목 입력 필드 전용 스타일 */
            .input-title {
                font-size: 18px;
                margin-right: 200px;
                /* 글꼴 크기 키우기 */

                /* 약간 굵게 */
                color: #333;
                /* 글꼴 색상 진하게 */
                height: 20px;
                width: 96%;
                /* 높이 설정 */
                padding: 8px 15px;
                /* 상하 패딩 조정 */
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
                    <td><input v-model="title" class="input-title"></td>
                </tr>
                <tr>
                    <th>작성자</th>
                    <td>{{userId}}</td>
                </tr>

                <tr>
                    <th>게시글 종류</th>
                    <td>
                        <select v-model="type">
                            <option value="N">::공지사항::</option>
                            <option value="F">::자유게시판::</option>
                            <option value="Q">::질문게시판::</option>
                            <option value="SQ">::문의게시판</option>
                    </td>

                    </select>
                </tr>

                <tr>
                    <th>내용</th>

                    <td style="height: 300px; padding: 30px;">
                        <!-- <textarea v-model="contents" cols="50" rows="20"></textarea> -->
                        <div id="editor"></div>
                    </td>

                </tr>
            </table>
            <div class="button-container">
                <a href="board-list.do"><button class="cancel-btn">이전</button></a>
                <button @click="fnAdd">저장</button>
            </div>
        </div>
    </body>
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

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    title: "",
                    userId: "${sessionId}",
                    contents: "",
                    type: "N",
                    sessionId: "${sessionId}",
                    

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnAdd: function () {
                    let self = this;
                    let param = {
                        title: self.title,
                        contents: self.contents,
                        userId: self.userId,
                        type: self.type
                    };
                    $.ajax({
                        url: "/board-add.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // if(self.title == ""){
                            //     alert("제목을 적어주세요");
                            // }else{

                            //     alert("저장하시겠습니까?");   
                            //     alert("등록되었습니다.");
                            // console.log(data.boardNo);
                            // location.href = "board-list.do";
                            // }

                            if (confirm("저장하시겠습니까?")) {
                                if (self.title == "") {
                                    alert("제목을 적어주세요");
                                } else {
                                    alert("등록되었습니다.");
                                    console.log(data);
                                    location.href = "board-list.do";
                                }



                            }
                        }
                    });
                },
                // 파일 업로드
                upload: function (form) {
                    var self = this;
                    
                    $.ajax({
                        url: "/fileUpload.dox"
                        , type: "POST"
                        , processData: false
                        , contentType: false
                        , data: form
                        , success: function (data) {
                            console.log(data);
                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                if (self.sessionId == "") {
                    alert("로그인 후 이용해 주세요");
                    location.href = "/member/login.do";
                }

                // Quill 에디터 초기화
                var quill = new Quill('#editor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                            ['bold', 'italic', 'underline'],
                            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                            ['link', 'image'],
                            ['clean']
                        ]
                    }
                });

                // 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
                quill.on('text-change', function () {
                    self.contents = quill.root.innerHTML;
                });

            }
        });

        app.mount('#app');
    </script>