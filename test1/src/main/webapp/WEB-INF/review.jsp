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

  .card-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center

  }

  .card {
    display: flex;
    justify-content: space-between;
    background-color: #fff;
    width: 70%;
    border-radius: 15px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    padding: 20px;
    transition: all 0.3s ease;  
  }

  .card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.2);
  }

  .card-header {
    font-size: 1.4em;
    font-weight: 600;
    color: #333;
    margin-bottom: 10px;
  }

  .card-theme {
    background-color: #e3f2fd;
    color: #1976d2;
    display: inline-block;
    padding: 4px 10px;
    border-radius: 10px;
    font-size: 0.85em;
    margin-bottom: 15px;
  }

  .card-content p {
    margin: 5px 0;
    color: #555;
  }

  .card-content strong {
    color: #333;
  }

  .card-footer {
    margin-top: 15px;
    text-align: right;
  }

  .card-footer span {
    font-size: 0.9em;
    color: #999;
  }
  .card-btn{
    display: flex;
    flex-direction: column;
    justify-content: space-between
  }
  .card-btn button {
  background-color: #1976d2;
  color: white;
  border: none;
  border-radius: 10px;
  padding: 10px 16px;
  font-size: 0.95em;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.card-btn button:hover {
  background-color: #045abd;
  box-shadow: 0 4px 10px rgba(0,0,0,0.2);
  transform: translateY(-2px);
}

.card-btn button:active {
  transform: translateY(0);
  box-shadow: 0 2px 5px rgba(0s,0,0,0.1);
}
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="card-container" v-for="item in list">
            <div class="card">
                <div class="item-box">
                    <div class="card-header">{{item.packname}}</div>
                    <div class="card-theme"># {{item.themNum}}</div>
                    <div class="card-content">
                    <p><strong>예약번호:</strong> {{item.resNum}}</p>
                    <p><strong>설명:</strong> {{item.descript}}</p>
                    <p><strong>가격:</strong> {{Number(item.price).toLocaleString()}}원</p>
                    <p><strong>예약자 ID:</strong> {{item.userId}}</p>
                    </div>
                    
                </div>
                <div class="card-btn">
                  <button @click="fnadd(item.resNum)">후기작성하기</button>
                  <div class="card-footer">
                    <span>{{item.rdatetime}}</span>
                  </div>
                </div>
            </div>
        </div>
         
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                sessionId:"${sessionId}",
                list:{}
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {
                    userId:self.sessionId,
                };
                $.ajax({
                    url: "/reservation-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                    }
                });
            },
            fnadd(resNum){
                pageChange("review-add.do",{resNum : resNum});
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