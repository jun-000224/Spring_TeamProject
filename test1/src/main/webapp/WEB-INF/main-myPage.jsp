<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>마이페이지</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(to right, #f8fbff, #e6f0ff);
                font-family: 'Noto Sans KR', sans-serif;
            }

            .mypage-container {
                max-width: 1000px;
                margin: 60px auto;
                padding: 0 20px;
                animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .profile-card {
                display: flex;
                align-items: center;
                background: linear-gradient(to right, #e0f7fa, #e1bee7);
                padding: 20px;
                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                margin-bottom: 40px;
            }

            .profile-img {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                margin-right: 20px;
                object-fit: cover;
            }

            .profile-info h3 {
                margin: 0;
                font-size: 24px;
                color: #333;
            }

            .profile-info p {
                margin-top: 8px;
                font-size: 16px;
                color: #666;
            }



            .nickname {
                display: inline-block;
                vertical-align: middle;
                line-height: 1.5;
                padding-top: 2px;
            }





            .logout-dropdown li:hover {
                background-color: #f0f0f0;
            }

            .mypage-menu {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 24px;
            }

            .menu-item {
                background: #fff;
                border-radius: 16px;
                padding: 30px 20px;
                text-align: center;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
                transition: transform 0.3s ease;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }

            .menu-item i {
                font-size: 28px;
                margin-bottom: 10px;
                color: #4a90e2;
            }

            .menu-item:hover {
                transform: translateY(-5px);
                background: #4a90e2;
                color: white;
            }

            .menu-item:hover i {
                color: white;
            }

            @media (max-width: 768px) {
                .profile-card {
                    flex-direction: column;
                    text-align: center;
                }

                .profile-img {
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>

    <body>
        <div id="app">
            <%@ include file="components/header.jsp" %>

                <div class="mypage-container">

                    <div class="profile-card">
                        <img src="/images/default-profile.png" alt="프로필 이미지 넣는곳" class="profile-img">
                        <div class="profile-info">
                            <h3>{{ nickname }} {{ gradeLabel }} 님</h3>
                            <p>등급: {{ gradeLabel }} | 포인트: {{ point }}P</p>
                        </div>

                    </div>

                    <div class="mypage-menu">
                        <a href="/myInfo.do" class="menu-item">
                            <i class="fas fa-user-edit"></i><br>내 정보 관리
                        </a>
                        <a href="/myReservation.do" class="menu-item">
                            <i class="fas fa-calendar-check"></i><br>내 예약 확인
                        </a>
                        <a href="/myCommunity.do" class="menu-item">
                            <i class="fas fa-comments"></i><br>내 커뮤니티
                        </a>
                        <!-- <a href="/changePassword.do" class="menu-item">
          <i class="fas fa-key"></i><br>비밀번호 수정
        </a> -->
                        <a href="/wishlist.do" class="menu-item">
                            <i class="fas fa-heart"></i><br>찜 리스트
                        </a>
                        <a href="/membership.do" class="menu-item">
                            <i class="fas fa-id-card"></i><br>멤버쉽 관리
                        </a>
                        <a href="/myComments.do" class="menu-item">
                            <i class="fas fa-comment-dots"></i><br>나의 작성글 / 댓글
                        </a>
                    </div>
                </div>
 
                <%@ include file="components/footer.jsp" %>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    id: "${sessionId}",
                    status: "${sessionStatus}",
                    nickname: "${sessionNickname}",
                    name: "${sessionName}",
                    point: "${sessionPoint}",
                    showLogoutMenu: false
                };
            },
            computed: {
                isLoggedIn() {
                    return this.nickname !== "";
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
            methods: {
                toggleLogoutMenu() {
                    this.showLogoutMenu = !this.showLogoutMenu;
                },
                goToSettings() {
                    location.href = "/myPoint.do";
                },
                goToWithdraw() {
                    location.href = "/member/withdraw.do";
                },
                goToLogin() {
                    location.href = "/member/login.do";
                },
                logout() {
                    location.href = "/logout.do";
                },
                goToMyPage() {
                    location.href = "/main-myPage.do";
                }
            },

            mounted() {
                let self = this;

                $.ajax({
                    url: '/main-myPage/info.dox',
                    type: 'POST',
                    dataType: 'json',
                    success: function (res) {
                        const data = res.data;
                        self.nickname = data.nickname;
                        self.status = data.status;
                        self.point = data.pointTotal;
                    },
                    error: function (err) {
                        console.error('마이페이지 정보 조회 실패:', err);
                    }
                });
            }

        });

        app.mount('#app');
    </script>