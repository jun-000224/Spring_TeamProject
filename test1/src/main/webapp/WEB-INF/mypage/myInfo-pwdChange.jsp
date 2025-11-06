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
            height: 600px;
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
            height: 600px;
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
            margin-right: 10px;
        }
        .joinBlock{
            margin-top: 20px;
        }
        .btnField{
            text-align: center;
        }
        .btnField button{
            width: 100px;
            height: 30px;
            font-size: 18px;
            border-radius: 10px;
            border-width: 1px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .btnField button:hover{
            cursor: pointer;
        }
        .cancleBtn{
            background-color: #d9d9d9;
            color: rgb(0, 0, 0);
            border-color: #000000;
        }
        .cancleBtn:hover{
            background-color: #a4a4a4;
        }
        .changeBtn{
            background-color: #0078FF;
            color: white;
            border-color: #0078FF;
        }
        .changeBtn:hover{
            background-color: rgb(6, 81, 131);
        }
        .inputbox {
            border: 0.5px solid black;
            box-sizing: border-box;
            width: 400px;
            height: 40px;
            border-collapse: collapse;
            padding-left: 10px;

            display: flex;
            align-items: center;
        }
        .inputbox input{
            border: none;
            outline: none;
            width: 370px;
        }
        .inputbox input:focus{
            border: 2px solid black;
        }
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            /* padding : 5px 10px; */
            /* text-align: center; */
        }
        td{
            box-sizing: border-box;
            width: 400px;
            height: 40px;
            padding-left: 10px;
        }
        td div {
            display: flex;
            align-items: center;
        }
        td input{
            border: none;
            outline: none;
            width: 370px;
        }
        td input:focus{
            border: 2px solid black;
        }
        .guideSpan{
            font-size: 12px;
        }
        .fontBold{
            font-weight: bold;
            font-size: 15px;
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
                    비밀번호 변경
                </div>
                <div class="infoBanner2" style="margin-bottom: 80px;">
                    <span class="guideSpan">
                        <span class="fontBold">· </span>다른 아이디/사이트에서 사용한 적 없는 비밀번호
                    </span>
                    <br>
                    <span class="guideSpan">
                        <span class="fontBold">· </span>이전에 사용한 적 없는 비밀번호가 안전합니다.
                    </span>
                </div>

                <div class="infoBanner2" style="margin-bottom: 5px;">
                    <table>
                        <tr>
                            <td>
                                <div><input type="password" placeholder="현재 비밀번호" v-model="nowPwd"></div>
                            </td>
                        </tr>
                    </table>
                </div>
                
                <div class="infoBanner2" style="margin-bottom: 100px;">
                    <table>
                        <tr>
                            <td>
                                <div><input type="password" placeholder="새 비밀번호" v-model="newPwd"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div><input type="password" placeholder="새 비밀번호 확인" v-model="newPwd2"></div>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="btnField">
                <button class="changeBtn" @click="fnPwdConfirm">확인</button>
                <br>
                <button class="cancleBtn" @click="fnBack">취소</button>
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
                sessionId : window.sessionData.id,
                info : {},
                nowPwd : "",
                newPwd : "",
                newPwd2 : "",

                id: window.sessionData.id,
                status: window.sessionData.status,
                nickname: window.sessionData.nickname,
                name: window.sessionData.name,
                point: window.sessionData.point,
            };
        },
        methods: {
            // 함수(메소드) - (key : function())

            fnPwdConfirm: function () {
                let self = this;
                let param = {
                    pwd : self.nowPwd,
                    userId : self.sessionId
                };
                $.ajax({
                    url: "/member/pwdConfirm.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.result == "success"){
                            self.fnConfirm();
                            // alert("같다.!");
                        } else{
                            alert(data.msg);
                            return;
                        }
                        
                    }
                });
            },

            fnConfirm: function() {
                let self = this;
                // alert("yeah");
                if(self.newPwd.length==0 || self.newPwd2.length==0 || self.nowPwd.length==0){
                    alert("비밀번호를 입력해주세요.");
                    return;
                }

                if(self.newPwd != self.newPwd2){
                    alert("새 비밀번호가 다릅니다.");
                    return;
                }
                let param = {
                    userId : self.sessionId,
                    pwd : self.newPwd
                };
                $.ajax({
                    url: "/member/pwdChange.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.result == "success"){
                            // self.fnConfirm();
                            alert(data.msg);
                            location.href="/myInfo.do";
                        } else{
                            alert(data.msg);
                            return;
                        }
                        
                    }
                });
            },

            fnBack : function () {
                let self = this;
                location.href="/myInfo.do";
            },

            blockSpaceInput(event) {
                if (event.key === " ") { // 공백 키가 눌렸을 때
                    event.preventDefault(); // 공백 입력을 막음
                }
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;

            document.querySelectorAll('input[type="password"]').forEach(input => {
                input.addEventListener('keydown', self.blockSpaceInput); // keydown 이벤트 사용
            });
        }
    });

    app.mount('#app');
</script>