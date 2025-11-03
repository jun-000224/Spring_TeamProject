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
            기본 일정 생성 가능
            <br>
            일정 저장 및 불러오기
            <br>
            경로 생성 기능 일일 최대 5번
        </div>
        <div>
            {{userId}}
        </div>
        <div>
            <button @click="fnSub">구독하기</button>
            
            <button @click="fnCancel">취소하기</button>
        </div>
        
    </div>
</body>
</html>

<script>
    const userCode = ""; 
	IMP.init("imp06808578");

    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnSub: function () {
                let self = this;
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
                if (event.origin !== window.location.origin) return; // 보안 체크
                    //같은 도메인이 아니면 실행 X
                self.userId = event.data.userId;
                console.log("받은 세션:", self.userId);
            },

            fnCancel : function () {
                window.close();
            },

            fnStatusUp : function () {
                let self = this;
                let param = {
                    userId : self.userId
                };
                $.ajax({
                    url: "/mypage/statusUp.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if(data.result=="success"){
                            alert(data.msg);
                            location.href="/myInfo.do";
                            window.close();
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