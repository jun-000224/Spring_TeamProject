<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원 탈퇴</title>
  <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <style>
    * {
      box-sizing: border-box;
      font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
    }
    body {
      background: linear-gradient(135deg, #f9fafb, #f3f4f6);
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .card {
      background: white;
      padding: 40px 50px;
      border-radius: 20px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
      width: 380px;
      text-align: center;
      transition: all 0.3s ease;
    }
    .card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
    }
    h2 {
      font-size: 22px;
      color: #222;
      margin-bottom: 25px;
    }
    .ynBtn button {
      border: none;
      border-radius: 8px;
      padding: 12px 24px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: 0.2s;
    }
    .yesBtn {
      background-color: #d32f2f;
      color: #fff;
      margin-right: 15px;
    }
    .yesBtn:hover {
      background-color: #b71c1c;
    }
    .noBtn {
      background-color: #f3f4f6;
      color: #444;
    }
    .noBtn:hover {
      background-color: #e0e0e0;
    }
    select, input {
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 6px;
      font-size: 14px;
      margin: 4px;
      outline: none;
      transition: all 0.2s;
    }
    input:focus, select:focus {
      border-color: #6366f1;
      box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
    }
    .checkButton, .joinBlock button {
      border: none;
      border-radius: 6px;
      background-color: #6366f1;
      color: white;
      padding: 8px 18px;
      font-size: 14px;
      font-weight: 500;
      cursor: pointer;
      margin-top: 8px;
      transition: 0.2s;
    }
    .checkButton:hover, .joinBlock button:hover {
      background-color: #4f46e5;
    }
    .joinBlock {
      text-align: left;
      margin-top: 20px;
    }
    .phone {
      display: flex;
      align-items: center;
      margin-top: 6px;
    }
    .phone input {
      width: 60px;
      text-align: center;
    }
    .inputWidth {
      width: 120px;
      text-align: center;
      margin-right: 8px;
    }
    .timer {
      color: #888;
      font-size: 13px;
      margin-left: 6px;
    }
    .fade {
      animation: fadeIn 0.4s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(5px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
  <div id="app">
    <div class="card fade">
      <h2 v-if="!confirmFlg">정말 탈퇴하시겠습니까?</h2>

      <div v-if="!confirmFlg" class="ynBtn">
        <button class="yesBtn" @click="fnConfirm">예</button>
        <button class="noBtn" @click="fnCancel">아니오</button>
      </div>

      <div v-else class="fade">
        <div class="joinBlock">
          <label>전화번호</label><br>
          <div class="phone">
            <select v-model="phone1">
              <option value="010">010</option>
              <option value="011">011</option>
              <option value="016">016</option>
              <option value="017">017</option>
              <option value="018">018</option>
              <option value="019">019</option>
            </select>
            -
            <input type="text" v-model="phone2" maxlength="4" @input="phone2 = phone2.replace(/[^0-9]/g, '').slice(0, 4)">
            -
            <input type="text" v-model="phone3" maxlength="4" @input="phone3 = phone3.replace(/[^0-9]/g, '').slice(0, 4)">
          </div>

          <div v-if="!certifiFlg" class="fade">
            <label>문자인증</label><br>
            <input type="text" class="inputWidth" v-model="inputNum" :placeholder="timer">
            <template v-if="!smsFlg">
              <button @click="fnSms" class="checkButton">인증번호 전송</button>
            </template>
            <template v-else>
              <button @click="fnSmsAuth" class="checkButton">인증 확인</button>
              <span class="timer">{{ timer }}</span>
            </template>
          </div>

          <div v-else class="fade" style="text-align:center; margin-top:20px;">
            <button @click="fnRelease">회원 탈퇴 완료</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    const app = Vue.createApp({
      data() {
        return {
          userId: "",
          confirmFlg: false,
          phone1: "010",
          phone2: "",
          phone3: "",
          timer: "",
          count: 180,
          smsFlg: false,
          certifiFlg: false,
          inputNum: "",
          certifiStr: "",
        };
      },
      methods: {
        fnConfirm() {
          this.confirmFlg = true;
        },
        fnCancel() {
          window.close();
        },
        fnRelease() {
          let self = this;
          let param = { userId: self.userId };
          $.ajax({
            url: "/mypage/delete.dox",
            dataType: "json",
            type: "POST",
            data: param,
            success(data) {
              if (data.result == "success") {
                alert(data.msg);
                if (window.opener && !window.opener.closed) {
                  window.opener.location.href = "/main-list.do";
                }
                window.close();
              } else {
                alert(data.msg);
              }
            },
          });
        },
        fnReceiveMessage(event) {
          if (event.origin !== window.location.origin) return;
          this.userId = event.data.userId;
        },
        fnSms() {
          let self = this;
          let param = { phone: self.phone1 + self.phone2 + self.phone3 };
          $.ajax({
            url: "/send-one",
            dataType: "json",
            type: "POST",
            data: param,
            success(data) {
              if (data.res.statusCode == "2000") {
                alert("문자 전송 완료");
                self.certifiStr = data.ranStr;
                self.smsFlg = true;
                self.fnTimer();
              } else {
                alert("잠시 후 다시 시도해주세요.");
              }
            },
          });
        },
        fnTimer() {
          let self = this;
          let interval = setInterval(() => {
            if (self.count == 0) {
              clearInterval(interval);
              alert("시간이 만료되었습니다.");
              window.close();
            } else {
              let min = String(parseInt(self.count / 60)).padStart(2, "0");
              let sec = String(self.count % 60).padStart(2, "0");
              self.timer = min + ":" + sec;
              self.count--;
            }
          }, 1000);
        },
        fnSmsAuth() {
          if (this.certifiStr == this.inputNum) {
            alert("문자인증이 완료되었습니다.");
            this.certifiFlg = true;
          } else {
            alert("문자인증에 실패했습니다.");
          }
        },
      },
      mounted() {
        window.addEventListener("message", this.fnReceiveMessage);
      },
    });

    app.mount("#app");
  </script>
</body>
</html>
