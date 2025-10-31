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
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <style>
            /* 수정/등록 폼 테이블 */
            table {
                width: 80%;
                margin: 30px auto;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
                overflow: hidden;
                font-family: 'Noto Sans KR', sans-serif;
                text-align: left;
            }

            th {
                background-color: #0078FF;
                color: white;
                font-weight: 600;
                padding: 14px 20px;
                width: 130px;
                vertical-align: middle;
                font-size: 15px;
            }

            td {
                padding: 15px 20px;
                border-bottom: 1px solid #eee;
                font-size: 14px;
            }

            /* select 스타일 */
            select {
                width: 150px;
                padding: 8px 12px;
                font-size: 14px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-family: 'Noto Sans KR', sans-serif;
            }

            select:focus {
                outline: none;
                border-color: #0078FF;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.3);
            }

            /* input 스타일 */
            input[type="text"] {
                width: 100%;
                padding: 10px 12px;
                font-size: 14px;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-family: 'Noto Sans KR', sans-serif;
            }

            input[type="text"]:focus {
                outline: none;
                border-color: #0078FF;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.3);
            }

            /* 에디터 div */
            #editor {
                height: 300px;
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 12px;
                font-size: 14px;
                font-family: 'Noto Sans KR', sans-serif;
                overflow-y: auto;
            }

            /* 버튼 중앙 정렬 */
            div {
                width: 80%;
                margin: 20px auto 40px;
                text-align: center;
            }

            /* 저장 버튼 스타일 */
            button {
                background-color: #0078FF;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 28px;
                font-size: 15px;
                cursor: pointer;
                transition: background-color 0.25s ease;
            }

            button:hover {
                background-color: #005FCC;
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
                <tr>
                    <th>작성자</th>
                    <td>{{userId}}</td>
                </tr>

                <tr>
                    <th>게시글 종류</th>
                    <td>
                        <select v-model="type">
                            <option value="N">::공지사항::</option>
                            <option value="F">::자유게시판::</option>
                            <option value="Q">::질문게시판::</option>
                    </td>

                    </select>
                </tr>

                <tr>
                    <th>내용</th>

                    <td style="height: 300px; padding: 30px;">
                        <!-- <textarea v-model="contents" cols="50" rows="20"></textarea> -->
                        <div id="editor"></div>
                    </td>

                </tr>
            </table>
            <div>
                <button @click="fnAdd">저장</button>
            </div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    title: "",
                    userId: "${sessionId}",
                    contents: "",
                    type: "N",
                    sessionId: "${sessionId}"

                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnAdd: function () {
                    let self = this;
                    let param = {
                        title: self.title,
                        contents: self.contents,
                        userId: self.userId,
                        type: self.type
                    };
                    $.ajax({
                        url: "/board-add.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            // if(self.title == ""){
                            //     alert("제목을 적어주세요");
                            // }else{
                                
                            //     alert("저장하시겠습니까?");   
                            //     alert("등록되었습니다.");
                            // console.log(data.boardNo);
                            // location.href = "board-list.do";
                            // }
                           
                           if(confirm("저장하시겠습니까?")){
                            if(self.title == ""){
                                alert("제목을 적어주세요");
                            }else{
                                 alert("등록되었습니다.");
                            console.log(data.boardNo);
                            location.href = "board-list.do";
                           }



                        }
                    }
                    });
                },
                // 파일 업로드
                upload: function (form) {
                    var self = this;
                    $.ajax({
                        url: "/fileUpload.dox"
                        , type: "POST"
                        , processData: false
                        , contentType: false
                        , data: form
                        , success: function (data) {
                            console.log(data);
                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                if (self.sessionId == "") {
                    alert("로그인 후 이용해 주세요");
                    location.href = "/member/login.do";
                }

                // Quill 에디터 초기화
                var quill = new Quill('#editor', {
                    theme: 'snow',
                    modules: {
                        toolbar: [
                            [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                            ['bold', 'italic', 'underline'],
                            [{ 'list': 'ordered' }, { 'list': 'bullet' }],
                            ['link', 'image'],
                            ['clean']
                        ]
                    }
                });

                // 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
                quill.on('text-change', function () {
                    self.contents = quill.root.innerHTML;
                });

            }
        });

        app.mount('#app');
    </script>