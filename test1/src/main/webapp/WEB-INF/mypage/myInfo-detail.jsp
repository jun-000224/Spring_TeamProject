<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/main-style.css">
    <link rel="stylesheet" href="/css/common-style.css">
    <link rel="stylesheet" href="/css/header-style.css">
    <link rel="stylesheet" href="/css/main-images.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
        .checkButton{
            margin-left: 10px;
        }
        .addr{
            width: 250px;
        }
        .inputWidth{
            width: 150px;
        }
        .phone input{
            width: 50px;
        }
        .guide{
            padding-left: 5px;
            font-size: 12px;
            color: blue;
        }
        .guideMust{
            color: red;
        }
        .field{
            margin: 20px auto;
            width: 500px;
            height: 1000px;
            padding-bottom: 100px;
        }
        .infoField{
            border-style: solid;
            border-radius: 10px;
            border-width: 1px;
            /* padding-left: 10%; */
            background-color: white;
            margin: 30px auto;
            text-align: left;
            box-shadow: 0px 0px 5px gray;
            overflow: hidden;
        }
        .infoField div{
            padding-top: 8px;
            padding-bottom: 8px;
        }
        .infoBanner{
            background-color: #0078FF;
            padding-left: 10%;
            color: white;
            font-weight: bold;
            /* height: 40px; */
        }
        .infoBanner2{
            padding-left: 10%;
            /* height: 36px; */
        }
        .editBtn{
            float: right;
            margin-right: 10px;
        }
        .joinBlock{
            margin-top: 20px;
        }
        .btnField button{
            width: 100px;
            height: 40px;
            font-size: 22px;
            border-radius: 10px;
            border-width: 1px;
            font-weight: bold;
        }
        .btnField button:hover{
            cursor: pointer;
        }
        .editBtn{
            float: right;
            background-color: #0078FF;
            color: white;
            border-color: #0078FF;
        }
        .editBtn:hover{
            background-color: rgb(6, 81, 131);
        }
        .releaseBtn{
            float: left;
            background-color: rgb(216, 21, 21);
            color: white;
        }
        .releaseBtn:hover{
            background-color: rgb(92, 1, 1);
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
            <div class="infoField">
                <div class="infoBanner">
                    내 정보
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-user"></i>
                    {{info.name}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-phone"></i>
                    {{info.phone}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-envelope"></i>
                    {{info.email}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-pen-clip"></i>
                    {{info.userId}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-regular fa-face-smile"></i>
                    {{info.nickname}}
                </div>
                <div class="infoBanner2">
                    <span v-if="info.status === 'U'">
                        <i class="fa-solid fa-circle-user"></i>
                        일반 사용자
                    </span>

                    <span v-else-if="info.status === 'S'">
                        <i class="fa-solid fa-star"></i>
                        구독자
                    </span>

                    <span v-else-if="info.status === 'A'">
                        <i class="fa-solid fa-user-secret"></i>
                        관리자
                    </span>
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-gift"></i>
                    {{info.bdate}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-house"></i>
                    {{info.addr}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-calendar"></i>
                    {{info.cdate}}
                </div>
                <div class="infoBanner2">
                    <i class="fa-regular fa-calendar"></i>
                    {{info.udate}}
                </div>
            </div>
            <div class="btnField">
                <button class="releaseBtn">탈퇴</button>
                <button class="editBtn" @click="fnEdit">수정</button>
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
                sessionId : "${sessionId}",
                info : {}
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnMyInfo: function () {
                let self = this;
                let param = {
                    userId : self.sessionId
                };
                $.ajax({
                    url: "/mypage/myInfo.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                    }
                });
            },

            fnEdit: function() {
                location.href="/myInfo/edit.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnMyInfo();
        }
    });

    app.mount('#app');
</script>