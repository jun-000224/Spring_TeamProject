<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>아이디 찾기 | READY</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-images.css">

        <style>
            :root {
                --bg: #f6f7f9;
                --card: #fff;
                --text: #111827;
                --muted: #6b7280;
                --primary: #2563eb;
                --primary-hover: #1e40af;
                --border: #e5e7eb;
                --danger: #ef4444;
                --danger-bg: #fff1f2;
                --danger-border: #fecaca;
                --shadow: 0 12px 28px rgba(0, 0, 0, .06);
                --ring: rgba(37, 99, 235, .12);
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box
            }

            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige
            }

            tr:nth-child(even) {
                background-color: azure
            }

            body {
                margin: 0;
                font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto,
                    "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic";
                color: var(--text);
                background:
                    radial-gradient(1200px 600px at 80% -10%, #e8f0ff 0%, transparent 60%),
                    radial-gradient(900px 500px at -10% 110%, #e9fdf5 0%, transparent 60%),
                    var(--bg);
            }

            .field {
                margin: clamp(48px, 10vh, 120px) auto 80px;
                width: 100%;
                max-width: 920px;
                padding: 0 16px;
                display: grid;
                place-items: center;
            }

            .findField {
                width: 100%;
                max-width: 520px;
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 16px;
                box-shadow: var(--shadow);
                padding: 24px;
            }

            .head {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 8px
            }

            .badge {
                width: 40px;
                height: 40px;
                border-radius: 12px;
                background: linear-gradient(135deg, #34d399, #10b981);
                display: grid;
                place-items: center;
                color: #fff;
                font-weight: 800;
                box-shadow: 0 6px 16px rgba(0, 0, 0, .10);
            }

            .title {
                margin: 0;
                font-size: 20px;
                font-weight: 800
            }

            .subtitle {
                margin: 6px 0 18px 0;
                color: var(--muted);
                font-size: 14px
            }

            .findBlock {
                margin-top: 14px
            }

            .label {
                display: block;
                font-weight: 600;
                font-size: 14px;
                margin-bottom: 8px
            }

            .input,
            select {
                width: 100%;
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 12px 14px;
                font-size: 15px;
                outline: none;
                background: #fff;
                transition: border-color .2s, box-shadow .2s;
                min-width: 0;
            }

            .input:focus,
            select:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 4px var(--ring);
            }

            .phone-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .phone-group select {
                width: 92px;
                min-width: 92px;
            }

            .phone-group .seg {
                width: 100%
            }

            .auth-row {
                display: flex;
                gap: 8px;
                align-items: center
            }

            .timer {
                font-variant-numeric: tabular-nums;
                font-weight: 700;
                color: #dc2626;
            }

            .btnbar {
                margin-top: 16px;
                display: flex;
                justify-content: center;
            }

            .btn {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                padding: 12px 16px;
                min-width: 150px;
                border-radius: 12px;
                border: 0;
                background: var(--primary);
                color: white;
                font-weight: 700;
                font-size: 15px;
                cursor: pointer;
                transition: background .15s, transform .02s;
            }

            .btn:hover {
                background: var(--primary-hover)
            }

            .btn-outline {
                background: white;
                color: var(--text);
                border: 1px solid var(--border);
                padding: 10px 14px;
                min-width: 110px;
                border-radius: 10px;
            }

            .btn-outline:hover {
                border-color: var(--primary)
            }

            .result {
                margin-top: 10px;
                padding: 10px 12px;
                border: 1px solid #d1fae5;
                background: #ecfdf5;
                color: #065f46;
                border-radius: 10px;
                font-size: 14px;
            }

            .alert {
                margin-top: 10px;
                padding: 10px 12px;
                border: 1px solid var(--danger-border);
                background: var(--danger-bg);
                color: #991b1b;
                border-radius: 10px;
                font-size: 14px;
                display: none;
            }

            .alert.show {
                display: block
            }
        </style>
    </head>

    <body>
        <div id="app">
            <%@ include file="../components/header.jsp" %>

                <div class="field">
                    <div class="findField">

                        <div class="head">
                            <div class="badge">ID</div>
                            <h1 class="title">아이디 찾기</h1>
                        </div>
                        <p class="subtitle">이름과 휴대폰 번호로 아이디를 확인합니다.</p>

                        <!-- 이름 -->
                        <div class="findBlock">
                            <label class="label">이름</label>
                            <input type="text" class="input" v-model="name" placeholder="이름을 입력하세요" @input="onNameInput"
                                @compositionstart="isComposing = true" @compositionend="onCompositionEnd"
                                autofocus="true">
                        </div>

                        <!-- 전화번호 -->
                        <div class="findBlock">
                            <label class="label">전화번호</label>
                            <div class="phone-group">
                                <select v-model="phone1">
                                    <option value="010">010</option>
                                    <option value="011">011</option>
                                    <option value="012">012</option>
                                    <option value="016">016</option>
                                    <option value="017">017</option>
                                    <option value="018">018</option>
                                    <option value="019">019</option>
                                </select>

                                <input type="text" class="input seg" v-model="phone2" maxlength="4" placeholder="####"
                                    @input="phone2 = phone2.replace(/[^0-9]/g, '').slice(0,4)">

                                <input type="text" class="input seg" v-model="phone3" maxlength="4" placeholder="####"
                                    @input="phone3 = phone3.replace(/[^0-9]/g, '').slice(0,4)">
                            </div>
                        </div>

                        <!-- 문자인증 -->
                        <div class="findBlock" v-if="!certifiFlg">
                            <label class="label">문자인증</label>
                            <div class="auth-row">
                                <input type="text" class="input" v-model="inputNum" :placeholder="timer || '인증번호 입력'">

                                <template v-if="!smsFlg">
                                    <button type="button" class="btn-outline" @click="fnSms">전송</button>
                                </template>
                                <template v-else>
                                    <button type="button" class="btn-outline" @click="fnSmsAuth">인증</button>
                                </template>

                                <span v-if="timer" class="timer">{{ timer }}</span>
                            </div>
                        </div>

                        <!-- 결과 -->
                        <div class="findBlock" v-if="findFlg">
                            <div class="result">
                                아이디 : <strong>{{ userData.userId }}</strong>
                            </div>
                        </div>

                        <!-- 경고 -->
                        <div id="alertBox" class="alert">{{ alertMsg }}</div>

                        <!-- 버튼 -->
                        <div class="btnbar" v-if="!findFlg">
                            <button type="button" class="btn" @click="fnIdFind">아이디 확인</button>
                        </div>

                        <div class="btnbar" v-else>
                            <button type="button" class="btn" @click="fnGoLogin">로그인하러가기</button>
                        </div>

                    </div>
                </div>

                <%@ include file="../components/footer.jsp" %>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        name: "",
                        phone1: "010",
                        phone2: "",
                        phone3: "",
                        timer: "",
                        count: 180,
                        smsFlg: false,
                        certifiFlg: false,
                        inputNum: "",
                        certifiStr: "",
                        userData: {},
                        findFlg: false,
                        isComposing: false,
                        alertMsg: "",
                    };
                },
                methods: {
                    showAlert(msg) {
                        this.alertMsg = msg || "";
                        const el = document.getElementById('alertBox');
                        if (this.alertMsg) { el.classList.add('show'); }
                        else { el.classList.remove('show'); }
                    },

                    onNameInput(e) {
                        if (this.isComposing) return;
                        this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g, '');
                    },
                    onCompositionEnd(e) {
                        this.isComposing = false;
                        this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g, '');
                    },

                    fnIdFind() {
                        this.showAlert("");

                        if (this.name === "") {
                            this.showAlert("이름을 입력해주세요.");
                            return;
                        }
                        if (this.phone2.length !== 4 || this.phone3.length !== 4) {
                            this.showAlert("전화번호를 정확히 입력해주세요.");
                            return;
                        }

                        var param = {
                            name: this.name,
                            phone: this.phone1 + "-" + this.phone2 + "-" + this.phone3
                        };

                        $.ajax({
                            url: "/member/findId.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: (data) => {
                                if (data.result === "success") {
                                    this.userData = data.info;
                                    this.certifiFlg = true;
                                    this.findFlg = true;
                                } else {
                                    this.showAlert(data.msg || "일치하는 사용자를 찾을 수 없습니다.");
                                }
                            },
                            error: () => {
                                this.showAlert("오류가 발생했습니다.");
                            }
                        });
                    },

                    fnSms() {
                        var param = {
                            phone : self.phone1+self.phone2+self.phone3
                        };
                        $.ajax({
                            url: "/send-one",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: (data) => {
                                if (data.res && data.res.statusCode === "2000") {
                                    alert("문자 전송 완료");
                                    this.certifiStr = data.ranStr;
                                    this.smsFlg = true;
                                    this.fnTimer();
                                } else {
                                    alert("잠시 후 다시 시도해주세요.");
                                }
                            }
                        });
                    },

                    fnTimer() {
                        this.count = 180;
                        var interval = setInterval(() => {
                            if (this.count === 0) {
                                clearInterval(interval);
                                this.timer = "";
                                alert("시간이 만료되었습니다.");
                            } else {
                                var min = String(parseInt(this.count / 60)).padStart(2, "0");
                                var sec = String(this.count % 60).padStart(2, "0");
                                this.timer = min + " : " + sec;
                                this.count--;
                            }
                        }, 1000);
                    },

                    fnSmsAuth() {
                        if (this.certifiStr == this.inputNum) {
                            alert("문자인증 완료");
                            this.certifiFlg = true;
                            this.fnIdFind();
                        } else {
                            alert("문자인증 실패");
                        }
                    },

                    fnGoLogin() {
                        location.href = "/member/login.do";
                    }
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>