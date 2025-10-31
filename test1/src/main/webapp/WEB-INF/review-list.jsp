<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>게시글 목록</title>
  <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: #f6f7fb;
      margin: 0;
      padding: 40px 20px;
    }

    h2 {
      text-align: center;
      color: #333;
      margin-bottom: 30px;
      font-size: 1.8em;
    }

    /* 카드들을 감싸는 컨테이너 */
    .card-container {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 25px;
      max-width: 1200px;
      margin: 0 auto;
    }

    /* 카드 하나 */
    .card {
      background-color: #fff;
      border-radius: 15px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
      overflow: hidden;
      transition: all 0.3s ease;
      cursor: pointer;
      display: flex;
      flex-direction: column;
    }

    .card:hover {
      transform: translateY(-6px);
      box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    }

    /* 이미지 영역 */
    .card-img {
      width: 100%;
      height: 180px;
      object-fit: cover;
      background-color: #ddd;
      border-bottom: 1px solid #eee;
    }

    /* 본문 영역 */
    .card-body {
      padding: 18px 20px;
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
    }

    .card-theme {
      display: inline-block;
      background-color: #e3f2fd;
      color: #1976d2;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 0.8em;
      font-weight: 500;
      margin-bottom: 10px;
      align-self: flex-start;
    }

    .card-title {
      font-size: 1.2em;
      font-weight: 600;
      color: #222;
      margin-bottom: 10px;
      line-height: 1.4em;
    }

    .card-desc {
      font-size: 0.95em;
      color: #555;
      line-height: 1.5em;
      flex: 1;
      margin-bottom: 10px;
    }

    .card-info {
      font-size: 0.9em;
      color: #777;
      margin-bottom: 12px;
    }

    /* 버튼 */
    .card-footer {
      text-align: right;
    }

    .card-footer button {
      background-color: #1976d2;
      color: white;
      border: none;
      border-radius: 8px;
      padding: 8px 14px;
      font-size: 0.9em;
      cursor: pointer;
      transition: 0.25s;
    }

    .card-footer button:hover {
      background-color: #0d47a1;
    }

  </style>
</head>
<body>
  <div id="app">
    <h2>📋 게시글 목록</h2>

    <div class="card-container">
      <div class="card" v-for="item in list" :key="item.packname" @click="fnDetail(item.resNum)">
        <div class="card-body">
          <div class="card-theme">{{ item.themNum }}</div>
          <div class="card-title">{{ item.packname }}</div>
          <div class="card-desc">{{ item.descript }}</div>
          <div class="card-info">
            💰 {{ Number(item.price).toLocaleString() }}원 <br>
            👤 {{ item.userId }}
          </div>

          <div class="card-footer">
            <button @click.stop="fnDetail(item.resNum)">상세보기</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>

<script>
  const app = Vue.createApp({
    data() {
      return {
        sessionId: "${sessionId}",
        list: []
      };
    },
    methods: {
      fnList() {
        let self = this;
        $.ajax({
          url: "/review-list.dox",
          dataType: "json",
          type: "POST",
          data: {},
          success: function (data) {
            self.list = data.list;
            console.log(data);
            
          },
          error() {
            alert("게시글 목록을 불러오지 못했습니다.");
          }
        });
      },
      fnDetail(item) {
        // 상세 페이지 이동 (URL은 프로젝트에 맞게 수정)
        pageChange("review-view.do",{resNum:item});
      }
    },
    mounted() {
      this.fnList();
    }
  });

  app.mount('#app');
</script>
</html>
