<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>어드민페이지</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                padding: 20px;
            }

            .admin-info {
                margin-bottom: 20px;
                background: #f1f1f1;
                padding: 10px;
                border-radius: 6px;
            }

            .tab-buttons button {
                margin-right: 10px;
                padding: 8px 16px;
                border: none;
                background-color: #007bff;
                color: white;
                border-radius: 4px;
                cursor: pointer;
            }

            .panel {
                margin-top: 20px;
                padding: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background: #fafafa;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 8px;
            }

            th {
                background-color: #eee;
            }

            .form-inline {
                margin-top: 10px;
            }

            .form-inline input {
                padding: 6px;
                margin-right: 10px;
            }

            .form-inline button {
                padding: 6px 12px;
            }

            .link-button {
                background: none;
                border: none;
                color: #007bff;
                cursor: pointer;
                text-decoration: underline;
                padding: 0;
                font-size: 1em;
            }
        </style>
    </head>

    <body>
        <div id="adminApp">
            <%@ include file="components/header.jsp" %>

                <div class="admin-info">
                    <p><strong>관리자:</strong> {{ name }} ({{ nickname }})</p>
                    <p><strong>ID:</strong> {{ id }} / <strong>포인트:</strong> {{ point }} / <strong>권한:</strong> {{
                        status }}</p>
                </div>

                <div class="tab-buttons">
                    <button @click="activeTab = 'inquiry'">문의사항 답변</button>
                    <button @click="activeTab = 'report'">신고 관리기능</button>
                </div>

                <!-- 문의사항 답변 -->
                <div v-if="activeTab === 'inquiry'" class="panel">
                    <h3>문의사항 답변</h3>

                    <!-- 문의 리스트 -->
                    <table v-if="!selectedInquiry">
                        <tr>
                            <th>제목</th>
                            <th>신고자</th>
                            <th>답변</th>
                        </tr>
                        <tr v-for="item in inquiries" :key="item.boardNo">
                            <td>
                                <button class="link-button" @click="selectInquiry(item)">
                                    {{ item.title }}
                                </button>
                            </td>
                            <td>{{ item.userId }}</td>
                            <td><button @click="reply(item)">답변하기</button></td>
                        </tr>

                    </table>

                    <!-- 문의 상세 -->
                    <div v-else>
                        <h4>{{ selectedInquiry.title }}</h4>
                        <p><strong>작성자:</strong> {{ selectedInquiry.userId }}</p>
                        <p><strong>내용:</strong></p>
                        <p>{{ selectedInquiry.contents }}</p>
                        <button @click="selectedInquiry = null">← 목록으로 돌아가기</button>
                    </div>
                </div>

                <!-- 신고 관리기능 -->
                <div v-if="activeTab === 'report'" class="panel">
                    <h3>신고 관리기능</h3>
                    <div class="tab-buttons">
                        <button @click="reportTab = 'posts'">신고 누적 게시글</button>
                        <button @click="reportTab = 'badUsers'">불량 유저</button>
                        <button @click="reportTab = 'block'">유저 제한</button>
                        <button @click="reportTab = 'unblock'">제한 해제</button>
                    </div>

                    <!-- 신고 누적 게시글 -->
                    <div v-if="reportTab === 'posts'">
                        <h4>신고 누적 게시글</h4>
                        <table>
                            <tr>
                                <th>게시글번호</th>
                                <th>제목</th>
                                <th>신고횟수</th>
                            </tr>
                            <tr v-for="post in reportedPosts" :key="post.boardNo">
                                <td>{{ post.boardNo }}</td>
                                <td>{{ post.title }}</td>
                                <td>{{ post.reportCnt }}</td>
                            </tr>
                        </table>
                    </div>

                    <!-- 불량 유저 -->
                    <div v-if="reportTab === 'badUsers'">
                        <h4>불량 유저</h4>
                        <table>
                            <tr>
                                <th>유저ID</th>
                                <th>이름</th>
                                <th>상태</th>
                            </tr>
                            <tr v-for="user in badUsers" :key="user.userId">
                                <td>{{ user.userId }}</td>
                                <td>{{ user.name }}</td>
                                <td>{{ user.status }}</td>
                            </tr>
                        </table>
                    </div>

                    <!-- 유저 제한 -->
                    <div v-if="reportTab === 'block'" class="form-inline">
                        <h4>유저 제한</h4>
                        <input v-model="targetUserId" placeholder="유저 ID 입력" />
                        <button @click="blockUser">제한하기</button>
                    </div>

                    <!-- 제한 해제 -->
                    <div v-if="reportTab === 'unblock'" class="form-inline">
                        <h4>제한 해제</h4>
                        <input v-model="targetUserId" placeholder="유저 ID 입력" />
                        <button @click="unblockUser">해제하기</button>
                    </div>
                </div>

                <%@ include file="components/footer.jsp" %>
        </div>

        <script>
            const adminApp = Vue.createApp({
                data() {
                    return {
                        id: "${sessionId}",
                        status: "${sessionStatus}",
                        nickname: "${sessionNickname}",
                        name: "${sessionName}",
                        point: "${sessionPoint}",

                        activeTab: 'inquiry',
                        reportTab: 'posts',
                        inquiries: [],
                        selectedInquiry: null,
                        reportedPosts: [],
                        badUsers: [],
                        targetUserId: ''
                    };
                },
                mounted() {
                    this.fetchInquiries();

                },
                methods: {
                    fetchInquiries() {
                        $.get("/api/inquiries", res => {
                            this.inquiries = res;
                        });
                    },

                    selectInquiry(item) {
                        this.selectedInquiry = item;
                    },
                    reply(item) {
                        alert(`답변 작성: ${item.userId}에게`);
                    },
                    blockUser() {
                        $.post("/api/user/block", { userId: this.targetUserId }, () => {
                            alert("유저 제한 완료");
                            this.fetchBadUsers();
                        });
                    },
                    unblockUser() {
                        $.post("/api/user/unblock", { userId: this.targetUserId }, () => {
                            alert("제한 해제 완료");
                            this.fetchBadUsers();
                        });
                    }
                }
            });

            adminApp.mount('#adminApp');
        </script>
    </body>

    </html>