<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>계정 찾기 | READY</title>

  <script src="https://code.jquery.com/jquery-3.7.1.js"
          integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
          crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

  <!-- 기존 공통 CSS 유지 -->
  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">

  <style>
    :root{
      --bg:#f6f7f9; --card:#fff; --text:#111827; --muted:#6b7280;
      --primary:#2563eb; --primary-hover:#1e40af; --border:#e5e7eb;
      --shadow:0 12px 28px rgba(0,0,0,.06);
      --ring: rgba(37,99,235,.12);
      --success:#16a34a; --warning:#f59e0b;
    }
    *,*::before,*::after{ box-sizing:border-box }

    /* 다른 화면에서 쓰는 기본 테이블 스타일 유지 */
    table, tr, td, th{
      border:1px solid black; border-collapse:collapse;
      padding:5px 10px; text-align:center;
    }
    th{ background-color:beige }
    tr:nth-child(even){ background-color:azure }

    body{
      margin:0;
      font-family:ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic";
      color:var(--text);
      background:
        radial-gradient(1200px 600px at 80% -10%, #e8f0ff 0%, transparent 60%),
        radial-gradient(900px 500px at -10% 110%, #e9fdf5 0%, transparent 60%),
        var(--bg);
    }

    /* 화면 레이아웃 */
    .field{
      margin: clamp(48px, 10vh, 120px) auto 80px;
      max-width: 980px;
      padding: 0 16px;
    }

    .page-head{
      text-align:center; margin-bottom: 18px;
    }
    .title{
      margin:0; font-size: clamp(22px, 3.2vw, 28px); font-weight: 800;
    }
    .subtitle{
      margin: 8px 0 0 0; color: var(--muted); font-size: 14px;
    }

    .card{
      background:var(--card);
      border:1px solid var(--border);
      border-radius: 18px;
      box-shadow: var(--shadow);
      padding: 22px;
    }

    /* 옵션 타일 그리드 */
    .option-grid{
      display:grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 16px;
    }
    @media (max-width: 720px){
      .option-grid{ grid-template-columns: 1fr; }
    }

    .tile{
      display:flex; flex-direction:column; gap:14px;
      border:1px solid var(--border);
      border-radius: 14px;
      padding: 18px;
      transition: box-shadow .2s, border-color .2s, transform .05s;
      background:#fff;
    }
    .tile:focus-within,
    .tile:hover{
      border-color: var(--primary);
      box-shadow: 0 0 0 4px var(--ring);
    }

    .tile-head{
      display:flex; align-items:center; gap:12px;
    }
    .badge{
      width:44px; height:44px; border-radius:12px;
      display:grid; place-items:center; color:#fff; font-weight:800;
      box-shadow: 0 6px 16px rgba(0,0,0,.10);
      flex:0 0 auto;
    }
    .badge.id{ background: linear-gradient(135deg, #34d399, #10b981); }      /* 아이디 */
    .badge.pw{ background: linear-gradient(135deg, #60a5fa, #2563eb); }      /* 비밀번호 */

    .tile-title{ margin:0; font-size:18px; font-weight:800; }
    .tile-desc{ margin:0; color:var(--muted); font-size:14px; }

    .tile-actions{
      display:flex; gap:10px; flex-wrap:wrap; margin-top:auto;
    }
    .btn{
      display:inline-flex; justify-content:center; align-items:center; gap:8px;
      border:0; border-radius:12px; cursor:pointer;
      padding: 12px 16px;
      font-weight:700; font-size:15px;
      transition: background .15s, transform .02s, opacity .2s, border-color .2s;
    }
    .btn-primary{ background: var(--primary); color:#fff; }
    .btn-primary:hover{ background: var(--primary-hover); }
    .btn-outline{ background:#fff; color:var(--text); border:1px solid var(--border); }
    .btn-outline:hover{ border-color: var(--primary); }
    .btn:active{ transform: translateY(1px); }

    /* 접근성: 카드 전체를 클릭영역처럼 */
    .tile-link{
      display:block; text-decoration:none; color:inherit;
    }
    .tile-link:focus{ outline:none; }

    /* 하단 안내 */
    .help{
      margin-top: 16px; text-align:center; color: var(--muted); font-size: 13px;
    }
  </style>
</head>
<body>
<div id="app">
  <%@ include file="../components/header.jsp" %>

  <div class="field">
    <div class="page-head">
      <h1 class="title">계정 찾기</h1>
      <p class="subtitle">아이디를 잊으셨거나 비밀번호 재설정이 필요하면 아래에서 진행해 주세요.</p>
    </div>

    <div class="card">
      <div class="option-grid">
        <!-- 아이디 찾기 -->
        <a href="javascript:void(0)" class="tile-link" @click.prevent="fnFindId">
          <div class="tile" role="button" aria-label="아이디 찾기">
            <div class="tile-head">
              <div class="badge id">ID</div>
              <div>
                <h3 class="tile-title">아이디 찾기</h3>
                <p class="tile-desc">본인확인으로 아이디를 찾습니다.</p>
              </div>
            </div>
            <div class="tile-actions">
              <button type="button" class="btn btn-primary" @click.stop="fnFindId">아이디 찾기</button>
            </div>
          </div>
        </a>

        <!-- 비밀번호 재설정 -->
        <a href="javascript:void(0)" class="tile-link" @click.prevent="fnFindPwd">
          <div class="tile" role="button" aria-label="비밀번호 재설정">
            <div class="tile-head">
              <div class="badge pw">PW</div>
              <div>
                <h3 class="tile-title">비밀번호 재설정</h3>
                <p class="tile-desc">본인확인 후 재설정하기.</p>
              </div>
            </div>
            <div class="tile-actions">
              <button type="button" class="btn btn-primary" @click.stop="fnFindPwd">재설정 시작</button>
            </div>
          </div>
        </a>
      </div>

      <p class="help">문제가 지속되면 고객센터로 문의해 주세요.</p>
    </div>
  </div>

  <%@ include file="../components/footer.jsp" %>
</div>

<script>
  const app = Vue.createApp({
    data(){ return {} },
    methods:{
      fnFindId(){ location.href="/member/findId.do"; },
      fnFindPwd(){ location.href="/member/findPwd.do"; }
    }
  });
  app.mount('#app');
</script>
</body>
</html>
