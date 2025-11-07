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
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-images.css">
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <style>
            table {
                width: 60%;
                margin: 30px auto;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
                overflow: hidden;
                text-align: center;
                font-family: 'Noto Sans KR', sans-serif;
            }

            th {
                background-color: #0078FF;
                border-bottom: 1px solid #eee;
                color: white;
                font-weight: 600;
                padding: 14px;
                font-size: 15px;
                width: 120px;
            }

            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                font-size: 20px;
                text-align: center;
                font-weight: bold;
            }

            /* input, textarea 스타일 */
            input[type="text"],
            textarea {
                width: 100%;
                border: 1px solid #ccc;
                border-radius: 6px;
                padding: 10px;
                font-size: 14px;
                resize: vertical;
                font-family: 'Noto Sans KR', sans-serif;
            }

            input[type="text"]:focus,
            textarea:focus {
                outline: none;
                border-color: #0078FF;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.3);
            }

            /* 버튼 영역 중앙 정렬 및 버튼 오른쪽 정렬 */
            #update-button-area {
                width: 60%;
                /* 테이블과 동일한 너비 */
                margin: 20px 25%;
                /* 중앙 정렬 */
                text-align: center;
                /* 버튼 오른쪽 정렬 */
            }

            /* table+div {
        text-align: center;
        margin: 20px auto 40px;
    }
    // 이전에 사용하셨던 table+div 스타일은 #update-button-area로 대체되었으므로 주석 처리하거나 삭제하는 것이 좋습니다.
    */


            /* 수정 버튼 스타일 */
            button {
                background-color: #0078FF;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 22px;
                font-size: 15px;
                cursor: pointer;
                transition: background-color 0.25s ease;

            }

            button:hover {
                background-color: #005FCC;
            }

            #editor {
                padding: 10px;
            }

            /* 제목 입력 필드 전용 스타일 */
            .input-title {
                font-size: 18px;
                color: #333;
                height: 20px;
                width: 80%;
                padding: 8px 15px;
                border-radius: 10px;
                border: none;
                background-color: #f5f6f8;
            }
            .userId{
                width: 80%;
                margin: 0 auto;
                text-align: center;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <%@ include file="components/header.jsp" %>
                <table>
                    <tr>
                        <th>제목</th>
                        <td><input v-model="title" class="input-title" placeholder="제목을 입력하세요"></td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td>
                            <div class="userId">
                                {{userId}}
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>내용</th>

                        <td style="height: 300px; padding: 50px;">
                            <!-- <textarea v-model="contents" cols="50" rows="20"></textarea> -->
                            <div id="editor"></div>
                        </td>

                    </tr>

                </table>
                <div id="update-button-area">
                    <button @click="fnUpdate">수정</button>
                </div>
        </div>

        </div>

        <%@ include file="components/footer.jsp" %>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    boardNo: "${boardNo}",
                    title: "",
                    contents: "",
                    userId: "${sessionId}"
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnInfo: function () {
                    let self = this;
                    let param = {
                        boardNo: self.boardNo,
                        userId: self.userId
                    };
                    $.ajax({
                        url: "board-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                console.log(data);
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
                        boardNo: self.boardNo,
                        userId: self.userId
                    };
                    $.ajax({
                        url: "/board-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (confirm("정말 수정하시겠습니까?")) {
                                if (data.result == "success") {
                                    alert("수정이 완료되었습니다!");
                                    history.back();
                                } else {
                                    alert("오류발생");
                                }
                            }
                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnInfo();


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