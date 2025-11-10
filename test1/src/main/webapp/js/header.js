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
