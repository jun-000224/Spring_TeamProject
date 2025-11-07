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
            margin: 100px auto;
            width: 500px;
            height: 1000px;
        }
        .joinField{
            border-style: solid;
            border-radius: 10px;
            border-width: 1px;
            padding-left: 10%;
            background-color: white;
            margin: 50px auto;
            text-align: left;
            box-shadow: 0px 0px 5px gray;
        }
        .joinBlock{
            margin-top: 20px;
        }
        .btnField button{
            width: 150px;
            height: 50px;
            font-size: 22px;
            border-radius: 10px;
            border-width: 1px;
        }
        .btnField button:hover{
            cursor: pointer;
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
        .pwdCheckMsg{
            margin-top: 20px;
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
            <div class="joinField">
                <br>
                <div class="joinBlock">
                    이름 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input type="text" v-model="name" class="inputWidth"
                    @input="onNameInput"
                    @compositionstart="isComposing = true"
                    @compositionend="onCompositionEnd">
                    <!-- input 입력중 onNameInput 호출, 글자 필터링 하지만, 한글 조합중이면 실행 x -->
                    <!-- 한글 조합 시, @compositionstart 호출, 조합중 상태를 플래그로 표시  -->
                    <!-- 조합 종료 시, @compositionend 호출, 최종글자 필터링 -->
                </div>
                <div class="joinBlock">
                    생년월일 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <select v-model="year">
                        <option
                            v-for="y in Array.from({ length: new Date().getFullYear() - 1900 + 1 }, (_, i) => 1900 + i)"
                            :key="y"
                            :value="y"
                        >
                            {{ y }}
                        </option>
                    </select>
                    .
                    <select v-model="month">
                        <option :value="String(num).padStart(2, '0')" v-for="num in 12">{{ String(num).padStart(2, '0') }}</option>
                    </select>
                    .
                    <select v-model="day">
                        <option v-if="month%2 == 1" :value="String(num).padStart(2, '0')" v-for="num in 31">{{ String(num).padStart(2, '0') }}</option>
                        <option v-else-if="month==2" :value="String(num).padStart(2, '0')" v-for="num in 29">{{ String(num).padStart(2, '0') }}</option>
                        <option v-else :value="String(num).padStart(2, '0')" v-for="num in 30">{{ String(num).padStart(2, '0') }}</option>
                    </select>
                </div>
                <div class="joinBlock">
                    ID
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input v-if="!idFlg" type="text" v-model="id" class="inputWidth" @input="id = id.replace(/[^a-z0-9]/g, '')">
                    <input v-else type="text" v-model="id" class="userId" disabled>
                    <button @click="fnIdCheck" class="checkButton">중복체크</button>
                    <div class="guide"> 영소문자와 숫자만 입력 가능</div>
                </div>
                <div class="joinBlock">
                    비밀번호 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input type="password" v-model="pwd" class="inputWidth" @input="pwd = pwd.replace(/[^a-zA-Z0-9!@#$%^&*(),.?&quot;:{}|<>]/g, '')">
                    <div class="guide">영대소문자와 숫자, 특수기호만 사용 가능</div>
                </div>
                <div class="joinBlock">
                    비밀번호 확인 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input type="password" v-model="pwd2" class="inputWidth" @input="pwd = pwd.replace(/[^a-zA-Z0-9!@#$%^&*(),.?&quot;:{}|<>]/g, '')">
                    <br>
                    <temp class="pwdCheckMsg">
                        <span class="checkTrue" v-if="pwd === pwd2 && (pwd !== '' && pwd2 !== '')">확인되었습니다.</span>
                        <span v-else-if="pwd === '' || pwd2 === '' "></span>
                        <span class="checkFalse" v-else>비밀번호가 틀립니다.</span>
                    </temp>
                </div>
                <div class="joinBlock">
                    성별 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input type="radio" name="gender" value="M" v-model="gender"> 남자
                    <input type="radio" name="gender" value="F" v-model="gender"> 여자
                    <input type="radio" name="gender" value="N" v-model="gender"> 미공개
                </div>
                
                <div class="joinBlock">
                    이메일 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input type="text" class="inputWidth" v-model="emailFront" @input="emailFront = emailFront.replace(/[^a-z0-9]/g, '')"> @
                    <select v-model="emailBack">
                        <option value="default">선택해주세요.</option>
                        <option value="naver.com">naver.com</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="daum.net">daum.net</option>
                        <option value="yahoo.com">yahoo.com</option>
                    </select>
                </div>
                <div class="joinBlock">
                    주소 
                    <span class="guideMust">(필수)</span>
                    <br>
                    <input type="text" v-model="addr" class="addr" disabled>
                    <button class="checkButton" @click="fnAddr">검색</button>
                </div>
                <div class="joinBlock">
                    전화번호 
                    <span class="guideMust">(필수)</span>
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
                        <input type="text" :value="phone1 + '-' + phone2 + '-' + phone3" disabled>
                    </span>
                </div>

                <div class="joinBlock" v-if="!certifiFlg">
                    문자인증 
                    <span class="guideMust">(필수)</span>
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
                
                <div class="joinBlock">
                    닉네임
                    
                    <br>
                    <input type="text" class="inputWidth" v-model="nickname">
                    <br>
                    <div class="guide">미입력 시, 이름이 닉네임이 됩니다.</div>
                </div>
                <div>
                     <br>
                     <br>
                </div>
            </div>
            <div class="btnField">
                <button class="joinBtn" @click="fnJoin">가입하기</button>
                <button class="cancleBtn" @click="fnCancel">취소하기</button>
            </div>
        </div>

        <%@ include file="../components/footer.jsp" %>
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

    let today = new Date();
    let nowYear = today.getFullYear();

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                isComposing: false, //한글 조합중인지 체크

                id : "",
                pwd : "",
                pwd2 : "",
                name : "",
                gender : "M",
                year : "1900",
                month : "01",
                day : "01",
                emailFront : "",
                emailBack : "default",
                addr : "",
                phone1 : "010",
                phone2 : "",
                phone3 : "",
                nickname : "",

                idFlg : false, //아이디 중복 체크 유무

                timer : "",
                count : 180,

                smsFlg : false, // 인증번호 발송 여부
                certifiFlg : false, // 문자 인증 유무
                inputNum : "", // 인증 입력 번호
                certifiStr : "" // 문자 인증 번호
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

            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            },

            fnIdCheck: function () {
                let self = this;
                // alert(self.id);
                let param = {
                    userId : self.id
                };
                $.ajax({
                    url: "/member/idCheck.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        // console.log(data);
                        if(data.result=='false'){
                            alert(data.msg);
                            self.idFlg = true;
                        } else{
                            alert(data.msg);
                            return;
                        }
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
                    phone : self.phone1+self.phone2+self.phone3
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

            fnJoin : function () {
                let self = this;
                if(!self.idFlg){
                    alert("id중복체크를 해주세요.");
                    return;
                }
                if(self.pwd != self.pwd2){
                    alert("비밀번호를 확인해주세요.");
                    return;
                }
                if(self.name == ""){
                    alert("이름을 입력해주세요.");
                    return;
                }
                if(self.emailFront == ""){
                    alert("이메일을 입력해주세요.");
                    return;
                }
                if(self.emailBack=="default"){
                    alert("이메일을 입력해주세요.");
                    return;
                }
                if(self.addr == ""){
                    alert("주소를 입력해주세요.");
                    return;
                }
                if(self.phone2.length !=4 || self.phone3.length != 4){
                    alert("전화번호를 입력해주세요.");
                    return;
                }
                if(self.nickname==""){
                    self.nickname=self.name;
                }
                // if(!self.certifiFlg){
                //     alert("전화번호를 인증해주세요.")
                //     return;
                // }
                
                let param = {
                    userId : self.id,
                    pwd : self.pwd,
                    name : self.name,
                    gender : self.gender,
                    birth : self.year + self.month + self.day,
                    email : self.emailFront + '@' + self.emailBack,
                    addr : self.addr,
                    phone : self.phone1 + '-' + self.phone2 + '-' + self.phone3,
                    nickname : self.nickname
                };
                console.log(param);
                $.ajax({
                    url: "/member/join.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=='success'){
                            alert("가입되었습니다.");
                            location.href="/member/login.do";
                        } else{
                            alert("오류가 발생했습니다.");
                            return;
                        }
                    }
                });
            },

            fnCancel : function () {
                location.href="/member/login.do";
            }

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            window.vueObj = this;
        }
    });

    app.mount('#app');
</script>