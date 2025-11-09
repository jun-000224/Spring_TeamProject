<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>멤버쉽</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

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
            height: 800px;
        }
        .mainField{
            margin: 15px auto;
            width: 80%;
            height: 700px;
            border: 1px solid rgb(203, 203, 203);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0px 0px 5px rgb(166, 165, 165);
        }

        .membershipField{
            display: flex;      
            flex-direction: row;
            height: 100%;
        }

        .sidebar {
            width: 150px;
            display: flex;
            flex-direction: column;
            /* border-right: 2px solid #ccc; */
            background-color: #f8f8f8;
        }

        .btn {
            flex: none;
            height: 50px;
            border: none;
            border-bottom: 1px solid #ddd;
            border-right: 2px solid #ccc;
            background: #f8f8f8;
            cursor: pointer;
            font-size: 18px;
            transition: background 0.2s, border-right 0.2s;
        }

        .btn:hover {
            background: #eee;
        }

        .btn.active {
            background: #fff;
            border-right: none; /* 활성화된 버튼은 경계선 제거 */
        }

        /* 우측 콘텐츠 영역 */
        .content {
            flex: 1;
            /* border-left: 2px solid #ccc; */
            padding: 20px;
            background: #fff;
            height: 100%;
            text-align: center;
        }

        .panel {
            display: none;
        }

        .panel.active {
            display: block;
        }

        .topBar{
            background-color: #0078FF;
            height: 30px;
            text-align: center;
        }

        .title{
            font-size: 30px;
            font-weight: bold;
            height: 120px;
        }
        .price{
            margin-top: 20px;
            font-size: 25px;
            font-weight: bold;
        }
        .subBtn{
            width: 400px;
            height: 35px;
            font-size: 18px;
            border-radius: 10px;
            border: 1px solid #9ecbff;
            background-color: #9ecbff;
            font-weight: bold;
        }
        .subBtn:hover{
            cursor: pointer;
            background-color: #4a9efe;
            color: white;
        }
        .explainField{
            background-color: rgb(237, 237, 237);
            width: 400px;
            margin: 30px auto;
            border-radius: 10px;
        }
        .explainField div{
            height: 80px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <%@ include file="../components/header.jsp" %>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        
        

        <div class="field">
            <div class="mainField">
                <div class="topBar">
                    <br>
                </div>
                <div class="membershipField">
                    <div class="sidebar">
                        <button class="btn active" data-target="panel1">월간 플랜</button>
                        <button class="btn" data-target="panel2">연간 플랜</button>
                        <button class="btn" data-target="panel3">추가 예정</button>
                        <button class="btn" data-target="panel4">추가 예정</button>
                    </div>
                    <div class="content">
                        <div id="panel1" class="panel active">
                            <div class="title">
                                <div>
                                    <span>
                                        <span>월간 구독</span>
                                        <i class="fa-solid fa-paper-plane" style="color: skyblue;"></i>
                                    </span>
                                </div>
                                <div class="price">
                                    4,900원
                                </div>
                            </div>
                            <div class="btnField">
                                <button v-if="status === 'U'" class="subBtn" @click="fnSub('구독(1개월)',4900, 'M')">구독하기</button>
                                <button v-else-if="status === 'S'" class="subBtn" @click="fnSub('구독(1개월)',4900, 'M')">연장하기</button>
                                <!-- <button @click="fnCancel">취소하기</button> -->
                            </div>
                            <div class="explainField">
                                <br>
                                <br>
                                <!-- <div class="verticalMid">기본 일정 생성 가능</div>
                                <div class="verticalMid">일정 저장 및 불러오기</div> -->
                                <div class="verticalMid">포인트 추가 적립 2%</div>
                                <div class="verticalMid">경로 생성 기능 일일 최대 5번</div>
                            </div>
                        </div>
                        <div id="panel2" class="panel">
                            <div class="title">
                                <div>
                                    <span>
                                        <span>연간 구독</span>
                                        <i class="fa-solid fa-paper-plane" style="color: skyblue;"></i>
                                    </span>
                                </div>
                                <div class="price">
                                    49,000원
                                </div>
                            </div>
                            <div class="btnField">
                                <button v-if="status === 'U'" class="subBtn" @click="fnSub('구독(1년)',49000, 'Y')">구독하기</button>
                                <button v-else-if="status === 'S'" class="subBtn" @click="fnSub('구독(1년)',49000, 'Y')">연장하기</button>
                                <!-- <button @click="fnCancel">취소하기</button> -->
                            </div>
                            <div class="explainField">
                                <br>
                                <br>
                                <!-- <div class="verticalMid">기본 일정 생성 가능</div>
                                <div class="verticalMid">일정 저장 및 불러오기</div> -->
                                <div class="verticalMid">포인트 추가 적립 2%</div>
                                <div class="verticalMid">경로 생성 기능 일일 최대 5번</div>
                            </div>
                        </div>
                        <div id="panel3" class="panel">추가 예정입니다.</div>
                        <div id="panel4" class="panel">추가 예정입니다.</div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <%@ include file="../components/footer.jsp" %>
</body>
</html>

<script>
    IMP.init("imp06808578");

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                id : window.sessionData.id,
                status : window.sessionData.status,
                sellItem : "",
                sellPrice : "",
                sellTag : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
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

            fnPanelControl : function () {
                let buttons = document.querySelectorAll('.btn');
                let panels = document.querySelectorAll('.panel');

                buttons.forEach(btn => {
                    btn.addEventListener('click', () => {
                        buttons.forEach(b => b.classList.remove('active'));
                        panels.forEach(p => p.classList.remove('active'));

                        btn.classList.add('active');
                        const target = document.getElementById(btn.dataset.target);
                        target.classList.add('active');
                    });
                });
            },

            fnSub: function (itemName, itemPrice, itemTag) {
                let self = this;
                self.sellItem = itemName;
                self.sellPrice = itemPrice;
                self.sellTag = itemTag;
                console.log(self.sellItem);
                console.log(self.sellPrice);
                console.log(self.sellTag);
                self.fnStatusUp();
                IMP.request_pay({
				    pg: "html5_inicis",
				    pay_method: "card",
				    merchant_uid: "merchant_" + new Date().getTime(),
				    name: self.sellItem,
				    amount: 1, //판매 가격, 실제 판매시에는 1을 self.sellPrice로 변경
				    buyer_tel: "010-0000-0000",
                }, 
                function (rsp) { // callback
			   	      if (rsp.success) {
			   	        // 결제 성공 시
						// alert("성공");
						console.log(rsp);
                        // self.imp_uid = rsp.imp_uid;
                        // self.paid_amount = rsp.paid_amount;
                        // self.fnPayHistory();

                        //결제 성공 시, 사용자의 스테이터스와 itemTag로 구분해서 실행

                        //결제 성공 시, user의 status를 구독자 등급으로 변경
                        self.fnStatusUp();
			   	      } else {
			   	        // 결제 실패 시
						alert("오류가 발생했습니다.");
                        return;
			   	      }
		   	  	});
            },

            fnStatusUp : function () {
                let self = this;
                let subsDay = "";
                if(self.sellTag=='Y'){
                    subsDay = 365;
                } else if(self.sellTag=='M'){
                    subsDay = 30;
                }
                let param = {
                    userId : self.id,
                    status : self.status,
                    sellTag : self.sellTag,
                    subsDay : subsDay
                };
                console.log(param);
                $.ajax({
                    url: "/mypage/statusUp.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            alert(data.msg);
                            location.reload(); // 현재 창 새로고침
                            // location.href="/myInfo.do";
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

            self.fnPanelControl();
        }
    });

    app.mount('#app');
</script>