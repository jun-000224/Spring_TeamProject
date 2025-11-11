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
      id: window.sessionData?.id || "",
      nickname: window.sessionData?.nickname || "",
      status: window.sessionData?.status || "",
      gradeLabel: ""  // 초기값
    };
  },
  computed: {
    isLoggedIn() {
      return this.nickname && this.nickname !== "null" && this.nickname.trim() !== "";
    }
  },
  mounted() {
    // mounted에서 gradeLabel 계산 후 저장
    switch(this.status) {
      case "A": this.gradeLabel = "👑"; break;
      case "S": this.gradeLabel = "✨"; break;
      case "U": this.gradeLabel = "🙂"; break;
      default: this.gradeLabel = "❓";
    }

    // 전역에서도 사용 가능하게
    window.sessionData.gradeLabel = this.gradeLabel;
  }
});

headerApp.mount('#app-header');
