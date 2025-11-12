<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>댓글 수정</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
        <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
        <style>
            /* -------------------- 🎨 기본 레이아웃 및 폰트 -------------------- */
            @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap');

            body {
                font-family: 'Noto Sans KR', sans-serif;
                background-color: #f4f7f6;
                padding-top: 50px;
                margin: 0;
            }

            /* -------------------- <table> 스타일 -------------------- */
            table {
                width: 700px;
                /* 게시글 테이블 너비 조정 */
                margin: 30px auto;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                /* 그림자 강화 */
                border-radius: 12px;
                overflow: hidden;
            }

            th {
                background-color: #0078FF;
                color: white;
                font-weight: 600;
                padding: 20px;
                font-size: 16px;
                width: 120px;
                text-align: center;
                /* vertical-align: top; 내용이 길어져도 상단 정렬 유지 */
                vertical-align: middle;
            }

            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                font-size: 15px;
                text-align: left;
            }



            /* 테이블의 마지막 행 하단 border 제거 */
            tr:last-child td {
                border-bottom: none;
            }

            /* -------------------- Quill Editor 스타일 조정 -------------------- */
            /* Quill 에디터의 컨텐츠 영역 (ql-editor) 최소 높이 설정 */
            .ql-editor {
                min-height: 300px;
                /* 최소 높이를 300px로 설정 */
                padding: 15px;
                /* 에디터 내부 패딩 */
                font-size: 15px;
                line-height: 1.6;
            }

            /* Quill 에디터 컨테이너의 border-radius와 box-shadow 제거 */
            .ql-container.ql-snow {
                border: none;
                border-top: 1px solid #ccc;
                /* 툴바와 내용 분리 */
                font-family: 'Noto Sans KR', sans-serif;
            }



            /* -------------------- 버튼 스타일 -------------------- */
            .button-container {
                text-align: right;
                /* 버튼을 오른쪽으로 정렬 */
                margin: 20px auto 40px;
                width: 700px;
                /* 테이블 너비와 동일하게 설정 */
            }

            button {
                background-color: #0078FF;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 30px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.25s ease, transform 0.1s;
                font-weight: 500;

            }





            /* 취소/이전 버튼 스타일 */
            button.cancel-btn {
                background-color: #95a5a6;
                margin-right: 10px;
                /* 다른 버튼과의 간격 */
                box-shadow: 0 2px 4px rgba(149, 165, 166, 0.4);
            }
        </style>
    </head>

    <body>
        <div id="app">

            <table>

                <tr>
                    <th>작성자</th>
                    <td>{{sessionId}}</td>
                </tr>
                <tr class="cContents">
                    <th>내용</th>
                    <td>
                        <div id="editor"></div>
                    </td>
                </tr>

            </table>
            <div class="button-container">
                <button @click="fnUpdate">수정</button>
            </div>

        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    sessionId: "${sessionId}",
                    contents: "", // Quill 에디터 내용이 여기에 저장됩니다.
                    commentNo: "${commentNo}",
                    userId: "",
                    boardNo: "${boardNo}"
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                // fnInfo: function () {
                //         let self = this;
                //         let param = { 
                //             commentNo: self.commentNo,

                //         };

                //         $.ajax({
                //             url: "/comment-view.dox",
                //             dataType: "json",
                //             type: "POST",
                //             data: param,
                //             success: function (data) {
                //                 if (data.result == "success") {
                //                     console.log(data);
                //                     self.userId = data.info.userId
                //                     self.contents = data.info.contents // 기존 내용 Vue 변수에 저장

                //                     // Quill 에디터에 기존 내용 로드
                //                     let quill = self.quillInstance;
                //                     if (quill) {
                //                         quill.root.innerHTML = self.contents;
                //                     }

                //                 } else {
                //                     alert("오류가 발생했습니다!");
                //                 }
                //             }
                //         });
                //     },

                fnUpdate: function () { // commentNo를 인자로 받지 않도록 수정 (this.commentNo 사용)
                    let self = this;
                    // Quill 인스턴스에서 HTML이 아닌 '순수 텍스트'만 가져오기
                    let textContent = self.quillInstance.getText().trim();

                    if (self.contents.trim() === "") {
                        alert("내용을 입력해 주세요.");
                        return;
                    }

                    let param = {
                        contents: textContent, // ✨ HTML이 아닌 텍스트로 저장
                        commentNo: self.commentNo,

                    };
                    $.ajax({
                        url: "/board-comment-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("수정되었습니다.");
                                // ✅ 수정 후 해당 게시글 상세 페이지로 이동
                                //console.log("이동할 게시글 번호:", self.boardNo);
                                location.href = "/board-view.do?boardNo=" + self.boardNo;
                            } else {
                                alert("오류가 발생했습니다.");
                            }

                        }
                    });
                }
            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                if (self.sessionId === "") {
                    alert("로그인 후 이용해 주세요.");
                    location.href = "/member/login.do";
                    return;
                }

                // 1. Quill 에디터 초기화 및 인스턴스 저장
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
                self.quillInstance = quill; // Vue 인스턴스에 Quill 인스턴스 저장

                // 2. 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
                quill.on('text-change', function () {
                    // Quill 에디터의 HTML 내용을 Vue 데이터에 저장
                    self.contents = quill.root.innerHTML;
                });

                // 3. 기존 댓글 정보 불러오기
                // self.fnInfo();

            }
        });

        app.mount('#app');
    </script>