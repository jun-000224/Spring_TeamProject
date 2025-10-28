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
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            이름 :
            <input type="text" v-model="name"
            @input="onNameInput" 
            @compositionstart="isComposing = true" 
            @compositionend="onCompositionEnd">
        </div>
        <div>
            전화번호 : 
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
        </div>
        <div>
            <div v-if="!certifiFlg">
                문자인증 : <input type="text" v-model="inputNum" :placeholder="timer"> 
                    <!-- 속성에 :를 붙이면 변수가 동적으로 변함 -->
                <template v-if="!smsFlg">
                    <button @click="fnSms">인증번호 전송</button>
                </template>
                <template v-else>
                    <button @click="fnSmsAuth">인증</button>
                </template>
            </div>
        </div>
        <div>
            <div v-if="findFlg">
                {{userData.userId}}
            </div>

            <!-- 문자인증 가능해지면 주석처리 -->
            <div v-if="!findFlg">
                <button @click="fnIdFind">아이디 확인</button>
            </div> 
            

            <div v-if="findFlg">
                <button @click="fnGoLogin">로그인하러가기</button>
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
                name : "",
                phone1 : "010",
                phone2 : "",
                phone3 : "",

                timer : "",
                count : 180,

                smsFlg : false, // 인증번호 발송 여부
                certifiFlg : false, // 문자 인증 유무
                inputNum : "", // 인증 입력 번호
                certifiStr : "", // 문자 인증 번호

                userData : {},

                findFlg : false
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

            fnIdFind: function () {
                let self = this;

                if(self.name.length==0){
                    alert("이름을 입력해주세요.");
                    return;
                }

                if(self.phone2.length !=4 || self.phone3.length != 4){
                    alert("전화번호를 입력해주세요.");
                    return;
                }

                //문자인증 열리면 주석 해제
                // if(!self.certifiFlg){
                //     alert("인증을 완료해주세요.");
                //     return;
                // }

                let param = {
                    name : self.name,
                    phone : self.phone1 + "-" + self.phone2 + "-" + self.phone3
                };
                console.log(param);
                $.ajax({
                    url: "/member/findId.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            console.log(data);
                            self.userData = data.info;
                            self.certifiFlg = true; //문자인증 열리면 주석처리
                            self.findFlg = true;

                        } else {
                            console.log(data);
                            alert(data.msg);
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
                    self.fnIdFind();
                } else {
                    alert("문자인증에 실패했습니다.");
                }
            },

            fnGoLogin : function () {
                let self = this;
                location.href="/member/login.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>