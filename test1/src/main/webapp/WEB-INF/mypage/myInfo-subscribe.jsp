<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .field{
            background-color: #0078FF;
            height: 680px;
            text-align: center;
        }
        .subField{
            width: 500px;
            height: 630px;
            margin: 0px auto;
            padding-top: 10px;
            background-color: white;
            border-radius: 10px;
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
        .headField{
            height: 20px;
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
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="field">
            <div class="headField" style="background-color: #0078FF;">
                <br>
            </div>
            <div class="subField">
                <!-- ,{{status}} -->
                <div class="title">
                    <div>
                        <span>
                            월간 플랜
                            
                            <i class="fa-solid fa-paper-plane" style="color: skyblue;"></i>
                        </span>
                    </div>
                    <div class="price">
                        4,900원
                    </div>
                </div>
                <div class="btnField">
                    <button class="subBtn" @click="fnSub">구독하기</button>
                
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
        </div>

        
        
    </div>
</body>
</html>

<script>
    // const userCode = ""; 
	IMP.init("imp06808578");

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId : "",
                status : "",
                subsDay : 30
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnSub: function () {
                let self = this;
                self.fnStatusUp();
                IMP.request_pay({
				    pg: "html5_inicis",
				    pay_method: "card",
				    merchant_uid: "merchant_" + new Date().getTime(),
				    name: "구독(1개월)",
				    amount: 1,
				    buyer_tel: "010-0000-0000",
				  }	, function (rsp) { // callback
			   	      if (rsp.success) {
			   	        // 결제 성공 시
						// alert("성공");
						console.log(rsp);
                        // self.imp_uid = rsp.imp_uid;
                        // self.paid_amount = rsp.paid_amount;
                        // self.fnPayHistory();

                        //결제 성공 시, user의 status를 구독자 등급으로 변경
                        self.fnStatusUp();
			   	      } else {
			   	        // 결제 실패 시
						alert("오류가 발생했습니다.");
                        return;
			   	      }
		   	  	});
            },

            fnReceiveMessage(event) {
                //부모창에서 보낸 정보가 event의 형태로 받아짐
                let self=this;
                // console.log(event);
                // console.log(event);
                if (event.origin !== window.location.origin) return; // 보안 체크
                    //같은 도메인이 아니면 실행 X
                self.userId = event.data.userId;
                self.status = event.data.status;
                console.log("받은 세션:", self.userId);
                console.log(self.status);
            },

            fnCancel : function () {
                window.close();
            },

            fnStatusUp : function () {
                let self = this;
                let param = {
                    userId : self.userId,
                    status : self.status,
                    subsDay : self.subsDay
                };
                $.ajax({
                    url: "/mypage/statusUp.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            alert(data.msg);
                            if (window.opener && !window.opener.closed) {
                                window.opener.location.reload();
                            }
                            // opener.location.reload();
                            // location.href="/myInfo.do";
                            window.close();
                        } else {
                            alert(data.msg);
                            return;
                        }
                    }
                });
            },
            
            fnMemberInfo : function () {
                let self = this;
                let param = {
                    userId : self.userId
                };
                $.ajax({
                    url: "/member/findId.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
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