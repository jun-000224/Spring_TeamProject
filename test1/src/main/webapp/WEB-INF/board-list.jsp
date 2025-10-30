<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
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
        .num{
            margin-left: 5px;
            text-decoration: none;
        }
        .active{
            color: black;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <select v-model="searchOption">
            <option value="all">::전체::</option>
            <option value="title">::제목::</option>
            <option value="id">::작성자::</option>
        </select>
       
        <input v-model="keyword">
        <button @click="fnList">검색</button>
        </div>

        <div>
            <select v-model="pageSize">
            <option value="5">::5개씩::</option>
            <option value="10">::10개씩::</option>
            <option value="20">::20개씩::</option>
        </select>
       


        
            <select v-model="type">
            <option value="">::전체::</option>
            <option value="N">::공지사항::</option>
            <option value="F">::자유게시판::</option>
            <option value="Q">::질문게시판::</option>
        </select>
       

        
            <select v-model="order">
            <option value="num">::번호순::</option>
            <option value="title">::제목순::</option>
            <option value="cnt">::조회수::</option>
        </select>
        </div>
        
        
        <table>
                <tr>
                    <th>번호</th>
                    <th>작성자</th>
                    <th>제목</th>
                    <th>내용</th>
                    <th>추천수</th>
                    <th>조회수</th>
                    <th>삭제</th>
                   
                </tr>

                <tr v-for="item in list">
                    <td>{{item.boardNo}}</td>
                    <td>{{item.userId}}</td>
                    <td>
                    <a href="javascript:;" @click="fnView(item.boardNo)">{{item.title}}</a>

                    </td>
                    <td>{{item.contents}}</td>
                    <td> {{item.fav}}</td>
                    <td>{{item.cnt}}</td>
                    
                    <td><button @click="fnRemove(item.boardNo)">삭제</button></td>
                </tr>
                
                    
                
         </table>
         <div>
            <a v-if="page !=1" @click="fnMove(-1)" href="javascript:;">◀</a>
            <a href="javascript:;" v-for="num in index" class="num" @click="fnPage(num)">
                <span :class = "{active: page == num}">{{num}}</span>
               

            </a>
            <a v-if="page!=index" @click="fnMove(1)" href="javascript:;">▶</a>
         </div>
         <div>
                    <a href="board-add.do"><button>글쓰기</button></a>
                </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                list : [],
                searchOption : "all",
                pageSize : 5,
                type : "",
                order : "num",
                keyword : "",

                page : 1,
                index : 0,
                num : ""


            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {

                    type : self.type,
                    order : self.order,
                    keyword : self.keyword,
                    searchOption : self.searchOption,
                    pageSize : self.pageSize,
                    page : (self.page-1) * self.pageSize
                };
                $.ajax({
                    url: "board-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.index = Math.ceil(data.cnt / self.pageSize); 
                    }
                });
            },
            fnView : function(boardNo){
                pageChange("board-view.do", {boardNo : boardNo}); 
            },

            fnRemove: function (boardNo) {
                let self = this;
                let param = {
                    boardNo : boardNo
                };
                $.ajax({
                    url: "/board-delete.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                       alert("삭제되었습니다");
                       self.fnList();
                    }
                });
            },
            fnPage : function(num){
                let self = this;
                self.page = num;
                self.fnList();
            },
            fnMove : function(num){
                let self = this;
                self.page +=num;
                self.fnList();
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>