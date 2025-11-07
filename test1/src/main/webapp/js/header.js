// /js/header.js
//if(!window.headerApp){
//	const headerApp = Vue.createApp({
//	  data() {
//	    return {
//	      // JSP에서 전달된 세션 데이터 사용
//	      id: window.sessionData?.id || "",
//	      status: window.sessionData?.status || "",
//	      nickname: window.sessionData?.nickname || "",
//	      name: window.sessionData?.name || "",
//	      point: window.sessionData?.point || 0,

//	      // 내부 상태
//	      showLogoutMenu: false,
//	    };
//	  },
//	  computed: {
//	    isLoggedIn() {
//	      return this.id && this.id !== "null";
//	    },
//	    gradeLabel() {
//	      switch (this.status) {
//	        case "A": return "👑";
//	        case "S": return "✨";
//	        case "U": return "🙂";
//	        default: return "❓";
//	      }
//	    },
//	  },
//	  methods: {
//	      toggleLogoutMenu() {
//			console.log(this.showLogoutMenu);
//	        this.showLogoutMenu = !this.showLogoutMenu;
//	      },
//	      logout() {
//			console.log("logout");
//	        $.ajax({
//	          url: "/member/logout.dox",
//	          dataType: "json",
//	          type: "POST",
//	          success: (data) => {
//	            alert(data.msg || "로그아웃되었습니다.");
//	            location.href = "/main-list.do";
//	          },
//	          error: () => {
//	            alert("로그아웃 중 오류가 발생했습니다.");
//	          },
//	        });
//	      },
//	      goToLogin() {
//	        location.href = "/member/login.do";
//	      },
//	      goToMyPage() {
//	        location.href = "/main-myPage.do";
//	      },
//	    },
//	  });
//	  headerApp.mount("#app-header");
//}



function logout(){
	console.log("logout");
	$.ajax({
      url: "/member/logout.dox",
      dataType: "json",
      type: "POST",
      success: (data) => {
        //alert(data.msg || "로그아웃되었습니다.");
		console.log(data);
		
		const clientId = data.kakaoClientId;
        const redirectUri = data.kakaoRedirectUri;

		const fullLogoutUrl =
          `https://accounts.kakao.com/logout?continue=` +
          encodeURIComponent(
            `https://kauth.kakao.com/oauth/logout?client_id=${clientId}&logout_redirect_uri=${redirectUri}`
          );

        window.location.href = fullLogoutUrl;
		//alert(data.msg);
       // location.href = "/main-list.do";
      },
      error: () => {
        alert("로그아웃 중 오류가 발생했습니다.");
      },
    });
}


function goToLogin() {
   location.href = "/member/login.do";
}

function goToMyPage() {
	location.href = "/main-myPage.do";
}

function myPoint() {
	location.href = "/point/myPoint.do";
}


const headerApp = Vue.createApp({
	data() {
		
		return {
			id : window.sessionData.id,
			nickname : window.sessionData.nickname,
			status : window.sessionData.status,
		}
	},
	
	computed:{
		isLoggedIn() {
            return this.nickname !== "";
			//return this.nickname && this.nickname !== "null" && this.nickname.trim() !== "";
        },
        gradeLabel() {
            switch (this.status) {
                case 'A': return '👑 ';
                case 'S': return '✨ ';
                case 'U': return '🙂 ';
                default: return '❓ 미지정';
            }
        }
	},
	
	methods : {
		
	},
	
	mounted() {
		window.sessionData.gradeLabel = this.gradeLabel;
	}
});

headerApp.mount('#app-header');