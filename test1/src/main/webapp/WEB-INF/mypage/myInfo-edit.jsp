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
        .marginLeft {
            margin-left: 5px;
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
                    이름
                    <br>
                    <i class="fa-solid fa-user"></i>
                    <input class="inputWidth marginLeft" type="text" v-model="name">
                </div>
                <div class="infoBanner2">
                    전화번호
                    <br>
                    <i class="fa-solid fa-phone"></i>
                    <span class="phone marginLeft">
                        <select v-model="phone1">
                            <option value="010">010</option>
                            <option value="011">011</option>
                            <option value="012">012</option>
                            <option value="016">016</option>
                            <option value="017">017</option>
                            <option value="018">018</option>
                            <option value="019">019</option>
                        </select> -
                        <input type="text" v-model="phone2" @input="phone2 = phone2.replace(/[^0-9]/g, '').slice(0, 4)"> -
                        <input type="text" v-model="phone3" @input="phone3 = phone3.replace(/[^0-9]/g, '').slice(0, 4)">
                    </span>
                </div>
                <div class="infoBanner2">
                    이메일
                    <br>
                    <i class="fa-solid fa-envelope"></i>
                    <input type="text" class="marginLeft inputWidth" v-model="emailFront" @input="emailFront = emailFront.replace(/[^a-z0-9]/g, '')"> @
                    <select v-model="emailBack">
                        <option value="abc">선택해주세요.</option>
                        <option value="naver.com">naver.com</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="daum.net">daum.net</option>
                        <option value="yahoo.com">yahoo.com</option>
                    </select>
                </div>
                <div class="infoBanner2">
                    아이디
                    <br>
                    <i class="fa-solid fa-pen-clip"></i>
                    {{info.userId}}
                </div>
                <div class="infoBanner2">
                    닉네임
                    <br>
                    <i class="fa-regular fa-face-smile"></i>
                    <input class="marginLeft inputWidth" type="text" v-model="nickname">
                </div>
                <div class="infoBanner2">
                    사용자 등급
                    <br>
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
                    생년월일
                    <br>
                    <i class="fa-solid fa-gift"></i>
                    {{info.bdate}}
                </div>
                <div class="infoBanner2">
                    주소
                    <br>
                    <i class="fa-solid fa-house"></i>
                    <input type="text" v-model="addr" class="addr marginLeft" disabled>
                    <button class="checkButton" @click="fnAddr">검색</button>
                </div>
                <div class="infoBanner2">
                    가입일
                    <br>
                    <i class="fa-solid fa-calendar"></i>
                    {{info.cdate}}
                </div>
                <div class="infoBanner2">
                    지난 정보 수정일
                    <br>
                    <i class="fa-regular fa-calendar"></i>
                    {{info.udate}}
                </div>
            </div>
            <div class="btnField">
                <button class="backBtn" @click="fnBack">취소</button>
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

    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
        // console.log(roadFullAddr);
        // console.log(roadAddrPart1);
        // console.log(addrDetail);
        // console.log(engAddr);
        window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
        // mounted에서 window.vueObj를 this로 해서 vue와 연결됨
        // vue에 fnResult가 없으니 생성
    }

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                sessionId : "${sessionId}",
                info : {},
                
                name : "",
                emailFront : "",
                emailBack : "abc",
                addr : "",
                phone1 : "010",
                phone2 : "",
                phone3 : "",
                nickname : ""
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

                        self.name = data.info.name;
                        self.nickname = data.info.nickname;
                        self.addr = data.info.addr;
                    }
                });
            },

            fnAddr : function () {
                window.open("/member/addr.do", "addr", "width=500, height=500");
            },

            fnResult : function (roadFullAddr, addrDetail, zipNo) {
                let self = this;
                self.addr = roadFullAddr;
            },

            fnSms : function () {
                let self = this;
                let param = {

                };

                $.ajax({
                    url: "/send-one",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.res.statusCode == "2000"){
                            alert("문자 전송 완료");
                            self.certifiStr = data.ranStr;
                            self.smsFlg = true;
                            self.fnTimer();
                        } else {
                            alert("잠시 후 다시 시도해주세요.");
                        }
                    }
                });
            },

            fnEdit: function() {
                let self = this;

                if(self.name == ""){
                    alert("이름을 입력해주세요.");
                    return;
                }
                if(self.phone2.length !=4 || self.phone3.length != 4){
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                if(self.emailFront == ""){
                    alert("이메일을 입력해주세요.");
                    return;
                }
                if(self.emailBack=="abc"){
                    alert("이메일을 입력해주세요.");
                    return;
                }
                if(self.addr == ""){
                    alert("주소를 입력해주세요.");
                    return;
                }
                if(self.nickname==""){
                    self.nickname=self.name;
                }

                let param = {
                    userId : self.sessionId,
                    name : self.name,
                    email : self.emailFront + '@' + self.emailBack,
                    addr : self.addr,
                    phone : self.phone1 + '-' + self.phone2 + '-' + self.phone3,
                    nickname : self.nickname
                }
                // console.log(param);

                $.ajax({
                    url: "/mypage/edit.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.result == "success"){
                            alert(data.msg);
                            // location.href="/myInfo/detail.do";            
                        } else {
                            alert(data.msg);
                        }
                    }
                });
            },

            fnBack: function () {
                location.href="/myInfo/detail.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnMyInfo();
            
            window.vueObj = this;
        }
    });

    app.mount('#app');
</script>