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
        <style>
            /* =========================
📘 게시글 기본 스타일
========================= */
            table {
                width: 80%;
                margin: 30px auto;
                border-collapse: collapse;
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
                font-family: 'Noto Sans KR', sans-serif;
            }

            th {
                background-color: #0078FF;
                color: white;
                font-weight: 600;
                padding: 14px;
                font-size: 16px;
                width: 140px;
            }

            td {
                padding: 16px 20px;
                border-bottom: 1px solid #eee;
                font-size: 16px;
                color: #333;
                text-align: left;
            }

            /* 제목 입력 */
            .input-title {
                font-size: 17px;
                padding: 8px 12px;
                width: 95%;
                border: 1px solid #ccc;
                border-radius: 6px;
            }

            /* =========================
📗 버튼 스타일
========================= */
            button {
                background-color: #0078FF;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 10px 18px;
                font-size: 15px;
                cursor: pointer;
                transition: all 0.2s;
            }

            button:hover {
                background-color: #005FCC;
                transform: translateY(-1px);
            }

            .cancel-btn {
                background-color: #aaa;
                margin-right: 20px;
            }

            .cancel-btn:hover {
                background-color: #888;
            }

            .button-container {
                text-align: center;
                margin: 30px 20px 20px 100px;

            }

            /* =========================
💬 댓글 영역
========================= */
            .comment-section {
                width: 80%;
                margin: 60px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.06);
                padding: 25px 30px;
            }

            .comment-section h3 {
                font-size: 22px;
                color: #0078FF;
                margin-bottom: 20px;
                border-bottom: 2px solid #0078FF;
                display: inline-block;
                padding-bottom: 5px;
            }

            /* 댓글 리스트 */
            #comment-list {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 25px;
            }

            #comment-list tr {
                border-bottom: 1px solid #eee;
                transition: background 0.2s;
            }

            #comment-list tr:hover {
                background: #f9fbff;
            }

            #comment-list td {
                padding: 12px 10px;
                font-size: 15px;
            }

            #comment-list .writer {
                width: 150px;
                font-weight: 600;
                color: #0078FF;
            }

            #comment-list .content {
                flex: 1;
            }

            #comment-list .date {
                width: 160px;
                font-size: 13px;
                color: #888;
            }

            #comment-list .action {
                width: 80px;
                text-align: center;
            }

            .delete-btn {
                background-color: #e74c3c;
            }

            .delete-btn:hover {
                background-color: #c0392b;
            }

            /* 댓글 입력 */
            #input-comment {
                display: flex;
                align-items: center;
                gap: 10px;
                border-top: 1px solid #ddd;
                padding-top: 20px;
            }

            #input-comment textarea {
                flex-grow: 1;
                height: 80px;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 10px 14px;
                font-size: 14px;
                resize: none;
                transition: all 0.2s;
            }

            #input-comment textarea:focus {
                border-color: #0078FF;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.25);
            }

            #input-comment button {
                background-color: #0078FF;
                border: none;
                border-radius: 8px;
                color: white;
                padding: 12px 20px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }

            #input-comment button:hover {
                background-color: #005FCC;
            }

            .board-write {
                width: 90%;
                max-width: 950px;
                margin: 40px auto 80px;
                background: #fff;
                border: 1px solid #d9e2ec;
                border-radius: 10px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
                padding: 30px 40px;
                padding-top: 10px;
            }

            .board-write .write-header {
                border-bottom: 1px solid #e0e6ef;
                padding-bottom: 10px;
                margin-bottom: 15px;
            }

            .board-write .write-header h2 {
                font-size: 22px;
                font-weight: 700;
                color: #0078ff;
            }

            .board-write .form-row {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 15px;
            }

            .board-write .form-row label {
                width: 100px;
                font-weight: 600;
                color: #444;
                text-align: right;
            }

            .board-write .form-row input,
            .board-write .form-row select {
                flex: 1;
                border: 1px solid #cfd7e3;
                border-radius: 6px;
                padding: 9px 12px;
                font-size: 15px;
                transition: border-color 0.2s;
            }

            .board-write .form-row input:focus,
            .board-write .form-row select:focus {
                outline: none;
                border-color: #0078ff;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.25);
            }

            .board-write .title-box {
                margin-top: 10px;
                width: 100%;
            }

            .board-write .title-box input {
                width: 100%;
                border: 1px solid #cfd7e3;
                border-radius: 6px;
                padding: 12px 14px;
                font-size: 16px;
                transition: border-color 0.2s;
                box-sizing: border-box;
            }

            .board-write .title-box input:focus {
                border-color: #0078ff;
                outline: none;
            }

            .board-write .editor-wrapper {
                margin-top: 20px;
            }

            .board-write #editor {
                height: 350px;
                border: 1px solid #cfd7e3;
                border-radius: 8px;
                background: #fff;
                transition: border-color 0.2s;
            }

            .board-write #editor:focus-within {
                border-color: #0078ff;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.2);
            }

            .board-write .info-text {
                margin-top: 10px;
                font-size: 13px;
                color: #888;
                line-height: 1.4;
            }

            .board-write .button-area {
                text-align: center;
                margin-top: 40px;
                padding-top: 25px;
                border-top: 1px solid #e5e9f0;
            }

            .board-write button {
                background-color: #0078ff;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 10px 24px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                margin: 0 10px;
                transition: all 0.2s ease;
            }

            .board-write button:hover {
                background-color: #005fcc;
                transform: translateY(-1px);
            }

            .board-write .cancel-btn {
                background-color: #a0a0a0;
            }

            .board-write .cancel-btn:hover {
                background-color: #7a7a7a;
            }

            @media (max-width: 768px) {
                .board-write {
                    width: 95%;
                    padding: 20px;
                }

                .board-write .form-row {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .board-write .form-row label {
                    width: auto;
                    text-align: left;
                    margin-bottom: 5px;
                }
            }

            .form-row-inline {
                display: flex;
                align-items: center;
                gap: 5%;
                /* 두 항목 사이 간격 */
                width: 100%;
                margin-bottom: 15px;
            }

            /* 작성자 40%, 게시판 종류 60% */
            .form-row-inline .writer-box {
                flex: 0 0 15%;
            }

            .form-row-inline .board-type-box {
                flex: 0 0 20%;
            }

            /* 입력창/셀렉트 기본 스타일 통일 */
            .form-row-inline input,
            .form-row-inline select {
                width: 100%;
                border: 1px solid #cfd7e3;
                border-radius: 6px;
                padding: 9px 12px;
                font-size: 15px;
                transition: border-color 0.2s;
            }

            .form-row-inline input:focus,
            .form-row-inline select:focus {
                border-color: #0078ff;
                outline: none;
                box-shadow: 0 0 5px rgba(0, 120, 255, 0.25);
            }

            /* 반응형: 모바일에서는 세로 정렬 */
            @media (max-width: 768px) {
                .form-row-inline {
                    flex-direction: column;
                    width: 100%;
                }

                .form-row-inline .writer-box,
                .form-row-inline .board-type-box {
                    flex: 1 1 auto;
                    width: 100%;
                }
            }

            .idCell{
                background-color: #0078ff;
                color: white;
                font-weight: bold;
                border: 1px solid #0078ff;
            }
        </style>
    </head>

    <body>
        <%@ include file="components/header.jsp" %>
            <div id="app">

                <div class="board-write">
                    <div class="write-header">
                        <h2>게시글 작성</h2>
                    </div>

                    <div class="form-row-inline">
                        <div class="form-item writer-box">
                            <input class="idCell" type="text" v-model="userId" disabled>
                        </div>

                        <div class="form-item board-type-box">
                            <select v-model="type">
                                <option v-if="sessionStatus==='A'" value="N">공지사항</option>
                                <option value="F">자유게시판</option>
                                <option value="Q">질문게시판</option>
                                <option value="SQ">문의게시판</option>
                            </select>
                        </div>
                    </div>

                    <div class="title-box">
                        <input v-model="title" placeholder="제목을 입력해주세요.">
                    </div>

                    <div class="info-text">
                        ※ 비속어, 허위사실, 저작권 위반 게시물은 삭제될 수 있습니다.
                    </div>

                    <div class="editor-wrapper">
                        <div id="editor"></div>
                    </div>

                    <div class="button-area">
                        <a href="board-list.do"><button class="cancel-btn">취소</button></a>
                        <button @click="fnAdd">등록</button>
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
                    title: "",
                    userId: "${sessionId}",
                    contents: "",
                    type: "F",
                    sessionId: "${sessionId}",
                    sessionStatus: "${sessionStatus}"

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

                            if (confirm("저장하시겠습니까?")) {
                                if (self.title == "") {
                                    alert("제목을 적어주세요");
                                } else {
                                    alert("등록되었습니다.");
                                    //console.log(data);
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
                            //console.log(data);
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