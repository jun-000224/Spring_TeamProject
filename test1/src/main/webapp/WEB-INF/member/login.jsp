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
        .body{
            
            margin: 200px auto;
            width: 800px;
            height: 300px;
            

        }
        .loginField{
            background-color: white;

            margin: 10px auto;
            padding-top: 50px;
            width: 350px;
            height: 260px;
            border-style: solid;
            border-width: 1px;
            border-radius: 15px;
            box-shadow: 0px 0px 5px gray;

            
            text-align: center;

            box-sizing: 600px;
            
        }
        .btnStyle{
            margin-top: 10px;
            margin-right: 10px;
        }
        .kakaoBtn{
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <%@ include file="../components/header.jsp" %>
        
        <div class="body">
            <div class="loginField">
                <div>
                    <div style="margin-left: 15px;">
                        아이디 :
                        <input autofocus type="text" v-model="id" @input="id = id.replace(/[^a-z0-9]/g, '')">
                    </div>
                    <div>
                        비밀번호 :
                        <input type="password" v-model="pwd" @keyup.enter="fnLogin">
                    </div>
                </div>
                <div>
                    <div>
                        <button @click="fnJoin" class="btnStyle">회원가입</button>
                        <button @click="fnLogin" class="btnStyle">로그인</button>
                    </div>
                
                    
                </div>
                <div class="kakaoBtn">
                    <a :href="kakaolocation">
                        <img src="/img/kakao.png" alt="">
                    </a>
                </div>
                <div>
                    <button @click="fnFind" class="btnStyle">아이디/비밀번호 찾기</button>
                </div>
                <!-- <div>
                    <a :href="naverlocation">
                        <img src="/img/naver_login.png" alt="">
                    </a>
                </div> -->
                <!-- <div>
                    <button @click="fnLogout">로그아웃</button>
                </div> -->
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
                id : "",
                pwd : "",

                //main 연결 시, main으로 옮길 것
                // code : "", 

                kakaolocation: "${kakao_location}"

                // navercode : "",//main 연결 시, main으로 옮길 것

                // naverlocation: "${naver_location}"

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnLogin: function () {
                let self = this;

                if(self.id.length==0){
                    alert("아이디를 입력해주세요.");
                    return;
                }
                if(self.pwd.length==0){
                    alert("비밀번호를 입력해주세요.");
                    return;
                }

                let param = {
                    userId : self.id,
                    pwd : self.pwd
                };
                $.ajax({
                    url: "/member/login.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.result=="success"){
                            alert(data.msg);
                            location.href="/main-list.do";
                        } else{
                            alert(data.msg);
                            return;
                        }
                    }
                });
            },

            fnFind : function () {
                location.href="/member/find.do";
            },

            fnJoin : function () {
                location.href="/member/join.do";
            }
            
            /*
            ,

            fnLogout : function () {
                let self = this;

                let param = {
                };
                $.ajax({
                    url: "/member/logout.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.msg);
                        location.href="/main-list.do";
                    }
                });
            },
            */

            /*main 연결 시, fnKakao를 main으로 옮길 것----------------------
            fnKakao : function () { 
                let self = this;
                let param = {
                    code : self.code
                };
                $.ajax({
                    url: "/kakao.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        // self.sessionName = data.properties.nickname;
                    }
                });
            }
            ,*/

            // fnNaver : function () { 
            //     let self = this;
            //     let param = {
            //         code : self.code
            //     };
            //     $.ajax({
            //         url: "/naver.dox",
            //         dataType: "json",
            //         type: "POST",
            //         data: param,
            //         success: function (data) {
            //             console.log(data);
            //             // self.sessionName = data.properties.nickname;
            //         }
            //     });
            // }
            //---------------------------------------------------------------

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;

            //----------main 연결 시, main으로 옮길 것--------------------------
            // const queryParams = new URLSearchParams(window.location.search);
            // self.code = queryParams.get('code') || '';
            
            // const state = queryParams.get('state');

            // if(self.code != null){
                // if(self.kakaoFlg){
                //     self.fnKakao();
                // }

                // if(self.naverFlg){
                //     self.naverFlg();
                // }
            // }
            
            
            // if(self.code != null){
            //     self.fnKakao();
                // self.fnNaver();
            // }
            //------------------------------------------------------------------
        }
    });

    app.mount('#app');
</script>