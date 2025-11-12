<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 수정</title>

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
📘 게시글 작성/수정 공통 스타일
========================= */
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

        .form-row-inline {
            display: flex;
            align-items: center;
            gap: 5%;
            width: 100%;
            margin-bottom: 15px;
        }

        .form-row-inline .writer-box {
            flex: 0 0 15%;
        }

        .form-row-inline .board-type-box {
            flex: 0 0 20%;
        }

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

        .title-box {
            margin-top: 10px;
            width: 100%;
        }

        .title-box input {
            width: 100%;
            border: 1px solid #cfd7e3;
            border-radius: 6px;
            padding: 12px 14px;
            font-size: 16px;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }

        .title-box input:focus {
            border-color: #0078ff;
            outline: none;
        }

        .editor-wrapper {
            margin-top: 20px;
        }

        #editor {
            height: 350px;
            border: 1px solid #cfd7e3;
            border-radius: 8px;
            background: #fff;
            transition: border-color 0.2s;
        }

        #editor:focus-within {
            border-color: #0078ff;
            box-shadow: 0 0 5px rgba(0, 120, 255, 0.2);
        }

        .info-text {
            margin-top: 10px;
            font-size: 13px;
            color: #888;
            line-height: 1.4;
        }

        .button-area {
            text-align: center;
            margin-top: 40px;
            padding-top: 25px;
            border-top: 1px solid #e5e9f0;
        }

        button {
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

        button:hover {
            background-color: #005fcc;
            transform: translateY(-1px);
        }

        .cancel-btn {
            background-color: #a0a0a0;
        }

        .cancel-btn:hover {
            background-color: #7a7a7a;
        }

        .idCell {
            background-color: #0078ff;
            color: white;
            font-weight: bold;
            border: 1px solid #0078ff;
        }

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
    </style>
</head>

<body>
    <%@ include file="components/header.jsp" %>
    <div id="app">
        <div class="board-write">
            <div class="write-header">
                <h2>게시글 수정</h2>
            </div>

            <div class="form-row-inline">
                <div class="form-item writer-box">
                    <input class="idCell" type="text" v-model="info.userId" disabled>
                </div>
            </div>

            <div class="title-box">
                <input v-model="title" placeholder="제목을 입력해주세요.">
            </div>

            <div class="editor-wrapper">
                <div id="editor"></div>
            </div>

            <div class="button-area">
                <a href="javascript:history.back()"><button class="cancel-btn">취소</button></a>
                <button @click="fnUpdate">수정 완료</button>
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
                boardNo: "${boardNo}",
                title: "",
                contents: "",
                userId: "${sessionId}",
                info: {},
                authorId: "",
                quill: "",
            };
        },
        methods: {
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
                            self.info = data.info;
                            self.title = data.info.title;
                            self.authorId = data.info.userId;
                            self.contents = data.info.contents;

                            self.$nextTick(() => {
                                if (self.quill) {
                                    self.quill.root.innerHTML = self.contents;
                                }
                            });
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
                if (confirm("정말 수정하시겠습니까?")) {
                    $.ajax({
                        url: "/board-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("수정이 완료되었습니다!");
                                history.back();
                            } else {
                                alert("오류 발생");
                            }
                        }
                    });
                }
            }
        },
        mounted() {
            let self = this;

            // Quill 에디터 초기화
            self.quill = new Quill('#editor', {
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

            // 에디터 내용이 변경될 때마다 Vue 데이터 업데이트
            self.quill.on('text-change', function () {
                self.contents = self.quill.root.innerHTML;
            });

            self.fnInfo();
        }
    });

    app.mount('#app');
</script>
