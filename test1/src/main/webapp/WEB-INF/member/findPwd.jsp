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
        
        .field{
            margin: 100px auto;
            width: 100%;
            height: 600px;
        }
        .findField{
            margin: 10px auto;
            width: 450px;
            border-style: solid;
            border-radius: 10px;
            border-width: 1px;
            padding-left: 50px;
            background-color: white;
            text-align: left;
            box-shadow: 0px 0px 5px gray;
            
        }
        .findBlock{
            margin-top: 20px;
        }
        .findBlock button{
            margin-left: 10px;
        }
        .inputWidth{
            width: 150px;
        }
        .phone input{
            width: 50px;
        }
        .btnField{
            text-align: center;
        }
        .btnField button{
            width: 150px;
            height: 50px;
            font-size: 22px;
            border-radius: 10px;
            border-width: 1px;
            background-color: #0078FF;
            color: white;
            border-color: #0078FF;
        }
        .btnField button:hover{
            background-color: rgb(6, 81, 131);
            cursor: pointer;
        }
        .findBlock{
            margin-top: 20px;
        }
        .findBlock button{
            margin-left: 10px;
        }
        .inputWidth{
            width: 150px;
        }
        .phone input{
            width: 50px;
        }
        .btnField{
            text-align: center;
        }
        .btnField button{
            width: 150px;
            height: 50px;
            font-size: 22px;
            border-radius: 10px;
            border-width: 1px;
            background-color: #0078FF;
            color: white;
            border-color: #0078FF;
        }
        .btnField button:hover{
            background-color: rgb(6, 81, 131);
            cursor: pointer;
        }
        .pwdCheckMsg{
            margin-left: 20px;
        }
        .pwdCheckMsg .checkTrue{
            color: rgb(0, 130, 39);
            font-weight: bold;
        }
        .pwdCheckMsg .checkFalse{
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <%@ include file="../components/header.jsp" %>

        <div class="field">
            <div class="findField">
                <br>
                <div>
                    아이디 
                    <br>
                    <span v-if="!certifiFlg"><input class="inputWidth" type="text" v-model="id"  @input="id = id.replace(/[^a-z0-9]/g, '')"></span>
                    <span v-else>{{id}}</span>
                </div>
                <div class="findBlock">
                    이름 
                    <br>
                    <span v-if="!certifiFlg">
                        <input type="text" v-model="name"
                        @input="onNameInput"
                        @compositionstart="isComposing = true"
                        @compositionend="onCompositionEnd"
                        class="inputWidth">
                    </span>
                    <span v-else>
                        {{name}}
                    </span>
                </div>
                <div class="findBlock">
                    전화번호 
                    <br>
                    <span v-if="!certifiFlg" class="phone">
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
                    <span v-else>
                        {{phone1}}-{{phone2}}-{{phone3}}
                    </span>
                </div>
                <div class="findBlock" v-if="!certifiFlg">
                    문자인증 
                    <br>
                     <input class="inputWidth" type="text" v-model="inputNum" :placeholder="timer">
                        <!-- 속성에 :를 붙이면 변수가 동적으로 변함 -->
                    <template v-if="!smsFlg">
                        <button @click="fnSms">인증번호 전송</button>
                    </template>
                    <template v-else>
                        <button @click="fnSmsAuth">인증</button>
                    </template>
                </div>

                <div v-if="!changeFlg">
                    <button @click="fnTemp" >비밀번호 변경</button>
                </div>

                <div class="findBlock" v-if="changeFlg">
                    <br>
                    <div>
                        비밀번호
                        <br>
                        <input class="inputWidth" type="password" v-model="pwd" class="userPwd" @input="pwd = pwd.replace(/[^a-zA-Z0-9!@#$%^&*(),.?&quot;:{}|<>]/g, '')">
                    </div>
                    <div>
                        비밀번호 확인
                        <br>
                        <input class="inputWidth" type="password" v-model="pwd2" class="userPwd" @input="pwd = pwd.replace(/[^a-zA-Z0-9!@#$%^&*(),.?&quot;:{}|<>]/g, '')">
                        <!-- <button @click="fnPwdCheck" class="checkButton">확인</button> -->
                        <temp class="pwdCheckMsg">
                            <span class="checkTrue" v-if="pwd === pwd2 && (pwd !== '' && pwd2 !== '')">확인되었습니다.</span>
                            <span v-else-if="pwd === '' || pwd2 === '' "></span>
                            <span class="checkFalse" v-else>비밀번호가 틀립니다.</span>
                        </temp>
                        
                    </div>
                </div>
                
                <br>
                <br>
            </div>
            <div v-if="changeFlg" class="btnField">
                <button @click="fnPwdChange">비밀번호 변경</button>
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
                name : "",
                phone1 : "010",
                phone2 : "",
                phone3 : "",
                pwd : "",
                pwd2 : "",

                timer : "",
                count : 180,

                smsFlg : false, // 인증번호 발송 여부
                certifiFlg : false, // 문자 인증 유무
                inputNum : "", // 인증 입력 번호
                certifiStr : "", // 문자 인증 번호

                pwdFlg : false,

                changeFlg : false
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            onNameInput(e) {
                if (this.isComposing) return; //조합중이면 필터링 x
                this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g, ''); //한글,영문만 허용
            }, //isComposing 이 
            onCompositionEnd(e) {
                this.isComposing = false;
                this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g, '');
            },

            fnPwdChange: function () {
                let self = this;

                if(self.pwd != self.pwd2){
                    alert("비밀번호를 확인해주세요.");
                    return;
                }

                let param = {
                    userId : self.id,
                    pwd : self.pwd
                };
                console.log(param);
                $.ajax({
                    url: "/member/pwdChange.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            alert(data.msg);
                            location.href="/member/login.do";
                        } else {
                            alert(data.msg);
                            return;
                        }
                    }
                });
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

            // fnPwdCheck: function () {
            //     let self = this;
            //     if(self.pwd != self.pwd2){
            //         alert("비밀번호가 다릅니다.");
            //         return;
            //     } else {
            //         alert("확인되었습니다.");
            //         self.pwdFlg = true;
            //     }
            // },

            fnTemp : function () { 
                let self = this;

                if(self.id.length==0){
                    alert("아이디를 입력해주세요.");
                    return;
                }

                if(self.name.length==0){
                    alert("이름을 입력해주세요.");
                    return;
                }

                if(self.phone2.length==0 || self.phone3.length==0){
                    alert("전화번호를 입력해주세요.");
                    return;
                }

                // self.certifiFlg=true;//문자 인증 가능해지면 주석처리

                // if(!self.certifiFlg){
                //     alert("문자를 인증해주세요.");
                //     return;
                // }

                let param = {
                    userId : self.id,
                    name : self.name,
                    phone : self.phone1 + '-' + self.phone2 + '-' + self.phone3
                };
                $.ajax({
                    url: "/member/pwdCheck.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.result=="success"){
                            alert(data.msg);
                            self.certifiFlg = true;
                            self.changeFlg = true;
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
        }
    });

    app.mount('#app');
</script>