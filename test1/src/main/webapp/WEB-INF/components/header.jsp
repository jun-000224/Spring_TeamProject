<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id = "app-header">
    <header>
        <div class="logo">
            <a href="/main-list.do">
                <!-- <img src="이미지.png" alt="Team Project"> -->
            </a>
        </div>
        <h1 class="logo">
            <a href="/main-list.do" >Team Project</a>
        </h1>
        <nav>
            <ul>
                <li class="main-menu"><a href="/reservation.do">여행하기</a></li>
                <li class="main-menu"><a href="/board-list.do">커뮤니티</a></li>
                <li class="main-menu"><a href="/review-list.do">후기 게시판</a></li>
                <li class="main-menu"><a href="/main-Notice.do">공지사항</a></li>
                <!-- 마이페이지 / 관리자 페이지  -->
                <!-- <li class="main-menu" v-if="status === 'U'">
                    <a href="/main-myPage.do">마이페이지</a>
                </li> -->
                <li class="main-menu" v-if="status === 'A'">
                    <a href="/admin-page.do">관리자 페이지</a>
                </li>
    
            </ul>
        </nav>
    
        <div style="display: flex; align-items: center; gap: 15px;">
            <!-- 로그인 전 -->
            <div class="login-btn" v-if="!isLoggedIn">
                <button onclick="goToLogin()">로그인/회원가입</button>
            </div>
    
            <!-- 로그인 후 -->
            <div class="user-info" v-else style="position: relative;">
                <span onclick="toggleLogoutMenu()" class="nickname">
                    {{ nickname }}님 {{ gradeLabel }}
                    <br>
                    환영합니다!
                </span>
                
                <ul id="logoutMenu" class="logout-dropdown" style="display: none;">
                    <li onclick="goToMyPage()">마이페이지</li>
                    <li>
                        <span onclick="myPoint()">
                            내 포인트 : ${sessionScope.sessionPoint} P
                        </span>
                    </li>
                    <li onclick="logout()">로그아웃</li>
                </ul>

                <!-- <ul v-if="showLogoutMenu" class="logout-dropdown">
                    <li @click="goToMyPage">마이페이지</li>
                    <li >내 포인트 : {{ point }}</li>
                    <li @click="logout">로그아웃</li>
                </ul> -->
            </div>
        </div>
    
        <!-- <script src="https://unpkg.com/vue@3"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> -->
        
    
    </header>
</div>


<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

<script>
    window.sessionData = {
        id: "${sessionId}",
        status: "${sessionStatus}",
        nickname: "${sessionNickname}",
        name: "${sessionName}",
        point: "${sessionPoint}"  // 이 부분에서 sessionPoint를 잘 넘기고 있는지 확인
    };
    
    let showLogoutMenu = false;  // 조건을 true/false로 변경

    function toggleLogoutMenu() {
        console.log(showLogoutMenu);
        // console.log(point);
        showLogoutMenu = !showLogoutMenu;
        const logoutMenu = document.getElementById('logoutMenu');
        if (showLogoutMenu) {
            logoutMenu.style.display = 'block';  // 메뉴 보이기
        } else {
            logoutMenu.style.display = 'none';  // 메뉴 숨기기
        }
    }

    

    
        // const headerApp = Vue.createApp({
        //     data() {
        //         // const initialShowMenu = window.sessionData.showLogoutMenu === 'true' 
        //         //                     ? true
        //         //                     : window.sessionData.showLogoutMenu === 'false'
        //         //                         ? false
        //         //                         : !!window.sessionData.showLogoutMenu;
                
        //         return {
        //             id : window.sessionData.id,
        //             nickname : window.sessionData.nickname,
        //             showLogoutMenu : initialShowMenu,
        //             status : window.sessionData.status,
        //             point : window.sessionData.point,
        //             showLogoutMenu: false,
        //         }
        //     },
            
        //     computed:{
        //         isLoggedIn() {
        //             return this.nickname !== "";
        //         },
        //         gradeLabel() {
        //             switch (this.status) {
        //                 case 'A': return '👑 ';
        //                 case 'S': return '✨ ';
        //                 case 'U': return '🙂 ';
        //                 default: return '❓ 미지정';
        //             }
        //         }
        //     },
            
        //     methods : {
                
        //     }
        // });

        // headerApp.mount('#app-header');    
</script>


<script src="/js/header.js"></script>
<script src="/js/kakao.js"></script>