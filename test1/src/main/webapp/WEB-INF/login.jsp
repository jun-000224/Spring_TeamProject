<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 | READY</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <style>
    :root{
      --bg: #f6f7f9;
      --card: #ffffff;
      --text: #111827;
      --muted: #6b7280;
      --primary: #2563eb;
      --primary-hover:#1e40af;
      --border:#e5e7eb;
      --success:#16a34a;
      --danger:#ef4444;
      --ring:#93c5fd;
      --shadow: 0 10px 25px rgba(0,0,0,.06);
    }

    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic", "Segoe UI Emoji";
      color:var(--text);
      background:
        radial-gradient(1200px 600px at 80% -10%, #e8f0ff 0%, transparent 60%),
        radial-gradient(900px 500px at -10% 110%, #e9fdf5 0%, transparent 60%),
        var(--bg);
    }

    .wrap{
      min-height:100%;
      display:grid;
      place-items:center;
      padding:24px;
    }

    .auth-card{
      width:100%;
      max-width: 420px;
      background: var(--card);
      border:1px solid var(--border);
      border-radius: 16px;
      box-shadow: var(--shadow);
      padding: 28px;
    }

    .brand{
      display:flex; align-items:center; gap:12px; margin-bottom: 12px;
    }
    .brand-badge{
      width:40px; height:40px; border-radius:12px;
      background: linear-gradient(135deg, #60a5fa, #34d399);
      display:grid; place-items:center; color:#fff; font-weight:700; letter-spacing:.5px;
      box-shadow: 0 6px 16px rgba(52, 211, 153, .35);
    }
    .brand h1{
      font-size: 20px; margin:0;
    }
    .sub{
      color:var(--muted); font-size:14px; margin: 0 0 20px 0;
    }

    .field{
      margin-bottom:14px;
    }
    .field label{
      display:block; font-weight:600; font-size: 14px; margin:0 0 8px 0;
    }
    .input{
      width:100%;
      appearance:none;
      background:#fff;
      border:1px solid var(--border);
      border-radius:12px;
      padding: 12px 14px;
      font-size:15px;
      outline: none;
      transition: border-color .2s, box-shadow .2s, background .2s;
    }
    .input::placeholder{ color:#9ca3af }
    .input:focus{
      border-color: var(--primary);
      box-shadow: 0 0 0 4px rgba(37,99,235,.12);
    }

    .action{
      margin-top: 8px;
    }
    .btn{
      width:100%;
      border:0; border-radius: 12px;
      padding: 12px 16px;
      font-size: 15px; font-weight: 700;
      background: var(--primary);
      color:#fff;
      cursor:pointer;
      transition: background .15s, transform .02s;
    }
    .btn:hover{ background: var(--primary-hover); }
    .btn:active{ transform: translateY(1px); }
    .btn[disabled]{
      opacity:.7; cursor:not-allowed;
    }

    .meta-row{
      display:flex; justify-content:space-between; align-items:center;
      margin-top: 10px; font-size: 13px; color: var(--muted);
    }
    .link{ color: var(--primary); text-decoration:none }
    .link:hover{ text-decoration:underline }

    .alert{
      display:none;
      margin: 8px 0 0 0;
      padding: 10px 12px;
      border:1px solid #fecaca;
      background:#fff1f2;
      color:#991b1b;
      border-radius:10px;
      font-size: 14px;
    }
    .alert.show{ display:block; }

    .footer{
      margin-top: 18px; font-size:12px; color: var(--muted); text-align:center;
    }

    /* 로딩 스피너 */
    .spinner{
      display:inline-block; width:18px; height:18px; vertical-align:-4px;
      border:2px solid rgba(255,255,255,.55);
      border-top-color:#fff; border-radius:50%;
      animation: spin .8s linear infinite;
      margin-right:8px;
    }
    @keyframes spin{ to{ transform: rotate(360deg)} }

    /* 작은 화면 여백 보정 */
    @media (max-width: 380px){
      .auth-card{ padding:20px }
    }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="auth-card">
      <div class="brand">
        <div class="brand-badge">R</div>
        <h1>READY 여행 플랫폼</h1>
      </div>
      <p class="sub">계정으로 로그인해 주세요.</p>

      <form id="loginForm" method="post" onsubmit="return false;">
        <div class="field">
          <label for="userId">아이디</label>
          <input class="input" type="text" id="userId" name="userId" autocomplete="username" placeholder="아이디를 입력하세요" />
        </div>
        <div class="field">
          <label for="pwd">비밀번호</label>
          <input class="input" type="password" id="pwd" name="pwd" autocomplete="current-password" placeholder="비밀번호를 입력하세요" />
        </div>

        <div id="alertBox" class="alert" aria-live="polite"></div>

        <div class="action">
          <button id="loginBtn" type="button" class="btn" onclick="fnLogin()">
            로그인
          </button>
        </div>

        <div class="meta-row">
          <label style="display:flex;align-items:center;gap:8px;">
            <input id="rememberMe" type="checkbox" style="accent-color: var(--primary); width:16px; height:16px;">
            <span>자동 로그인</span>
          </label>
          <div>
            <a class="link" href="#">아이디 찾기</a>
            <span aria-hidden="true"> · </span>
            <a class="link" href="#">비밀번호 찾기</a>
            <span aria-hidden="true"> · </span>
            <a class="link" href="#">회원가입</a>
          </div>
        </div>
      </form>

      <p class="footer">보안을 위해 공용 PC에서는 자동 로그인을 사용하지 마세요.</p>
    </div>
  </div>

  <script>
    // Enter 키로 제출
    document.addEventListener('keydown', function(e){
      if(e.key === 'Enter'){
        const target = e.target;
        if(target.closest('#loginForm')){
          fnLogin();
        }
      }
    });

    function showAlert(msg){
      const box = document.getElementById('alertBox');
      box.textContent = msg;
      box.classList.add('show');
    }
    function clearAlert(){
      const box = document.getElementById('alertBox');
      box.textContent = '';
      box.classList.remove('show');
    }

    function setLoading(loading){
      const btn = document.getElementById('loginBtn');
      if(loading){
        btn.setAttribute('disabled', 'disabled');
        btn.innerHTML = '<span class="spinner"></span>로그인 중...';
      }else{
        btn.removeAttribute('disabled');
        btn.textContent = '로그인';
      }
    }

    function fnLogin() {
      clearAlert();

      var userId = document.getElementById("userId").value.trim();
      var pwd = document.getElementById("pwd").value;

      // 간단한 유효성 검사
      if (!userId) {
        showAlert("아이디를 입력하세요.");
        document.getElementById("userId").focus();
        return;
      }
      if (!pwd) {
        showAlert("비밀번호를 입력하세요.");
        document.getElementById("pwd").focus();
        return;
      }

      setLoading(true);

      // AJAX 요청
      $.ajax({
        url: "login.dox",
        dataType: "json",
        type: "POST",
        data: {
          userId: userId,
          pwd: pwd,
          remember: $('#rememberMe').is(':checked')
        },
        success: function(data) {
          if (data && data.result === "success") {
            // 로그인 성공
            window.location.href = "main-list.do";
          } else {
            // 실패 메시지 노출
            showAlert((data && data.message) ? data.message : "아이디 또는 비밀번호를 확인해 주세요.");
          }
        },
        error: function(xhr, status, error) {
          showAlert("오류가 발생했습니다: " + (error || "네트워크 오류"));
        },
        complete: function(){
          setLoading(false);
        }
      });
    }
  </script>
</body>
</html>
