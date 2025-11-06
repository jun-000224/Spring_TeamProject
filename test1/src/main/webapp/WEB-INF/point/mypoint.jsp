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
            width: 85%;
            margin: 0px auto;
            border:1px solid black;
            height: 800px;
        }
        .mainField{
            display: flex;
            justify-content: space-between;
        }
        .leftField{
            width: 34%;
            border:1px solid black;
            /* float: left; */
        }
        .rightField{
            width: 64%;
            border:1px solid black;
            /* float: right; */
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <%@ include file="../components/header.jsp" %>

        <div class="field">
            <div class="mainField">
                <div class="leftField">
                    <div>
                        my point
                    </div>
                    <div>
                        {{id}}, {{status}}, {{nickname}}, {{name}}, {{point}}
                    </div>
                </div>
                <div class="rightField">
                    <div>
                        {{info}}
                    </div>
                    <div>
                        <br>
                    </div>
                    <div>
                        {{list}}
                    </div>
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
                id: window.sessionData.id,
                status: window.sessionData.status,
                nickname: window.sessionData.nickname,
                name: window.sessionData.name,
                point: window.sessionData.point,

                info : {},
                list : []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnPointRecent: function () {
                let self = this;
                let param = {
                    userId : self.id
                };
                $.ajax({
                    url: "/point/recent.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                    }
                });
            },

            fnPointIncdec: function () {
                let self = this;
                let param = {
                    userId : self.id
                };
                $.ajax({
                    url: "/point/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnPointRecent();
            self.fnPointIncdec();
        }
    });

    app.mount('#app');
</script>