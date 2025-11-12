<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>게시글 목록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
      rel="stylesheet"
    />
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="/css/main-style.css" />
    <link rel="stylesheet" href="/css/common-style.css" />
    <link rel="stylesheet" href="/css/header-style.css" />
    <link rel="stylesheet" href="/css/main-images.css" />

    <style>
      body {
        font-family: "Noto Sans KR", sans-serif;
        background-color: #f6f7fb;
        margin: 0;
      }

      h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
        font-size: 1.8em;
      }

      /* ===============================
   ✅ 카드 레이아웃
=============================== */
      .card-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 25px;
        max-width: 1200px;
        margin: 0 auto;
      }

      /* 카드 기본 */
      .card {
        position: relative;
        height: 320px;
        perspective: 1000px;
        border-radius: 15px;
      }

      /* 카드 내부(회전용) */
      .card-inner {
        position: relative;
        width: 100%;
        height: 100%;
        transition: transform 0.8s;
        transform-style: preserve-3d;
      }

      .card:hover .card-inner {
        transform: rotateY(180deg);
      }

      /* ===============================
   ✅ 카드 앞면 / 뒷면
=============================== */
      .card-front,
      .card-back {
        position: absolute;
        width: 100%;
        height: 100%;
        border-radius: 15px;
        overflow: hidden;
        backface-visibility: hidden;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
      }

      /* 앞면 - 이미지 */
      .card-front img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        background-color: #ddd;
      }

      /* 뒷면 */
      .card-back {
        background-color: #fff;
        transform: rotateY(180deg);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }

      /* ===============================
   ✅ 카드 내부 구성
=============================== */
      .card-body {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        height: 100%;
        padding: 18px 20px;
      }

      /* 상단: 테마 + 좋아요 */
      .card-box {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
      }

      /* 테마 태그 */
      .card-theme {
        display: inline-block;
        background-color: #e3f2fd;
        color: #1976d2;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.8em;
        font-weight: 500;
        margin: 0 6px 6px 0;
      }

      /* 좋아요 / 조회수 아이콘 */
      .material-symbols-outlined {
        font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 48;
        color: #777;
        font-size: 24px;
        cursor: pointer;
        transition: all 0.2s ease;
      }

      .material-symbols-outlined.liked {
        font-variation-settings: "FILL" 1;
        color: #e53935;
      }

      /* 조회수 영역 */
      .card-cnt {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 0.85em;
        color: #666;
      }

      /* 제목 / 설명 / 정보 */
      .card-title {
        font-size: 1.2em;
        font-weight: 600;
        color: #222;
        margin-bottom: 6px;
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

      /* ===============================
   ✅ 버튼
=============================== */
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
        transition: background-color 0.25s;
      }

      .card-footer button:hover {
        background-color: #0d47a1;
      }
      /* ===============================
   ✅ 페이징 디자인
=============================== */
      .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 40px 0px;
        gap: 8px;
        font-family: "Noto Sans KR", sans-serif;
      }

      .pagination a {
        text-decoration: none;
      }

      .pagination span {
        display: inline-block;
        min-width: 32px;
        height: 32px;
        line-height: 32px;
        border-radius: 6px;
        text-align: center;
        font-size: 0.95em;
        color: #444;
        cursor: pointer;
        transition: all 0.25s ease;
        background-color: #fff;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
      }

      .pagination span:hover {
        background-color: #1976d2;
        color: #fff;
      }

      /* 현재 선택된 페이지 */
      .pagination span.active {
        background-color: #1976d2;
        color: #fff;
        font-weight: bold;
        box-shadow: 0 3px 8px rgba(25, 118, 210, 0.3);
      }

      /* 화살표 스타일 */
      .pagination span:first-child,
      .pagination span:last-child {
        font-weight: bold;
        font-size: 1.1em;
        /* color: #1976d2; */
      }
      /* ===============================
   ✅ 셀렉트 박스 (태그 필터)
=============================== */
      select {
        display: block;
        padding: 10px 16px;
        width: 180px;
        font-size: 0.95em;
        color: #333;
        border: 1.5px solid #ccc;
        border-radius: 8px;
        background-color: #fff;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg fill='%23666' height='24' width='24' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 10px center;
        background-size: 16px;
        transition: all 0.25s ease;
        cursor: pointer;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
      }

      select:hover {
        border-color: #1976d2;
      }

      select:focus {
        outline: none;
        border-color: #1976d2;
        box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.2);
      }
      .filter-box {
        display: flex;
        align-items: center;
        text-align: center;
      }

      .filter-box label {
        font-size: 0.95em;
        color: #555;
        margin-right: 10px;
      }

      .page-title {
        display: flex;
        align-items: center;
        justify-content: center; /* 중앙 정렬 기준 */
        position: relative; /* 뒤로가기 버튼 절대 위치 가능하게 */
        max-width: 1200px;
        margin: 0 auto 28px;
        text-align: center;
      }
      /* 뒤로가기 버튼 */
      .back-btn {
        position: absolute;
        left: 0; /* 맨 왼쪽으로 이동 */
      }

      .back {
        background: none;
        border: none;
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 16px;
        cursor: pointer;
        transition: 0.3s;
      }

      .material-symbols-outlined {
        font-size: 32px;
        vertical-align: middle;
      }
      .middle {
        display: flex;
        align-items: center;
        justify-content: space-between;
        max-width: 1200px;
        margin: 0 auto 30px;
      }
      .middle button {
        background-color: #1976d2;
        color: white;
        border: none;
        border-radius: 8px;
        padding: 8px 14px;
        font-size: 0.9em;
        cursor: pointer;
        transition: background-color 0.25s;
      }
    </style>
  </head>
  <body>
    <%@ include file="components/header.jsp" %>
    <div id="app">
      <div class="page-title">
        <div class="back-btn">
          <button class="back" @click="fnbck">
            <span class="material-symbols-outlined">arrow_back</span>
            뒤로가기
          </button>
        </div>

        <h2>📋 게시글 목록</h2>
      </div>

      <div class="middle">
        <div class="filter-box">
          <label for="tag">태그 필터</label>
          <select id="tag" v-model="tag" @change="fnList">
            <option value="">전체</option>
            <option value="가족">가족</option>
            <option value="친구">친구</option>
            <option value="연인">연인</option>
            <option value="호화스러운">호화스러운</option>
            <option value="가성비">가성비</option>
            <option value="힐링">힐링</option>
            <option value="이색적인">이색적인</option>
            <option value="모험">모험</option>
            <option value="조용한">조용한</option>
          </select>
        </div>
        <button @click="fnadd">글쓰러가기</button>
      </div>

      <div class="card-container">
        <div class="card" v-for="item in list" :key="item.packname" @click="fnDetail(item.resNum)">
          <div class="card-inner">
            <!-- 앞면 -->
            <div class="card-front">
              <img class="card-img" :src="thumbnailMap[item.resNum]?.firstimage || getRandomImage()" :alt="item.packname" />
            </div>

            <!-- 뒷면 -->
            <div class="card-back">
              <div class="card-body">
                <div class="card-box">
                  <div>
                    <div class="card-theme" v-for="tag in item.themNum.split(',')" :key="tag">
                      {{ tag }}
                    </div>
                  </div>
                  <div style="display: flex">
                    <span class="material-symbols-outlined" :class="{ liked: item.liked }" @click.stop="toggleLike(item)"> favorite </span>
                    <div>{{ item.fav }}</div>
                  </div>
                </div>

                <div class="card-box">
                  <div class="card-title">{{ item.packname }}</div>
                  <div class="card-cnt">
                    <span class="material-symbols-outlined">visibility</span>
                    <div>{{ item.cnt }}</div>
                  </div>
                </div>

                <div class="card-desc">{{ item.descript }}</div>
                <div class="card-info">
                  💰 {{ Number(item.price).toLocaleString() }}원 <br />
                  👤 {{ item.userId }}
                </div>

                <div class="card-footer">
                  <button style="margin-right: 10px" @click.stop="fnActive(item.resNum)" v-if="userId !=null & userId !='' & status == 'S'">
                    활용하기
                  </button>
                  <button @click.stop="fnDetail(item.resNum)">상세보기</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <!-- 이전 그룹 -->
        <a href="javascript:;" v-if="page > 1" @click="fnMove(-1)">
          <span v-if="page > 1">◀</span>
        </a>

        <!-- 페이지 번호 -->
        <a href="javascript:;" v-for="num in pageGroupEnd - pageGroupStart + 1" :key="num" @click="fnchange(pageGroupStart + num - 1)">
          <span :class="{ active: page == (pageGroupStart + num - 1) }">{{ pageGroupStart + num - 1 }}</span>
        </a>

        <!-- 다음 그룹 -->
        <a href="javascript:;" v-if="page < totalPages" @click="fnMove(1)">
          <span>▶</span>
        </a>
      </div>
    </div>
    <%@ include file="components/footer.jsp" %>
  </body>

  <script>
    const app = Vue.createApp({
      data() {
        return {
          userId: "${sessionId}",
          list: [],
          liked: false,
          thumbnailMap: {},
          page: 1,
          pageSize: 6,
          pageGroupSize: 10,
          totalPages: 0,
          pageGroupStart: 1,
          pageGroupEnd: 10,
          tag: "",
          randomImages: [
            "/img/defaultImg01.jpg",
            "/img/defaultImg02.jpg",
            "/img/defaultImg03.jpg",
            "/img/defaultImg04.jpg",
            "/img/defaultImg05.jpg",
            "/img/defaultImg06.jpg",
          ],
          status: window.sessionData.status,
        };
      },
      methods: {
        fnList() {
          let self = this;
          $.ajax({
            url: "/review-list.dox",
            dataType: "json",
            type: "POST",
            data: {
              userId: self.userId,
              tag: self.tag,
              pageSize: self.pageSize,
              page: (self.page - 1) * self.pageSize,
            },
            success: function (data) {
              self.list = data.list;
              self.totalPages = Math.ceil(data.cnt / self.pageSize);
              let group = Math.floor((self.page - 1) / self.pageGroupSize);
              //console.log(self.page, self.pageGroupSize);

              self.pageGroupStart = group * self.pageGroupSize + 1;
              self.pageGroupEnd = Math.min(self.pageGroupStart + self.pageGroupSize - 1, self.totalPages);
            },
          });
        },
        fnThumnail() {
          let self = this;
          $.ajax({
            url: "/thumbnail.dox",
            dataType: "json",
            type: "GET",
            data: {},
            success: function (data) {
              //console.log(data);
              self.thumbnailMap = data.list;
            },
          });
        },
        fnDetail(item) {
          // 상세 페이지 이동 (URL은 프로젝트에 맞게 수정)
          pageChange("review-view.do", { resNum: item });
        },
        toggleLike(item) {
          let self = this;

          param = {
            userId: self.userId,
            boardNo: item.boardNo,
          };
          $.ajax({
            url: "review-favorite.dox",
            dataType: "json",
            type: "POST",
            data: param,
            success: function (data) {
              item.liked = data.liked;
              self.fnList();
            },
          });
          //console.log(item);
        },
        fnchange(num) {
          let self = this;
          self.page = num;
          self.fnList();
        },
        fnMove(num) {
          let self = this;
          self.page += num;
          if (self.page < 1) self.page = 1;
          if (self.page > self.totalPages) self.page = self.totalPages;
          self.fnList();
        },
        fnbck() {
          history.back();
        },
        getRandomImage() {
          if (!this.shuffled) {
            this.shuffled = [...this.randomImages].sort(() => Math.random() - 0.5);
          }

          // 하나 꺼내기 (없으면 다시 섞기)
          if (this.shuffled.length === 0) {
            this.shuffled = [...this.randomImages].sort(() => Math.random() - 0.5);
          }

          return this.shuffled.pop();
        },
        fnadd() {
          let self = this;
          pageChange("/myReservation.do", {});
        },
        fnActive(resNum) {
          let self = this;
          pageChange("/reservation.do", { resNum: resNum });
        },
      },
      mounted() {
        let self = this;

        self.fnList();
        self.fnThumnail();
        window.addEventListener("popstate", () => {
          self.fnList();
          self.fnThumnail();
        });
        window.addEventListener("pageshow", (event) => {
          if (event.persisted) {
            self.fnList();
            self.fnThumnail();
          }
        });
      },
    });

    app.mount("#app");
  </script>
</html>
