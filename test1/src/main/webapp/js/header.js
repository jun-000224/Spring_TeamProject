const headerApp = Vue.createApp({
    data() {
        return {
			// ✅ JSP에서 전달된 세션 정보 사용
            id: window.sessionData.id,
            status: window.sessionData.status,
            nickname: window.sessionData.nickname,
            name: window.sessionData.name,
            point: window.sessionData.point,

            // ✅ 내부 상태 관리용
            showLogoutMenu: false,
            code: ""
        };
    },
    computed: {
        // 로그인 여부
		isLoggedIn() {
            return (
                this.nickname !== "" &&
                this.nickname !== "null" &&
                this.nickname !== null
            );
        },
        // 회원 등급 표시
        gradeLabel() {
            switch (this.status) {
                case 'A': return '👑 관리자';
                case 'S': return '✨ 스페셜';
                case 'U': return '🙂 일반회원';
                default: return '';
            }
        }
    },
    methods: {
        toggleLogoutMenu() {
            this.showLogoutMenu = !this.showLogoutMenu;
        },
        		// 로그아웃 처리
		        logout() {
		            $.ajax({
		                url: "/member/logout.dox",
		                dataType: "json",
		                type: "POST",
		                success: (data) => {
		                    alert(data.msg || "로그아웃되었습니다.");
		                    location.href = "/main-list.do";
		                },
		                error: () => {
		                    alert("로그아웃 중 오류가 발생했습니다.");
		                }
		            });
		        },
		        // 로그인 페이지 이동
		        goToLogin() {
		            location.href = "/member/login.do";
		        },
		        // 마이페이지 이동
		        goToMyPage() {
		            location.href = "/main-myPage.do";
		        },
		        // ✅ 카카오 로그인 (redirect_uri에서 code 받기)
		        fnKakaoLogin() {
		            const queryParams = new URLSearchParams(window.location.search);
		            this.code = queryParams.get('code') || "";
		            if (!this.code) return; // code 없으면 무시

		            $.ajax({
		                url: "/kakao.dox",
		                dataType: "json",
		                type: "POST",
		                data: { code: this.code },
		                success: (data) => {
		                    console.log("카카오 로그인 결과:", data);
		                    if (data && data.nickname) {
		                        // 로그인 성공 시 새로고침
		                        location.href = "/main-list.do";
		                    } else {
		                        alert("카카오 로그인 실패");
		                    }
		                },
		                error: (xhr, status, err) => {
		                    console.error("카카오 로그인 오류:", err);
		                }
		            });
		        }
		    },
		    mounted() {
		        // 페이지 로드시 code가 있으면 카카오 로그인 처리
		        this.fnKakaoLogin();
		    }
		}).mount('#header');

		// 전역 접근 가능하도록 등록
		window.headerApp = headerApp;