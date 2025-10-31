<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
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
            width: 100%;
            height: 600px;
        }
        .btnField{
            margin: 10px auto;
            width: 800px;
            text-align: center;
        }
        .btnField button{
            width: 250px;
            height: 150px;
            font-size: 35px;
            margin-top: 30% ;
            border-radius: 10px;
            background-color: #0078FF;
            border-color:  #0078FF;
            color: white;
        }
        .btnField button:hover{
            cursor: pointer;
            background-color: rgb(6, 81, 131);
        }
        .idBtn{
            float: left;
        }
        .pwdBtn{
            float: right;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <%@ include file="../components/header.jsp" %>

        <div class="field">
            <div class="btnField">
                <button class="idBtn" @click="fnFindId">아이디 <br> 찾기</button>
                <button class="pwdBtn" @click="fnFindPwd">비밀번호 <br> 재설정</button>
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
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnFindId: function () {
                location.href="/member/findId.do";
            },

            fnFindPwd : function () {
                location.href="/member/findPwd.do";
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>