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
            /* 📘 게시판 전체 영역 */
            #app>div {
                width: 90%;
                margin: 0 auto;
                font-family: 'Noto Sans KR', sans-serif;
                color: #333;
                text-align: center;
            }

            /* 📗 검색 + 필터 영역 */
            .board-top-controls {
                display: flex;
                justify-content: flex-start;
                /* ✅ 왼쪽 정렬로 변경 */
                align-items: center;
                gap: 10px;
                margin: 50px 0 20px 20px;
                /* 살짝 여백 추가 */
                flex-wrap: wrap;
            }

            /* 📙 셀렉트, 인풋, 버튼 스타일 */
            .board-top-controls select,
            .board-top-controls input,
            .board-top-controls button {
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 7px 10px;
                font-size: 14px;
                font-family: 'Noto Sans KR', sans-serif;
                text-align: center;
            }

            .board-top-controls select:focus,
            .board-top-controls input:focus {
                outline: none;
                border-color: #0078FF;
                box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            }

            .board-top-controls button {
                background-color: #0078FF;
                color: white;
                border: none;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .board-top-controls button:hover {
                background-color: #005FCC;
            }

            /* 📘 게시판 테이블 */
            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 20px;
                text-align: center;
            }

            th {
                background-color: #0078FF;
                color: white;
                padding: 12px 10px;
                font-weight: bold;
                font-size: 15px;
            }

            td {
                padding: 12px 10px;
                border-bottom: 1px solid #eee;
                font-size: 14px;
                color: #333;
            }

            tr:hover {
                background-color: #f4f9ff;
            }

            /* 제목 링크 */
            td a {
                color: #0078FF;
                text-decoration: none;
                font-weight: 500;
            }

            td a:hover {
                text-decoration: underline;
            }

            /* 삭제 버튼 */
            td button {
                background-color: #ff5252;
                border: none;
                color: white;
                border-radius: 6px;
                padding: 6px 10px;
                cursor: pointer;
                transition: background 0.2s;
            }

            td button:hover {
                background-color: #d63b3b;
            }

            /* 📒 페이지네이션 */
            .num {
                display: inline-block;
                margin: 0 4px;
                padding: 6px 10px;
                border-radius: 5px;
                color: #0078FF;
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                border: 1px solid transparent;
                text-align: center;
            }

            .num:hover {
                background-color: #0078FF;
                color: white;
            }

            .active {
                background-color: #0078FF;
                color: white !important;
                border: 1px solid #0078FF;
            }

            /* ◀ ▶ 버튼 */
            a[href="javascript:;"] {
                text-decoration: none;
                color: #000000;
                font-weight: bold;
                padding: 5px 10px;
            }

            a[href="javascript:;"]:hover {
                color: #005FCC;
            }

            /* 📗 글쓰기 버튼 */
            #app>div:last-of-type {
                text-align: center;
                margin-top: 25px;
            }

            #app>div:last-of-type button {
                background-color: #00A86B;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 10px 18px;
                font-size: 14px;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            #app>div:last-of-type button:hover {
                background-color: #008f5a;
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
            <div>
                <select v-model="searchOption">
                    <option value="all">::전체::</option>
                    <option value="title">::제목::</option>
                    <option value="id">::작성자::</option>
                </select>


            </div>

            <div>
                <select v-model="pageSize">
                    <option value="5">::5개씩::</option>
                    <option value="10">::10개씩::</option>
                    <option value="20">::20개씩::</option>
                </select>
                <div>
                    검색어 : <input @keyup.enter="fnList" v-model="keyword" placeholder="검색어를 입력해주세요.">
                    <button @click="fnList">검색</button>
                </div>




                <select v-model="type">
                    <option value="">::전체::</option>
                    <option value="N">::공지사항::</option>
                    <option value="F">::자유게시판::</option>
                    <option value="Q">::질문게시판::</option>
                </select>



                <select v-model="order">
                    <option value="num">::번호순::</option>
                    <option value="title">::제목순::</option>
                    <option value="cnt">::조회수::</option>
                </select>
            </div>


            <table>
                <tr>
                    <th>번호</th>
                    <th>작성자</th>
                    <th>제목</th>
                    <th>추천수</th>
                    <th>조회수</th>


                </tr>

                <tr v-for="item in list">
                    <td>{{item.boardNo}}</td>
                    <td>{{item.userId}}</td>
                    <td>
                        <a href="javascript:;" @click="fnView(item.boardNo)">{{item.title}}</a>

                    </td>
                    <td> {{item.fav}}</td>
                    <td>{{item.cnt}}</td>


                </tr>

            </table>
            <div>
                <a v-if="page !=1" @click="fnMove(-1)" href="javascript:;">◀</a>
                <a href="javascript:;" v-for="num in index" class="num" @click="fnPage(num)">
                    <span :class="{active: page == num}">{{num}}</span>


                </a>
                <a v-if="page!=index" @click="fnMove(1)" href="javascript:;">▶</a>
            </div>
            <div>
                <a href="board-add.do"><button>글쓰기</button></a>


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
                    list: [],
                    searchOption: "all",
                    pageSize: 5,
                    type: "",
                    order: "num",
                    keyword: "",

                    page: 1,
                    index: 0,
                    num: ""


                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnList: function () {
                    let self = this;
                    let param = {

                        type: self.type,
                        order: self.order,
                        keyword: self.keyword,
                        searchOption: self.searchOption,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize
                    };
                    $.ajax({
                        url: "board-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log(data);
                            self.list = data.list;
                            self.index = Math.ceil(data.cnt / self.pageSize);
                        }
                    });
                },
                fnView: function (boardNo) {
                    pageChange("board-view.do", { boardNo: boardNo });
                },


                fnPage: function (num) {
                    let self = this;
                    self.page = num;
                    self.fnList();
                },
                fnMove: function (num) {
                    let self = this;
                    self.page += num;
                    self.fnList();
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnList();
            }
        });

        app.mount('#app');
    </script>