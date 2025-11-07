<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1.0" />
        <title>비밀번호 재설정 | READY</title>

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
                --success: #16a34a;
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box
            }

            /* (다른 화면 테이블 스타일 유지 필요 시) */
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
                margin-bottom: 8px;
            }

            .badge {
                width: 40px;
                height: 40px;
                border-radius: 12px;
                background: linear-gradient(135deg, #60a5fa, #2563eb);
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
                margin-bottom: 8px;
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
                /* 폭 보호 */
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
                cursor: pointer;
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

            .pwdCheckMsg {
                margin-left: 12px;
                font-size: 13px
            }

            .checkTrue {
                color: var(--success);
                font-weight: 700
            }

            .checkFalse {
                color: var(--danger);
                font-weight: 700
            }
        </style>
    </head>

    <body>
        <div id="app">
            <%@ include file="../components/header.jsp" %>

                <div class="field">
                    <div class="findField">

                        <div class="head">
                            <div class="badge">PW</div>
                            <h1 class="title">비밀번호 재설정</h1>
                        </div>
                        <p class="subtitle">본인 확인 후 새 비밀번호로 변경합니다.</p>

                        <!-- 아이디 -->
                        <div class="findBlock">
                            <label class="label">아이디</label>
                            <template v-if="!certifiFlg">
                                <input type="text" class="input" v-model="id" @input="id = id.replace(/[^a-z0-9]/g,'')">
                            </template>
                            <template v-else>
                                {{ id }}
                            </template>
                        </div>

                        <!-- 이름 -->
                        <div class="findBlock">
                            <label class="label">이름</label>
                            <template v-if="!certifiFlg">
                                <input type="text" class="input" v-model="name" @input="onNameInput"
                                    @compositionstart="isComposing = true" @compositionend="onCompositionEnd"
                                    placeholder="이름을 입력하세요">
                            </template>
                            <template v-else>
                                {{ name }}
                            </template>
                        </div>

                        <!-- 전화번호 -->
                        <div class="findBlock">
                            <label class="label">전화번호</label>
                            <template v-if="!certifiFlg">
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
                                    <input type="text" class="input seg" v-model="phone2" maxlength="4"
                                        placeholder="####" @input="phone2 = phone2.replace(/[^0-9]/g,'').slice(0,4)">
                                    <input type="text" class="input seg" v-model="phone3" maxlength="4"
                                        placeholder="####" @input="phone3 = phone3.replace(/[^0-9]/g,'').slice(0,4)">
                                </div>
                            </template>
                            <template v-else>
                                {{ phone1 }}-{{ phone2 }}-{{ phone3 }}
                            </template>
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

                        <!-- 본인 확인 -->
                        <div class="btnbar" v-if="!certifiFlg">
                            <button type="button" class="btn" @click="fnTemp">본인 확인</button>
                        </div>

                        <!-- 새 비밀번호 입력 -->
                        <div v-if="changeFlg" class="findBlock">
                            <label class="label">새 비밀번호</label>
                            <input type="password" class="input" v-model="pwd"
                                @input="pwd = pwd.replace(/[^a-zA-Z0-9!@#$%^&*(),.?/:{}|<>]/g,'')">
                        </div>

                        <div v-if="changeFlg" class="findBlock">
                            <label class="label">비밀번호 확인</label>
                            <div style="display:flex; align-items:center;">
                                <input type="password" class="input" v-model="pwd2"
                                    @input="pwd2 = pwd2.replace(/[^a-zA-Z0-9!@#$%^&*(),.?/:{}|<>]/g,'')">
                                <div class="pwdCheckMsg">
                                    <span v-if="pwd !== '' && pwd2 !== '' && pwd === pwd2" class="checkTrue">일치함</span>
                                    <span v-else-if="pwd !== '' && pwd2 !== '' && pwd !== pwd2"
                                        class="checkFalse">불일치</span>
                                </div>
                            </div>
                        </div>

                        <!-- 경고 -->
                        <div id="alertBox" class="alert">{{ alertMsg }}</div>

                        <!-- 변경 버튼 -->
                        <div v-if="changeFlg" class="btnbar">
                            <button type="button" class="btn" @click="fnPwdChange">비밀번호 변경</button>
                        </div>

                    </div>
                </div>

                <%@ include file="../components/footer.jsp" %>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        id: "",
                        name: "",
                        phone1: "010",
                        phone2: "",
                        phone3: "",
                        pwd: "",
                        pwd2: "",
                        timer: "",
                        count: 180,
                        smsFlg: false,       // 인증번호 발송 여부
                        certifiFlg: false,   // 문자 인증 완료 여부
                        inputNum: "",        // 입력 인증번호
                        certifiStr: "",      // 서버 발송 인증번호
                        changeFlg: false,    // 비밀번호 변경 폼 표시 여부
                        isComposing: false,
                        alertMsg: ""
                    };
                },
                methods: {
                    showAlert(msg) {
                        this.alertMsg = msg || "";
                        var el = document.getElementById("alertBox");
                        if (this.alertMsg) { el.classList.add("show"); }
                        else { el.classList.remove("show"); }
                    },

                    onNameInput(e) {
                        if (this.isComposing) return;
                        this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g, '');
                    },
                    onCompositionEnd(e) {
                        this.isComposing = false;
                        this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g, '');
                    },

                    /* 본인 확인 (id+name+phone 검사) */
                    fnTemp() {
                        this.showAlert("");

                        if (this.id === "") {
                            this.showAlert("아이디를 입력해주세요.");
                            return;
                        }
                        if (this.name === "") {
                            this.showAlert("이름을 입력해주세요.");
                            return;
                        }
                        if (this.phone2.length !== 4 || this.phone3.length !== 4) {
                            this.showAlert("전화번호를 정확히 입력해주세요.");
                            return;
                        }
                        // 문자 인증을 필수로 쓸 때는 아래 주석 해제
                        // if(!this.certifiFlg){ this.showAlert("문자인증을 완료해주세요."); return; }

                        var param = {
                            userId: this.id,
                            name: this.name,
                            phone: this.phone1 + "-" + this.phone2 + "-" + this.phone3
                        };

                        $.ajax({
                            url: "/member/pwdCheck.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: (data) => {
                                if (data.result === "success") {
                                    alert(data.msg || "본인 확인 완료");
                                    this.certifiFlg = true;
                                    this.changeFlg = true;
                                } else {
                                    this.showAlert(data.msg || "일치하는 정보가 없습니다.");
                                }
                            },
                            error: () => {
                                this.showAlert("오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                            }
                        });
                    },

                    /* 비밀번호 변경 */
                    fnPwdChange() {
                        this.showAlert("");

                        if (this.pwd === "" || this.pwd2 === "") {
                            this.showAlert("비밀번호를 입력해주세요.");
                            return;
                        }
                        if (this.pwd !== this.pwd2) {
                            this.showAlert("비밀번호가 일치하지 않습니다.");
                            return;
                        }

                        var param = {
                            userId: this.id,
                            pwd: this.pwd
                        };

                        $.ajax({
                            url: "/member/pwdChange.dox",
                            type: "POST",
                            dataType: "json",
                            data: param,
                            success: (data) => {
                                if (data.result === "success") {
                                    alert(data.msg || "비밀번호가 변경되었습니다.");
                                    location.href = "/member/login.do";
                                } else {
                                    this.showAlert(data.msg || "비밀번호 변경에 실패했습니다.");
                                }
                            },
                            error: () => {
                                this.showAlert("오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
                            }
                        });
                    },

                    /* 문자 인증 전송 */
                    fnSms() {
                        $.ajax({
                            url: "/send-one",
                            type: "POST",
                            dataType: "json",
                            data: {},
                            success: (data) => {
                                if (data.res && data.res.statusCode == "2000") {
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

                    /* 타이머 */
                    fnTimer() {
                        this.count = 180;
                        var interval = setInterval(() => {
                            if (this.count <= 0) {
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

                    /* 문자 인증 확인 */
                    fnSmsAuth() {
                        if (this.certifiStr == this.inputNum) {
                            alert("문자인증 완료");
                            this.certifiFlg = true;
                        } else {
                            alert("문자인증 실패");
                        }
                    },

                    fnGoLogin() {
                        location.href = "/member/login.do";
                    }
                }
            });

            app.mount("#app");
        </script>
    </body>

    </html>