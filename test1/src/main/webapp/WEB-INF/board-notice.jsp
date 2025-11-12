<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>커뮤니티 | READY</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <link rel="stylesheet" href="/css/main-style.css" />
    <link rel="stylesheet" href="/css/common-style.css" />
    <link rel="stylesheet" href="/css/header-style.css" />
    <link rel="stylesheet" href="/css/main-images.css" />

    <style>
      /* ====== 고급 · 미니멀 공식 서비스 스타일 ====== */
      :root {
        --bg: #f7f8fa;
        --card: #ffffff;
        --text: #1f2937;
        --muted: #6b7280;
        --primary: #2563eb;
        --primary-hover: #1e40af;
        --border: #e5e7eb;
        --soft-border: #eceff3;
        --shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
        --ring: rgba(37, 99, 235, 0.15);
      }

      * {
        box-sizing: border-box;
      }
      body {
        background: var(--bg);
        font-family: "Noto Sans KR", ui-sans-serif, system-ui, -apple-system;
        color: var(--text);
        margin: 0;
      }

      /* ====== 검색·필터 영역 ====== */
      .board-filter {
        width: 82.5%;
        margin: 32px auto 20px auto;
        padding: 22px;
        background: var(--card);
        border: 1px solid var(--soft-border);
        border-radius: 14px;
        box-shadow: var(--shadow);
        display: flex;
        flex-direction: column;
        gap: 14px;
      }

      .filter-row {
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
      }

      .board-filter select,
      .board-filter input,
      .board-filter button {
        font-size: 14px;
        padding: 10px 14px;
        border-radius: 10px;
        border: 1px solid var(--border);
        background: #fff;
        transition: all 0.15s ease;
      }

      .board-filter select:focus,
      .board-filter input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px var(--ring);
        outline: none;
      }

      .board-filter input {
        min-width: 260px;
        flex: 1;
        border-radius: 12px;
        background: #fafafa;
      }

      .board-filter button {
        background: var(--primary);
        border: none;
        color: #fff;
        font-weight: 600;
      }
      .board-filter button:hover {
        background: var(--primary-hover);
      }

      /* ====== 테이블 ====== */
      table {
        width: 82.5%;
        margin: 0 auto 12px;
        border-collapse: collapse;
        background: var(--card);
        border-radius: 14px;
        overflow: hidden;
        box-shadow: var(--shadow);
      }

      thead th {
        padding: 14px 10px;
        background: #f1f5f9;
        color: #374151;
        border-bottom: 1px solid var(--border);
        font-weight: 700;
        font-size: 14px;
      }

      tbody td {
        padding: 14px;
        border-bottom: 1px solid var(--soft-border);
        font-size: 15px;
        color: var(--text);
      }
      tbody tr:hover {
        background: #f9fafb;
        cursor: pointer;
      }

      /* 열 폭 */
      .col-num {
        width: 88px;
        text-align: center;
        color: #334155;
      }
      .col-author {
        width: 160px;
        text-align: center;
      }
      .col-like {
        width: 110px;
        text-align: center;
        color: #0f766e;
        font-weight: 700;
      }
      .col-cnt {
        width: 110px;
        text-align: center;
        color: #475569;
      }
      .col-date {
        width: 150px;
        text-align: center;
        color: #64748b;
      }

      /* 제목 링크 */
      td a {
        text-decoration: none;
        color: var(--primary);
        font-weight: 600;
      }
      td a:hover {
        text-decoration: underline;
      }

      /* 타입 배지 (절제된 컬러) */
      .type-badge {
        display: inline-block;
        padding: 3px 8px;
        font-size: 11px;
        font-weight: 700;
        border-radius: 8px;
        margin-right: 6px;
        background: #e5e7eb;
        color: #374151;
        vertical-align: middle;
      }
      .type-N {
        background: #fef3c7;
        color: #92400e;
      } /* 공지 */
      .type-F {
        background: #e2e8f0;
        color: #475569;
      } /* 자유 */
      .type-Q {
        background: #dcfce7;
        color: #166534;
      } /* 질문 */
      .type-SQ {
        background: #f3e8ff;
        color: #6b21a8;
      } /* 문의 */

      /* 댓글 수 Pill */
      .comment-pill {
        background: #fee2e2;
        padding: 2px 8px;
        border-radius: 999px;
        font-size: 11px;
        color: #a30000;
        margin-left: 6px;
        vertical-align: middle;
        font-weight: 700;
      }

      /* ====== 페이지네이션 ====== */
      .pagination {
        width: 82.5%;
        margin: 16px auto 36px;
        display: flex;
        justify-content: center;
        gap: 6px;
      }

      .page-btn,
      .page-num {
        min-width: 36px;
        height: 36px;
        border-radius: 10px;
        background: #fff;
        border: 1px solid var(--border);
        color: #1f2937;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.15s;
        text-decoration: none;
      }

      .page-num.active {
        background: var(--primary);
        border-color: var(--primary);
        color: #fff;
      }
      .page-btn:hover,
      .page-num:hover {
        border-color: var(--primary);
        color: var(--primary);
      }

      /* ====== 글쓰기 버튼 ====== */
      .write-wrap {
        width: 82.5%;
        margin: 0 auto 50px;
        display: flex;
        justify-content: flex-end;
      }

      .write-btn {
        background: var(--primary);
        color: #fff;
        border: none;
        padding: 12px 18px;
        font-size: 15px;
        border-radius: 12px;
        font-weight: 700;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.14);
        transition: background 0.15s;
      }
      .write-btn:hover {
        background: var(--primary-hover);
      }

      /* ====== 모바일 대응 ====== */
      @media (max-width: 980px) {
        .col-author {
          display: none;
        }
        .col-like {
          width: 90px;
        }
        .col-cnt {
          width: 90px;
        }
        .col-date {
          width: 130px;
        }
      }
      @media (max-width: 760px) {
        .board-filter {
          width: 92%;
        }
        table {
          width: 92%;
        }
        .pagination {
          width: 92%;
        }
        .write-wrap {
          width: 92%;
          justify-content: center;
        }
      }
    </style>
  </head>

  <body>
    <div id="app">
      <!-- 헤더 -->
      <%@ include file="components/header.jsp" %>

      <!-- 검색/필터 -->
      <section class="board-filter">
        <div class="filter-row">
          <select v-model="searchOption">
            <option value="all">전체</option>
            <option value="title">제목</option>
            <option value="id">작성자</option>
          </select>

          <input v-model="keyword" placeholder="검색어를 입력하세요" @keyup.enter="fnList" />
          <button @click="fnList">검색</button>
        </div>

        <div hidden>
            <div class="filter-row">
              <select v-model="pageSize" @change="fnList" title="페이지 크기">
                <option value="5">5개씩</option>
                <option value="10">10개씩</option>
                <option value="15">15개씩</option>
              </select>
              <select v-model="type" @change="fnList" title="분류">
                <option value="">전체 분류</option>
                <option value="N">공지사항</option>
                <option value="F">자유게시판</option>
                <option value="Q">질문게시판</option>
                <option value="SQ">문의게시판</option>
              </select>
              <select v-model="order" @change="fnList" title="정렬">
                <option value="num">번호순</option>
                <option value="title">제목순</option>
                <option value="cnt">조회수</option>
              </select>
            </div>
        </div>
      </section>

      <!-- 목록 테이블 -->
      <table>
        <thead>
          <tr>
            <th class="col-num">번호</th>
            <th class="col-author">작성자</th>
            <th>제목</th>
            <th class="col-like">추천</th>
            <th class="col-cnt">조회</th>
            <th class="col-date">작성일</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list" :key="item.boardNo" @click="fnView(item.boardNo)">
            <td class="col-num">{{ item.boardNo }}</td>
            <td class="col-author">{{ item.userId }}</td>
            <td>
              <span class="type-badge" :class="badgeClass(item.type)">{{ typeLabel(item.type) }}</span>
              <a href="javascript:;">{{ item.title }}</a>
              <span v-if="item.commentCnt && item.commentCnt != 0" class="comment-pill">+{{ item.commentCnt }}</span>
            </td>
            <td class="col-like">{{ item.fav }}</td>
            <td class="col-cnt">{{ item.cnt }}</td>
            <td class="col-date">{{ item.cdate }}</td>
          </tr>
        </tbody>
      </table>

      <!-- 페이지네이션 -->
      <div class="pagination">
        <a href="javascript:;" class="page-btn" v-if="page > 1" @click="fnMove(-1)">◀</a>

        <a
          href="javascript:;"
          class="page-num"
          v-for="num in (pageGroupEnd - pageGroupStart + 1)"
          :key="'p'+num"
          :class="{ active: page == (pageGroupStart + num - 1) }"
          @click="fnPage(pageGroupStart + num - 1)"
        >
          {{ pageGroupStart + num - 1 }}
        </a>

        <a href="javascript:;" class="page-btn" v-if="page < totalPages" @click="fnMove(1)">▶</a>
      </div>

      <!-- 글쓰기 버튼 -->
      <div class="write-wrap" v-if="sessionStatus==='A'">
        <a href="board-add.do" class="write-button-area button">
          <button class="write-btn" type="button">글쓰기</button>
        </a>
      </div>
    </div>

    <!-- 푸터 -->
    <%@ include file="components/footer.jsp" %>

    <script>
      const app = Vue.createApp({
        data() {
          return {
            list: [],
            searchOption: "all",
            type: "N",
            order: "num",
            keyword: "",
            sessionId: "${sessionId}",
            sessionStatus : "${sessionStatus}",
            page: 1,
            pageSize: 5,
            pageGroupSize: 10,
            totalPages: 0,
            pageGroupStart: 1,
            pageGroupEnd: 10,
            num: "",
          };
        },
        methods: {
          badgeClass(t) {
            if (t === "N ") return "type-N";
            if (t === "F ") return "type-F";
            if (t === "Q ") return "type-Q";
            if (t === "SQ ") return "type-SQ";
            return "";
          },
          typeLabel(t) {
            if (t === "N ") return "공지";
            if (t === "F ") return "자유";
            if (t === "Q ") return "질문";
            if (t === "SQ ") return "문의";
            return "일반";
          },
          fnList() {
            const self = this;
            const param = {
              userId: self.userId,
              type: self.type,
              order: self.order,
              keyword: self.keyword,
              searchOption: self.searchOption,
              pageSize: self.pageSize,
              page: (self.page - 1) * self.pageSize,
            };
            $.ajax({
              url: "board-list.dox",
              dataType: "json",
              type: "POST",
              data: param,
              success: function (data) {
                self.list = data.list || [];
                self.totalPages = Math.ceil((data.cnt || 0) / self.pageSize);

                const group = Math.floor((self.page - 1) / self.pageGroupSize);
                self.pageGroupStart = group * self.pageGroupSize + 1;
                self.pageGroupEnd = Math.min(self.pageGroupStart + self.pageGroupSize - 1, self.totalPages || 1);
                //console.log(data);
              },
            });
          },
          fnView(boardNo) {
            pageChange("board-view.do", { boardNo: boardNo });
          },
          fnPage(num) {
            this.page = num;
            this.fnList();
          },
          fnMove(delta) {
            this.page += delta;
            if (this.page < 1) this.page = 1;
            if (this.page > this.totalPages) this.page = this.totalPages;
            this.fnList();
          },
        },
        mounted() {
          if (this.sessionId == "") {
            alert("로그인 후 이용해 주세요");
            location.href = "/member/login.do";
            return;
          }
          this.fnList();
        },
      });

      app.mount("#app");
    </script>
  </body>
</html>
