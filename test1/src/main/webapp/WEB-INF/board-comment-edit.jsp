<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        /* -------------------- 🎨 기본 레이아웃 및 폰트 -------------------- */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f7f6;
            padding-top: 50px; /* 테이블 상단 여백 */
        }

        /* -------------------- <table> 스타일 -------------------- */
        table {
            width: 500px; /* 게시글 테이블보다 작게 조정 */
            margin: 30px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            border-radius: 10px;
            overflow: hidden;
        }

        th {
            background-color: #0078FF;
            color: white;
            font-weight: 600;
            padding: 14px;
            font-size: 15px;
            width: 100px; /* 작성자/내용 헤더 너비 */
            text-align: center;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 16px;
            text-align: left; /* 내용 입력칸은 왼쪽 정렬 */
        }
        
        /* 테이블의 마지막 행 하단 border 제거 */
        tr:last-child td {
            border-bottom: none;
        }

        /* -------------------- 입력 필드 스타일 -------------------- */
        textarea {
            width: 100%;
            min-height: 150px; /* 댓글 수정창 높이 조정 */
            border: 1px solid #ccc;
            border-radius: 6px;
            padding: 10px;
            font-size: 14px;
            resize: vertical;
            font-family: 'Noto Sans KR', sans-serif;
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
        }

        textarea:focus {
            outline: none;
            border-color: #0078FF;
            box-shadow: 0 0 5px rgba(0, 120, 255, 0.3);
        }

        /* -------------------- 버튼 스타일 -------------------- */
        .button-container {
            text-align: center;
            margin: 20px auto 40px;
            width: 500px;
        }

        button {
            background-color: #0078FF;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 30px;
            font-size: 15px;
            cursor: pointer;
            transition: background-color 0.25s ease;
            margin-left: 1100px;
        }

        button:hover {
            background-color: #005FCC;
        }

        /* 취소/이전 버튼 스타일 */
        button.cancel-btn {
            background-color: #95a5a6;
        }

        button.cancel-btn:hover {
            background-color: #7f8c8d;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        
         <table>
                
                <tr>
                    <th>작성자</th>
                    <td>{{sessionId}}</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea v-model="contents" cols="20" rows="10"></textarea> </td>
                </tr>
                
            </table>
            <div>
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
                sessionId : "${sessionId}",
                contents : "",
                commentNo : "${commentNo}",
                
                userId : ""

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo: function () {
                    let self = this;
                    let param = {  
                        commentNo: self.commentNo,
                        
                    };
                 
                    $.ajax({
                        url: "/comment-view.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                console.log(data);
                                self.userId = data.info.userId
                                data.contents = data.info.contents
                                
                            } else {
                                alert("오류가 발생했습니다!");
                            }
                        }
                    });
                },

            fnUpdate: function (commentNo) {
                    let self = this;
                    let param = {
                        
                        contents: self.contents,
                        commentNo: self.commentNo,
                       
                    };
                    $.ajax({
                        url: "/board-comment-edit.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result == "success") {
                                alert("수정됨");
                                location.href="board-view.do"
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
            if (self.sessionId === "") {
                 alert("로그인 후 이용해 주세요.");
                 location.href = "/member/login.do";
                 return;
            }
            self.fnInfo();
            
          
        }
    });

    app.mount('#app');
</script>