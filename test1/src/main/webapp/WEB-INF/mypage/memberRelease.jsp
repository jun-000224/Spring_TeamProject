<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
            text-align: center;
        }
        .field .yesBtn,.noBtn{
            width: 100px;
            margin: 30px;
        }
        .phone input{
            width: 50px;
        }
        .inputWidth{
            width: 150px;
        }
        .joinBlock{
            width: 200px;
            height: 300px;
            text-align: left;
            margin-left: 150px;
        }
        .checkButton{
            margin-top : 10px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="field">
            <h2>정말 탈퇴하시겠습니까?</h2>
            <div v-if="!confirmFlg" class="ynBtn">
                <button class="yesBtn" @click="fnConfirm">예</button>
                <button class="noBtn" @click="fnCancel">아니오</button>
            </div>
            <div v-else>
                <div class="joinBlock">
                    전화번호 
                    <br>
                    <span class="phone">
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
                
                    <div v-if="!certifiFlg">
                        문자인증 
                        <br>
                        <input type="text" class="inputWidth" v-model="inputNum" :placeholder="timer">
                            <!-- 속성에 :를 붙이면 변수가 동적으로 변함 -->
                        <template v-if="!smsFlg">
                            <button @click="fnSms" class="checkButton">인증번호 전송</button>
                        </template>
                        <template v-else>
                            <button @click="fnSmsAuth" class="checkButton">인증</button>
                        </template>
                    </div>
                </div>
                <button v-if="!tempFlg" @click="fnTemp">확인</button>
                <button v-else @click="fnRelease">탈퇴</button>
            </div>

        </div>
         
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId : "",
                confirmFlg : false,

                phone1 : "010",
                phone2 : "",
                phone3 : "",

                timer : "",
                count : 180,

                smsFlg : false, // 인증번호 발송 여부
                certifiFlg : false, // 문자 인증 유무
                inputNum : "", // 인증 입력 번호
                certifiStr : "", // 문자 인증 번호

                tempFlg : false

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnConfirm: function () {
                let self=this;
                self.confirmFlg = true;
            },

            fnRelease: function () {
                let self = this;
                let param = {
                    userId : self.userId
                };
                // alert(self.userId);
                $.ajax({
                    url: "/mypage/delete.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            alert(data.msg);

                            if (window.opener && !window.opener.closed) {
                                window.opener.location.href = "/main-list.do";
                            }
                
                            window.close();

                        } else {
                            alert(data.msg);
                            return;
                        }
                    }
                });
            },

            fnCancel : function () {
                window.close();
            },

            fnReceiveMessage(event) {
                //부모창에서 보낸 정보가 event의 형태로 받아짐
                let self=this;
                // console.log(event);
                if (event.origin !== window.location.origin) return; // 보안 체크
                    //같은 도메인이 아니면 실행 X
                self.userId = event.data.userId;
                console.log("받은 세션:", self.userId);
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

            fnTimer : function () {
                let self = this;
                let interval = setInterval(function(){
                    if(self.count == 0) {
                        clearInterval(interval);
                        alert("시간이 만료되었습니다.");
                        window.close();
                    } else {
                        let min = parseInt(self.count / 60);
                        let sec = self.count % 60;

                        min = min < 10 ? "0" + min : min;
                        sec = sec < 10 ? "0" + sec : sec;
                        
                        self.timer = min + " : " + sec;

                        self.count--;
                    }
                }, 1000);
            },

            fnSmsAuth : function () {
                let self = this;
                if(self.certifiStr == self.inputNum){
                    alert("문자인증이 완료되었습니다.");
                    self.certifiFlg = true;
                } else {
                    alert("문자인증에 실패했습니다.");
                }
            },

            fnTemp : function () {
                let self = this;
                // self.smsFlg=true;
                // self.fnTimer();
                let param = {
                    userId : self.userId,
                    phone : self.phone1 + '-' + self.phone2 + '-' + self.phone3
                };
                // alert(self.userId);
                $.ajax({
                    url: "/mypage/temp.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            alert(data.msg);
                            self.tempFlg=true;
                        } else {
                            alert(data.msg);
                            return;
                        }
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            window.addEventListener("message", self.fnReceiveMessage);
        }
    });

    app.mount('#app');
</script>