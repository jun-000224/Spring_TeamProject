<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <table>
                 
                <tr>
                    <th>제목</th>
                    <td>{{info.title}}</td>
                </tr>

                <tr>
                    <th>작성자</th>
                    <td>{{info.userId}}</td>

                </tr>
                <tr>
                    <th>조회수</th>
                    <td>{{info.cnt}}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        {{info.contents}}
                    </td>
                </tr>
                <div>
                    <button @click="fnRemove">삭제</button> 
                </div>
                <div>
                     <button @click="fnUpdate">수정</button>
                </div>




            </table>

            <hr>


            <table id="comment">
                <tr v-for="item in commentList">

                    <th>{{item.commentNo}}</th>

                    <!-- <th>{{item.nickName}}</th> -->

                    <th>
                        {{item.contents}}
                    </th>
                    <td><button>삭제</button></td>
                    <td><button>수정</button></td>
                </tr>


            </table>


            <table id="input">
                <th>댓글 입력</th>
                <td>
                    <textarea cols="40" rows="4" v-model="contents"></textarea>
                </td>
                <td>
                    <button @click="fnSave">저장</button>
                </td>
            </table>



            </table>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    info: {},
                    boardNo: "${boardNo}",
                    commentList: [],
                    sessionId: "${sessionId}",
                    contents: ""
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnInfo: function () {

                    let self = this;
                    let param = {
                        boardNo: self.boardNo,

                    };
                    $.ajax({
                        url: "board-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log("ddd");
                            self.info = data.info;

                            self.commentList = data.commentList;
                            console.log(self.commentList);
                        }
                    });
                },
                fnSave: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo,

                        contents: self.contents
                    };
                    $.ajax({
                        url: "/comment/add.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            self.contents = "";
                            self.fnInfo();
                        }
                    });
                },

                fnRemove: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo,
                    };
                    $.ajax({
                        url: "/view-delete.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            alert("삭제됨");
                            location.href="board-list.do";
                        }
                    });
                },
          
                fnUpdate : function(){
                    
                    let self = this;
                    console.log(self.boardNo);
                pageChange("board-edit.do", {boardNo : self.boardNo}); 
            },
             

                
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnInfo();
            }
        });

        app.mount('#app');
    </script>
