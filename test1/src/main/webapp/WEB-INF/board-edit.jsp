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
                    <td><input v-model="title"></td>
                </tr>
                <!-- <tr>
                        <th>작성자</th>
                        <td>{{userId}}</td>
                    </tr> -->
                <tr>
                    <th>내용</th>
                    <td><textarea v-model="contents" cols="50" rows="20"></textarea> </td>
                </tr>
                <div>
                    <button @click="fnUpdate">수정</button>
                </div>
            </table>
        </div>

        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    boardNo: "${boardNo}",
                    title: "",
                    contents: ""
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnInfo: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo
                    };
                    $.ajax({
                        url: "board-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                self.title = data.info.title;
                                self.contents = data.info.contents;
                            } else {
                                alert("오류가 발생했습니다!");
                            }
                        }
                    });
                },





                fnUpdate: function () {
                    let self = this;
                    let param = {
                        title: self.title,
                        contents: self.contents,
                        boardNo: self.boardNo
                    };
                    $.ajax({
                        url: "/board-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("수정됨");
                                location.href = "board-list.do"
                            } else {
                                alert("오류발생");
                            }

                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnInfo();
            }
        });

        app.mount('#app');
    </script>