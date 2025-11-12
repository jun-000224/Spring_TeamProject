<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>포인트</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="/css/main-style.css">
    <link rel="stylesheet" href="/css/common-style.css">
    <link rel="stylesheet" href="/css/header-style.css">
    <link rel="stylesheet" href="/css/main-images.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        
        .field{
            width: 75%;
            margin: 20px auto;
            /* border:1px solid black; */
            height: 70%;
        }
        .mainField{
            display: flex;
            justify-content: space-between;
        }
        .leftField{
            width: 32%;
            border:1px solid rgb(218, 218, 218);
            /* float: left; */
            background-color: rgb(218, 218, 218);
            text-align: center;
            box-shadow: 0px 0px 10px  rgb(141, 141, 141);
            border-radius: 5px;
            height: 600px;
        }
        .rightField{
            width: 65%;
            /* border:1px solid black; */
            /* float: right; */
        }
        .circleTest{
            margin: 10px auto;
            border: 1px solid rgb(218, 218, 218);
            border-radius: 50%;
            width: 200px;
            height: 200px;
            text-align: center;

            display: flex;
            justify-content: center;
            align-items: center;

            margin-bottom: 30px;

            overflow: hidden;
            background-color: #f0f0f0;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .userNick{
            font-size: 20px;
        }
        .menuField{
            text-align: left;
            margin-left: 15%;
        }
        .userMenu{
            margin-top: 20px;
            height: 20px;
        }
        .tableField{
            /* border: 1px solid black; */
            margin-top: 50px;
            /* border: 1px solid black; */
        }
        .pointTable{
            margin: 10px auto;
            font-weight: bold;
            width: 97%;
            border : 1px solid rgb(199, 199, 199);
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
            border-radius: 10px;
            overflow: hidden;
        }
        .pointTable th{
            font-size: 14px;
            background-color: #0078FF;
            color: white;
            padding : 5px 10px;
        }
        .pointTable td{
            background-color: white;
            padding : 5px 10px;
        }
        .pointGet{
            color: green;
        }   
        .pointOut{
            color: crimson;
        }
        .infoField{
            background-color: white;
            border-radius: 5px;
            width: 90%;
            margin: 0px auto;
            padding-top: 10px;

            min-height: 337px;
        }
        .remainPoint{
            width: 97%;
            height: 50px;
            margin: 0px auto;
            background-color: white;
            border-radius: 5px;
            font-size: 15px;

            display: flex;
            align-items: center;

            box-shadow: 0px 0px 10px  rgb(187, 187, 187);
        }
        .remainInfo{
            margin-left: 1.5%;
            font-weight: bold;
            font-size: 16px;
        }
        .topRemainPoint{
            font-size: 17px;
            font-weight: bold;
        }
        .rP{
            margin-left: 10%;
        }
        /* .profile-card {
            display: flex;
            align-items: center;
            background: linear-gradient(to right, #e0f7fa, #e1bee7);
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px;
        } */

        .profile-img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            margin-right: 20px;
            object-fit: cover;
            object-position: center;
            display: block; 
            border-radius: 50%;   
            margin-left: 20px;
        }
    </style>
</head>
<body>
<%@ include file="../components/header.jsp" %>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->

        <div class="field">
            <div class="mainField">
                <div class="leftField">
                    <div class="circleTest profile-card">
                        <img :src="profileImgPath" alt="프로필 이미지 넣는곳" class="profile-img">
                    </div>
                    <div class="infoField">
                        <div>
                            <span class="userNick">{{nickname}} 님</span>
                            {{gradeLabel}}
                        </div>
                        <div>
                             
                        </div>
                        <div class="menuField">
                            <div class="userMenu">
                                <a href="/main-myPage.do">
                                    <span>
                                        <i class="fa-solid fa-circle-user"></i>
                                        내 정보
                                    </span>
                                </a>
                            </div>
                            <div class="userMenu">
                                
                            </div>
                        </div>


                        <!-- <div>
                            {{info}}
                        </div> -->
                    </div>
                </div>

                <div class="rightField">
                    <div class="remainPoint">
                        <span class="rP">
                            잔여 포인트 : 
                            <span class="topRemainPoint">{{point}} P</span>
                        </span>
                    </div>
                    <div class="tableField">
                        <div class="remainInfo">
                            포인트 변동내역
                        </div>
                        <div v-if="list.length != 0">
                            <table class="pointTable">
                                <tr>
                                    <th>
                                        잔여 포인트
                                    </th>
                                    <th>
                                        증가량
                                    </th>
                                    <th>
                                        감소량
                                    </th>
                                    <th>
                                        날짜
                                    </th>
                                </tr>

                                <!-- <tr v-for="num in 10">
                                    <td>test</td>
                                    <td class="pointGet">test</td>
                                    <td class="pointOut">test</td>
                                    <td>2025-11-{{num}}</td>
                                </tr> -->
                                
                                <tr v-for="item in displayedList">
                                    <td>
                                        {{item.pointTotal}}
                                    </td>
                                    <td class="pointGet">
                                        {{item.pointGet}}
                                    </td>
                                    <td class="pointOut">
                                        {{item.pointOut}}
                                    </td>
                                    <td>
                                        {{item.pDate}}
                                    </td>
                                </tr>
                            </table>
                            <div v-if="list.length > 11" style="text-align:center; margin-top:10px;">
                                <button @click="fnShowList" 
                                        style="padding:5px 15px; border:none; border-radius:5px; background-color:#0078FF; color:white; cursor:pointer;">
                                    {{ showAll ? '접기 ▲' : '더보기 ▼' }}
                                </button>
                            </div>
                        </div>
                        <div v-else>
                            <table class="pointTable">
                                <tr>
                                    <th>
                                        잔여 포인트
                                    </th>
                                    <th>
                                        증가량
                                    </th>
                                    <th>
                                        감소량
                                    </th>
                                    <th>
                                        날짜
                                    </th>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        포인트 내역이 없습니다.
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
    </div>
    
<%@ include file="../components/footer.jsp" %>
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
                gradeLabel : window.sessionData.gradeLabel,

                showAll : false,

                info : {},
                list : [],

                profileImgPath : ""
            };
        },
        computed : {
            displayedList() {
                // ✅ showAll이 true면 전체, 아니면 10개까지만
                return this.showAll ? this.list : this.list.slice(0, 11);
            }
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnShowList : function () {
                let self = this;
                self.showAll = !self.showAll
            },
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
                        //console.log(data);
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
                        //console.log(data);
                        self.list = data.list;
                    }
                });
            },

            fnProfilePath : function () {
                    let self = this;
                    let param = {
                        userId : self.id
                    };
                    $.ajax({
                        url:"/member/profilePath.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data){
                            //console.log(data.info);
                            if(data.info.storUrl != null){
                                self.profileImgPath = data.info.storUrl;
                                // console.log("no");
                            } else {
                                self.profileImgPath = "/img/profile/default_profile.jpg"
                            }
                        }
                    })
                }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnPointRecent();
            self.fnPointIncdec();
            self.fnProfilePath();
        }
    });

    app.mount('#app');
</script>