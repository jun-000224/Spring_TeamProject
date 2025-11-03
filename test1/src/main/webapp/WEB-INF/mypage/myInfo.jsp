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
            height: 800px;
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
        .editBtn a{
            margin-right: 10px;
        }
        .joinBlock{
            margin-top: 20px;
        }
        .joinBtn{
            float: right;
            background-color: #0078FF;
            color: white;
            border-color: #0078FF;
        }
        .joinBtn:hover{
            background-color: rgb(6, 81, 131);
        }
        .cancleBtn{
            float: left;
        }
        .cancleBtn:hover{
            background-color: rgb(213, 213, 213);
        }

        .info{
            position: relative;
        }
        .info-dropdown {
        position: absolute;
        top: 15px;
        right: 0px;
        background-color: white;
        border: 1px solid #ddd;
        border-radius: 6px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 8px 12px;
        list-style: none;
        margin: 0;
        z-index: 100;
        animation: fadeIn 0.2s ease-in-out;
        min-width: 50px;
        text-align: center;
        }

        .info-dropdown li {
        font-size: 14px;
        color: #0078FF;
        padding: 6px 0;
        cursor: pointer;
        transition: color 0.2s ease;
        }

        .info-dropdown li:hover {
        color: #0056b3;
        }

        .buyBtn{
            float:right;
            margin-right: 15px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <%@ include file="../components/header.jsp" %>
        
        <div class="field">
            <div class="infoField">
                <div class="infoBanner">
                    내 정보
                    <span class="editBtn info">
                        <a href="javascript:;">
                            <i class="fa-solid fa-ellipsis-vertical" @click="toggleMenu"></i>

                            <ul v-if="infoFlg" class="info-dropdown">
                                <li @click="fnEdit">수정</li>
                                <li style="color: red;" @click="fnRelease">탈퇴</li>
                            </ul>
                        </a>
                    </span>
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

                    <span class="buyBtn" v-if="info.status === 'U'" >
                        <button @click="fnSub">구독하기</button>
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
                    <span class="buyBtn">
                        가입한지 {{info.cdate2}}일 째!
                    </span>
                </div>
                <div class="infoBanner2">
                    <i class="fa-regular fa-calendar"></i>
                    {{info.udate}}
                </div>
                
            </div>

            <div class="infoField">
                <div class="infoBanner">
                    보안설정
                </div>
                <div class="infoBanner2">
                    <i class="fa-solid fa-key"></i>
                    비밀번호
                    <button class="editBtn">수정</button>
                </div>
            </div>
            
        </div>

        <%@ include file="../components/footer.jsp" %> 
         
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                sessionId : "${sessionId}",
                info : {},

                infoFlg : false,

                id: "${sessionId}",
                status: "${sessionStatus}",
                nickname: "${sessionNickname}",
                name: "${sessionName}",
                point: "${sessionPoint}",
                showLogoutMenu: false
            };
        },
        computed: {
            isLoggedIn() {
                return this.nickname !== "";
            },
            gradeLabel() {
                switch (this.status) {
                    case 'A': return '👑 ';
                    case 'S': return '✨ ';
                    case 'U': return '🙂 ';
                    default: return '❓ 미지정';
                }
            }
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
            },

            fnRelease : function () {
                let self = this;
                let userId = self.sessionId;

                let popup = window.open(
                    "/myInfo/release.do",
                    "회원탈퇴",
                    "width=500,height=500,top=100,left=200,location=no"
                );

                if(!popup){
                    alert("팝업이 차단되었습니다. 브라우저 설정을 확인해주세요.");
                    return;
                }

                setTimeout(function () {
                    popup.postMessage({ userId: userId }, window.location.origin);
                    // console.log("보낸 세션 : ", userId);
                }, 500);
            },

            fnSub : function () {
                let self = this;
                let userId = self.sessionId;

                let popup = window.open(
                    "/myInfo/subscribe.do",
                    "구독하기",
                    "width=1000,height=700,top=100,left=200,location=no"
                );
                
                if(!popup){
                    alert("팝업이 차단되었습니다. 브라우저 설정을 확인해주세요.");
                    return;
                }

                setTimeout(function () {
                    popup.postMessage({ userId: userId }, window.location.origin);
                    // console.log("보낸 세션 : ", userId);
                }, 500);
            },

            toggleMenu() {
                this.infoFlg = !this.infoFlg;
            },

            toggleLogoutMenu() {
                this.showLogoutMenu = !this.showLogoutMenu;
            },
            goToSettings() {
                location.href = "/myPoint.do";
            },
            goToWithdraw() {
                location.href = "/member/withdraw.do";
            },
            goToLogin() {
                location.href = "/member/login.do";
            },
            logout() {
                location.href = "/logout.do";
            },
            goToMyPage() {
                location.href = "/main-myPage.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnMyInfo();
            self.infoFlg = false;
        }
    });

    app.mount('#app');
</script>