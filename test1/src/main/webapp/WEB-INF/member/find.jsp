<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/main-style.css">
    <link rel="stylesheet" href="/css/common-style.css">
    <link rel="stylesheet" href="/css/header-style.css">
    <link rel="stylesheet" href="/css/main-images.css">
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
        .field{
            width: 100%;
            height: 600px;
        }
        .btnField{
            margin: 10px auto;
            width: 800px;
            text-align: center;
        }
        .btnField button{
            width: 250px;
            height: 150px;
            font-size: 35px;
            margin-top: 30% ;
            border-radius: 10px;
            background-color: #0078FF;
            border-color:  #0078FF;
            color: white;
        }
        .btnField button:hover{
            cursor: pointer;
            background-color: rgb(6, 81, 131);
        }
        .idBtn{
            float: left;
        }
        .pwdBtn{
            float: right;
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
                    <li class="main-menu"><a href="#">여행하기</a></li>
                    <li class="main-menu"><a href="#">커뮤니티</a></li>
                    <li class="main-menu"><a href="#">공지사항</a></li>
                    <li class="main-menu"><a href="/main-Service.do">고객센터</a></li>
                    <!-- 마이페이지 / 관리자 페이지  -->
                    <li class="main-menu" v-if="status === 'u'">
                        <a href="/main-myPage.do">마이페이지</a>
                    </li>
                    <li class="main-menu" v-else-if="status === 'a'">
                        <a href="/admin-page.do">관리자 페이지</a>
                    </li>

                </ul>
            </nav>

            <div style="display: flex; align-items: center; gap: 15px;">
                <div class="login-btn">
                    <div class="login-btn">
                        <button @click="goToLogin">로그인/회원가입</button>
                    </div>

                </div>
            </div>
        </header>

        <div class="field">
            <div class="btnField">
                <button class="idBtn" @click="fnFindId">아이디 <br> 찾기</button>
                <button class="pwdBtn" @click="fnFindPwd">비밀번호 <br> 재설정</button>
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
        
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnFindId: function () {
                location.href="/member/findId.do";
            },

            fnFindPwd : function () {
                location.href="/member/findPwd.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>