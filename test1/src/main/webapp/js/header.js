const headerApp = Vue.createApp({
    data() {
        return {
            // JSP에서 주입받은 세션 정보
            id: "${sessionId}",
            status: "${sessionStatus}",
            nickname: "${sessionNickname}",
            name: "${sessionName}",
            point: "${sessionPoint}",
            
            // JS 내부에서만 관리하는 변수
            showLogoutMenu: false,
			
			code : ""
        };
    },
    computed: {
        // 로그인 여부
        isLoggedIn() {
            return this.nickname !== "" && this.nickname !== "null" && this.nickname !== null;
        },
        // 등급 라벨 표시
        gradeLabel() {
            switch (this.status) {
                case 'A': return '👑 관리자';
                case 'S': return '✨ 스페셜';
                case 'U': return '🙂 일반회원';
                default: return '❓ 미지정';
            }
        }
    },
    methods: {
        toggleLogoutMenu() {
            this.showLogoutMenu = !this.showLogoutMenu;
        },
        logout() {
            location.href = '/logout.do';
        }
    }
}).mount('#header');

// 전역 접근을 위해 window에 등록
window.headerApp = headerApp;

// ✅ 카카오 로그인 전역 함수
window.fnKakao = function (code) {
    $.ajax({
        url: "/kakao.dox",
        dataType: "json",
        type: "POST",
        data: { code: code },
        success: function (data) {
            console.log("카카오 로그인 결과:", data);

            // 로그인 성공 시 headerApp 데이터 갱신 (필요할 경우)
            if (data && data.nickname) {
                headerApp.nickname = data.nickname;
                headerApp.name = data.name || '';
                headerApp.status = data.status || 'U';
                headerApp.point = data.point || 0;
            }
        },
        error: function (xhr, status, err) {
            console.error("카카오 로그인 실패:", err);
        }
    });
};