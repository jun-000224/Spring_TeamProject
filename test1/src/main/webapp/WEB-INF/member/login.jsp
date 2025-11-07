<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>로그인 | READY</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!-- 기존 공통 CSS 유지 -->
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
                --shadow: 0 10px 25px rgba(0, 0, 0, .06);
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box
            }

            /* 다른 화면에서 쓸 수도 있는 테이블 스타일은 유지 */
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
                font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic";
                color: var(--text);
                background:
                    radial-gradient(1200px 600px at 80% -10%, #e8f0ff 0%, transparent 60%),
                    radial-gradient(900px 500px at -10% 110%, #e9fdf5 0%, transparent 60%),
                    var(--bg);
            }

            .body {
                margin: clamp(48px, 10vh, 120px) auto 80px;
                max-width: 860px;
                padding: 0 16px;
                min-height: 420px;
                display: grid;
                place-items: center;
            }

            .loginField {
                width: 100%;
                max-width: min(460px, 100%);
                background: var(--card);
                border: 1px solid var(--border);
                border-radius: 16px;
                box-shadow: var(--shadow);
                padding: 24px;
                text-align: left;
                overflow: visible;
            }

            .brand {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 8px
            }

            .brand-badge {
                width: 40px;
                height: 40px;
                border-radius: 12px;
                background: linear-gradient(135deg, #60a5fa, #34d399);
                display: grid;
                place-items: center;
                color: #fff;
                font-weight: 700;
                box-shadow: 0 6px 16px rgba(52, 211, 153, .35);
                flex: 0 0 auto;
            }

            .brand-title {
                margin: 0;
                font-size: 20px;
                font-weight: 800
            }

            .brand-sub {
                margin: 0 0 16px 0;
                color: var(--muted);
                font-size: 14px
            }

            .field {
                margin-bottom: 12px
            }

            .field label {
                display: block;
                font-weight: 600;
                font-size: 14px;
                margin: 0 0 8px 0
            }

            .input {
                width: 100%;
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 12px 14px;
                font-size: 15px;
                outline: 0;
                background: #fff;
                transition: border-color .2s, box-shadow .2s;
                min-width: 0;
            }

            .input::placeholder {
                color: #9ca3af
            }

            .input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 4px rgba(37, 99, 235, .12)
            }

            .btn {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                border: 0;
                border-radius: 12px;
                cursor: pointer;
                padding: 12px 16px;
                font-weight: 700;
                font-size: 15px;
                transition: background .15s, transform .02s, opacity .2s;
            }

            .btn-primary {
                width: 100%;
                background: var(--primary);
                color: #fff
            }

            .btn-primary:hover {
                background: var(--primary-hover)
            }

            .btn-outline {
                background: #fff;
                color: var(--text);
                border: 1px solid var(--border);
                flex: 1 1 160px;
            }

            .btn:active {
                transform: translateY(1px)
            }

            .btn[disabled] {
                opacity: .7;
                cursor: not-allowed
            }

            .row-actions {
                display: flex;
                gap: 8px;
                margin-top: 8px;
                flex-wrap: wrap;
            }

            .alert {
                display: none;
                margin: 6px 0 0;
                padding: 10px 12px;
                border: 1px solid var(--danger-border);
                background: var(--danger-bg);
                color: #991b1b;
                border-radius: 10px;
                font-size: 14px;
            }

            .alert.show {
                display: block
            }

            /* 카카오 버튼: 위쪽으로 이동 & 풀폭 */
            .kakaoBtn {
                margin-top: 14px;
                display: flex;
                justify-content: center;
                width : 200px
            }

            .kakaoBtn a {
                width: 100%;
                max-width: 100%;
                border-radius: 10px;
                overflow: hidden;
                border: 1px solid var(--border);
                background: #fee500;
                box-shadow: 0 6px 16px rgba(0, 0, 0, .08);
                transition: transform .05s, box-shadow .2s, border-color .2s;
            }

            .kakaoBtn a:hover {
                border-color: #e6c800;
                box-shadow: 0 8px 22px rgba(0, 0, 0, .12)
            }

            .kakaoBtn img {
                display: block;
                width: 100%;
                height: 48px;
                object-fit: contain
            }

            /* 회원가입 문구 CTA */
            .cta-join {
                margin-top: 12px;
                text-align: center;
                font-size: 14px;
                color: var(--muted);
            }

            .cta-join a {
                color: var(--primary);
                text-decoration: underline;
                text-underline-offset: 2px;
                cursor: pointer;
            }

            .cta-join a:hover {
                color: var(--primary-hover)
            }

            .spinner {
                display: inline-block;
                width: 18px;
                height: 18px;
                vertical-align: -4px;
                border: 2px solid rgba(255, 255, 255, .55);
                border-top-color: #fff;
                border-radius: 50%;
                animation: spin .8s linear infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg)
                }
            }

            @media (max-width:360px) {
                .loginField {
                    padding: 18px;
                    border-radius: 12px
                }

                .brand-title {
                    font-size: 18px
                }

                .btn {
                    padding: 11px 14px;
                    font-size: 14px
                }

                .kakaoBtn img {
                    height: 44px
                }
            }
        </style>
    </head>

    <body>
        <div id="app">
            <%@ include file="../components/header.jsp" %>

                <div class="body">
                    <div class="loginField">
                        <div class="brand">
                            <div class="brand-badge">R</div>
                            <h1 class="brand-title">READY 로그인</h1>
                        </div>
                        <p class="brand-sub">계정으로 로그인해 주세요.</p>

                        <!-- 카카오 로그인 (상단으로 이동) -->
                        <div class="kakaoBtn">
                            <a :href="kakaolocation" aria-label="카카오 로그인">
                                <img src="/img/kakao.png" alt="카카오로 로그인">
                            </a>
                        </div>

                        <!-- 아이디/비밀번호 -->
                        <div class="field" style="margin-top:16px;">
                            <label for="id">아이디</label>
                            <input id="id" class="input" type="text" v-model="id" placeholder="영문 소문자+숫자"
                                autocomplete="username" @input="id = id.replace(/[^a-z0-9]/g, '')">
                        </div>

                        <div class="field">
                            <label for="pwd">비밀번호</label>
                            <input id="pwd" class="input" type="password" v-model="pwd" placeholder="비밀번호를 입력하세요"
                                autocomplete="current-password" @keyup.enter="fnLogin">
                        </div>

                        <div id="alertBox" class="alert" aria-live="polite">{{ alertMsg }}</div>

                        <!-- 로그인 버튼 -->
                        <div style="margin-top:8px;">
                            <button class="btn btn-primary" :disabled="loading" @click="fnLogin">
                                <span v-if="loading" class="spinner"></span>
                                <span v-if="!loading">로그인</span>
                                <span v-else style="margin-left:6px;">로그인 중…</span>
                            </button>
                        </div>

                        <!-- 보조 액션: 아이디/비밀번호 찾기만 버튼 유지 -->
                        <div class="row-actions">
                            <button class="btn btn-outline" @click="fnFind">아이디/비밀번호 찾기</button>
                        </div>

                        <!-- 회원가입 문구 CTA (버튼 대신 텍스트 링크) -->
                        <div class="cta-join">
                            아직 회원이 아니시라면
                            <a @click.prevent="fnJoin" href="/member/join.do" aria-label="회원가입으로 이동">회원가입</a>
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
                        pwd: "",
                        kakaolocation: "${kakao_location}",
                        loading: false,
                        alertMsg: ""
                    }
                },
                methods: {
                    showAlert(msg) {
                        this.alertMsg = msg || "";
                        const el = document.getElementById('alertBox');
                        if (el) {
                            if (this.alertMsg) { el.classList.add('show'); }
                            else { el.classList.remove('show'); }
                        }
                    },
                    fnLogin() {
                        if (this.loading) return;
                        if (!this.id) {
                            this.showAlert("아이디를 입력해주세요.");
                            this.$nextTick(() => document.getElementById('id')?.focus());
                            return;
                        }
                        if (!this.pwd) {
                            this.showAlert("비밀번호를 입력해주세요.");
                            this.$nextTick(() => document.getElementById('pwd')?.focus());
                            return;
                        }
                        this.showAlert("");
                        this.loading = true;

                        const param = { userId: this.id, pwd: this.pwd };
                        $.ajax({
                            url: "/member/login.dox",
                            dataType: "json",
                            type: "POST",
                            data: param
                        })
                            .done((data) => {
                                if (data?.result === "success") {
                                    location.href = "/main-list.do";
                                } else {
                                    this.showAlert(data?.msg || "아이디 또는 비밀번호를 확인해 주세요.");
                                }
                            })
                            .fail((xhr, status, error) => {
                                this.showAlert("오류가 발생했습니다: " + (error || "네트워크 오류"));
                            })
                            .always(() => {
                                this.loading = false;
                            });
                    },
                    fnFind() { location.href = "/member/find.do"; },
                    fnJoin() { location.href = "/member/join.do"; }
                },
                mounted() {
                    // 필요 시 전역 Enter 보조
                    document.addEventListener('keydown', (e) => {
                        const inside = !!e.target.closest('#app');
                        if (inside && e.key === 'Enter') {
                            const tag = (e.target.tagName || '').toLowerCase();
                            if (tag !== 'input' && tag !== 'textarea') {
                                this.fnLogin();
                            }
                        }
                    });
                }
            });

            app.mount('#app');
        </script>
    </body>

    </html>