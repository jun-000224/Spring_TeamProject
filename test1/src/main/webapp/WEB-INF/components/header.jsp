<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String userId = (String) session.getAttribute("sessionId");
    String userStatus = (String) session.getAttribute("sessionStatus");
    String userNickname = (String) session.getAttribute("sessionNickname");
    String userName = (String) session.getAttribute("sessionName");
    Integer userPoint = (Integer) session.getAttribute("sessionPoint");
%>

<div id="app-header">
    <header>
        <div class="logo">
            <a href="/main-list.do">
                <img src="/img/logo/projectLogo.jpg" alt="">
            </a>
        </div>
        <nav>
            <ul>
                <li class="main-menu"><a href="/reservation.do">여행하기</a></li>
                <li class="main-menu"><a href="/board-list.do">커뮤니티</a></li>
                <li class="main-menu"><a href="/review-list.do">후기 게시판</a></li>
                <li class="main-menu"><a href="/main-Notice.do">공지사항</a></li>
                <% if("A".equals(userStatus)) { %>
                    <li class="main-menu">
                        <a href="/admin-page.do">관리자 페이지</a>
                    </li>
                <% } %>
            </ul>
        </nav>

        <div style="display: flex; align-items: center; gap: 15px;">
            <% if(userId == null) { %>
                <div class="login-btn">
                    <button onclick="goToLogin()">로그인/회원가입</button>
                </div>
            <% } else { %>
                <div class="user-info" style="position: relative;">
                    <span onclick="toggleLogoutMenu()" class="nickname">
                        {{ gradeLabel }}<%= userNickname %>님<br>환영합니다!
                    </span>

                    <ul id="logoutMenu" class="logout-dropdown" style="display: none;">
                        <li onclick="goToMyPage()">마이페이지</li>
                        <li>내 포인트 : <%= userPoint %> P</li>
                        <li onclick="logout()">로그아웃</li>
                    </ul>
                </div>
            <% } %>
        </div>
    </header>
</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

<script>
    // JSP 스크립틀릿으로 넘어온 데이터 JS에서 사용
    window.sessionData = {
        id: "<%= userId %>",
        status: "<%= userStatus %>",
        nickname: "<%= userNickname %>",
        name: "<%= userName %>",
        point: "<%= userPoint != null ? userPoint : 0 %>"
    };
    
    if(window.sessionData.id) {
        window.sessionStorage.setItem("id", window.sessionData.id);
    }

    let showLogoutMenu = false;
    function toggleLogoutMenu() {
        showLogoutMenu = !showLogoutMenu;
        document.getElementById('logoutMenu').style.display = showLogoutMenu ? 'block' : 'none';
    }
</script>

<script src="/js/header.js"></script>
<script src="/js/kakao.js"></script>
