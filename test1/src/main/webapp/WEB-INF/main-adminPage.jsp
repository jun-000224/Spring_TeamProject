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

            .chat-popup {
                position: fixed;
                top: 20px;
                /* ✅ 오른쪽 상단 */
                right: 20px;
                width: 320px;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.25);
                z-index: 9999;
                font-family: 'Segoe UI', sans-serif;
                overflow: hidden;
                animation: fadeIn 0.3s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .chat-header {
                background: #0078d4;
                color: white;
                padding: 12px 16px;
                font-size: 15px;
                font-weight: bold;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .chat-body {
                padding: 16px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .chat-body textarea {
                width: 100%;
                height: 100px;
                resize: none;
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 10px;
                font-size: 14px;
                line-height: 1.4;
                box-sizing: border-box;
                transition: border-color 0.2s;
            }

            .chat-body textarea:focus {
                border-color: #0078d4;
                outline: none;
            }

            .send-btn {
                background: #0078d4;
                color: white;
                border: none;
                padding: 10px;
                border-radius: 8px;
                font-size: 14px;
                cursor: pointer;
                transition: background 0.2s;
            }

            .send-btn:hover {
                background: #005fa3;
            }

            .close-btn {
                background: transparent;
                border: none;
                color: white;
                font-size: 20px;
                cursor: pointer;
            }

            .inquiry-detail {
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                position: relative;
            }

            .detail-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }

            .detail-header h4 {
                font-size: 20px;
                font-weight: bold;
                margin: 0;
            }

            .back-btn {
                background-color: #f0f0f0;
                border: none;
                padding: 8px 12px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 14px;
                color: #333;
                transition: background-color 0.2s ease;
            }

            .back-btn:hover {
                background-color: #ddd;
            }

            .comment-box {
                background-color: #f9f9f9;
                border-left: 4px solid #4caf50;
                padding: 10px 15px;
                margin-bottom: 10px;
                border-radius: 5px;
            }

            .comment-box p {
                margin: 4px 0;
            }

            .comment-date {
                font-size: 12px;
                color: #888;
                margin-left: 8px;
            }

            .comment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .delete-btn {
                background: none;
                border: none;
                color: red;
                cursor: pointer;
                font-size: 0.9em;
            }

            .unblock-section {
                text-align: center;
                margin-top: 20px;
            }

            .input-box {
                padding: 8px 12px;
                font-size: 16px;
                border-radius: 6px;
                border: 1px solid #ccc;
                margin-bottom: 12px;
                /* ✅ 간격 추가 */
                display: block;
                margin-left: auto;
                margin-right: auto;
            }

            .custom-select-wrapper {
                display: inline-block;
                position: relative;
                margin-bottom: 12px;
                /* ✅ 간격 추가 */
            }

            .custom-select {
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                padding: 10px 14px;
                font-size: 16px;
                border-radius: 8px;
                border: 1px solid #aaa;
                background-color: #f9f9f9;
                background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20viewBox='0%200%204%205'%3E%3Cpath%20fill='gray'%20d='M2%200L0%202h4L2%200z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 10px center;
                background-size: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .custom-select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            }

            .action-button {
                padding: 10px 20px;
                font-size: 16px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                margin-top: 10px;
                transition: background-color 0.3s ease;
            }

            .action-button:hover {
                background-color: #0056b3;
            }

            .clickable {
                color: #007bff;
                cursor: pointer;
                text-decoration: underline;
            }

            .report-detail {
                margin: 20px auto;
                padding: 20px;
                max-width: 600px;
                text-align: center;
                background-color: #f9f9f9;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }


            .filter-wrapper {
                margin-bottom: 15px;
                text-align: right;
                width: 90%;
                max-width: 1000px;
                margin-left: auto;
                margin-right: auto;
            }

            .report-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
            }

            .slider-control {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
            }

            #limitSlider {
                width: 120px;
            }

            .inquiry-controls {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 16px;
                margin-bottom: 10px;
            }

            .inquiry-controls label {
                font-weight: bold;
                font-size: 14px;
            }

            .inquiry-controls select {
                padding: 4px 8px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .inquiry-controls input[type="range"] {
                width: 140px;
                height: 6px;
                background: #ddd;
                border-radius: 4px;
                outline: none;
                cursor: pointer;
                accent-color: #007bff;
            }

            .no-comments {
                color: #888;
                font-style: italic;
                margin-left: 10px;
            }

            .comment-list {
                list-style: none;
                padding: 16px;
                margin: 0;
                background-color: #fefefe;
                border: 1px solid #ddd;
                border-radius: 10px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            }

            .comment-item {
                margin-bottom: 18px;
            }

            .comment-item:last-child {
                margin-bottom: 0;
            }

            .comment-nickname {
                font-size: 17px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 4px;
            }

            .comment-text {
                font-size: 18px;
                color: #333;
                line-height: 1.6;
                padding-left: 10px;
            }

            .no-comments {
                padding: 12px;
                font-size: 16px;
                font-style: italic;
                color: #888;
                text-align: center;
            }
        </style>
    </head>

    <body>
    <%@ include file="components/header.jsp" %>
        <div id="adminApp">

                <div class="admin-info">
                    <p><strong>관리자:</strong> {{ name }} ({{ nickname }})</p>
                    <p>
                        <strong>ID:</strong> {{ id }} /
                        <strong>포인트:</strong> {{ point }} /
                        <strong>권한:</strong> {{ gradeLabel() }}
                    </p>
                </div>

                <div class="tab-buttons">
                    <button @click="activeTab = 'inquiry'">문의사항 답변</button>
                    <button @click="activeTab = 'report'">신고 관리기능</button>
                </div>

                <!-- 문의사항 답변 -->
                <div v-if="activeTab === 'inquiry'" class="panel">
                    <h3>🎀 문의사항 답변</h3>

                    <!--  필터 & 슬라이더  -->
                    <div v-if="!selectedInquiry" class="inquiry-controls">
                        <div class="filter-group">
                            <label>답변여부 : </label>
                            <select v-model="replyStatusFilter">
                                <option value="">전체</option>
                                <option value="완료">답변완료</option>
                                <option value="미작성">답변미작성</option>
                            </select>
                        </div>
                        <div class="slider-group">
                            <label>표시 개수 : {{ inquiryDisplayLimit }}개</label>
                            <input type="range" min="5" max="15" step="5" v-model="inquiryDisplayLimit" />
                        </div>
                    </div>
                    <!-- 문의 리스트 -->
                    <table v-if="!selectedInquiry">
                        <tr>
                            <th style="text-align: center;">제목</th>
                            <th style="text-align: center;">신고자</th>
                            <th style="text-align: center;">등록일</th>
                            <th style="text-align: center;">답변</th>
                            <th style="text-align: center;">답변여부</th>
                        </tr>
                        <tr v-for="item in getFilteredInquiries()" :key="item.boardNo">
                            <td style="text-align: center;">
                                <button class="link-button" @click="selectInquiry(item)">
                                    {{ item.title }}
                                </button>
                            </td>
                            <td style="text-align: center;">{{ item.userId }}</td>
                            <td style="text-align: center;">{{ item.cdatetime }}</td>
                            <td style="text-align: center;">
                                <button @click="reply(item)">답변하기</button>
                            </td>
                            <td style="text-align: center;">
                                <span class="reply-status">
                                    {{ item.hasAdminReply ? '답변완료' : '답변미작성' }}
                                </span>
                            </td>
                        </tr>


                        <!-- 메신저  댓글창 -->
                        <div v-if="replyTarget" class="chat-popup">
                            <div class="chat-header">
                                <span>💬 {{ replyTarget.userId }}에게 답변</span>
                                <button class="close-btn" @click="cancelReply">×</button>
                            </div>
                            <div class="chat-body">
                                <textarea v-model="replyContent" placeholder="댓글을 입력하세요"></textarea>
                                <button class="send-btn" @click="submitReply">등록</button>
                            </div>
                        </div>



                    </table>

                    <!-- 문의 상세 -->
                    <div v-else class="inquiry-detail">
                        <div class="detail-header">
                            <h4>{{ selectedInquiry.title }}</h4>
                            <button class="back-btn" @click="selectedInquiry = null">📁 목록으로 돌아가기</button>
                        </div>



                        <p><strong>😀 작성자:</strong> {{ selectedInquiry.userId }}</p>
                        <p><strong>📆 등록일:</strong> {{ selectedInquiry.cdatetime }}</p>
                        <p><strong>💬 내용:</strong></p>
                        <p>{{ selectedInquiry.contents }}</p>

                        <hr>

                        <!-- 댓글 목록 -->
                        <div v-if="selectedInquiry.comments && selectedInquiry.comments.length">
                            <h5>💬 댓글</h5>
                            <div v-for="mainboard in selectedInquiry.comments" :key="mainboard.commentNo"
                                class="comment-box">
                                <p>
                                    <strong>{{ mainboard.nickName || mainboard.nickname }}</strong>
                                    <span class="comment-date">{{ mainboard.cdatetime }}</span>

                                    <button class="delete-btn" @click="deleteComment(mainboard.commentNo)">🗑️
                                        삭제</button>
                                </p>
                                <p>{{ mainboard.contents }}</p>
                            </div>
                        </div>
                        <div v-else>
                            <p>댓글이 없습니다.</p>
                        </div>

                    </div>

                </div>

                <!-- 신고 관리기능 -->
                <div v-if="activeTab === 'report'" class="panel">
                    <h3>🚔 신고 관리기능</h3>
                    <div class="tab-buttons">
                        <button @click="switchTab('posts')">신고 게시글</button>
                        <button @click="switchTab('badUsers')">불량 유저</button>
                        <button @click="switchTab('block')">유저 제한</button>
                        <button @click="switchTab('unblock')">제한 해제</button>
                    </div>
                    <!-- 신고 게시글 -->
                    <div v-if="reportTab === 'posts'" class="unblock-section">
                        <h4>📢 신고 목록</h4>
                        <div class="slider-control">
                            <label for="limitSlider">표시 개수: {{ reportDisplayLimit }}개</label>
                            <input id="limitSlider" type="range" min="5" max="15" step="5"
                                v-model="reportDisplayLimit" />
                        </div>
                        <div class="filter-wrapper">
                            <label for="reportTypeFilter">신고유형 필터 : </label>
                            <select v-model="reportTypeFilter" id="reportTypeFilter" class="custom-select">
                                <option value="">전체</option>
                                <option value="E">오류 제보</option>
                                <option value="I">불편 사항</option>
                                <option value="S">사기 신고</option>
                            </select>

                        </div>
                        <table class="styled-table">
                            <tr>
                                <th>신고번호</th>
                                <th>게시글번호</th>
                                <th>신고유형</th>
                                <th>신고자</th>
                                <th>댓글번호</th>
                            </tr>
                            <tr v-for="report in getFilteredReports()" :key="report.REPORTNUM">
                                <td>{{ report.REPORTNUM }}</td>
                                <td>
                                    <span class="clickable" @click="selectBoard(report.BOARDNO)">
                                        {{ report.BOARDNO || '-' }}
                                    </span>
                                </td>

                                <td>{{ convertReportType(report.REPORT_TYPE) }}</td>
                                <td>
                                    <span class="clickable" @click="selectReport(report)">
                                        {{ report.reported_user_id }}
                                    </span>
                                </td>
                                <td>{{ report.COMMENTNO || '-' }}</td>
                            </tr>
                        </table>
                        <div v-if="selectedBoard" class="board-detail">
                            <h5>📝 게시글 상세 정보</h5>
                            <p><strong>제목:</strong> {{ selectedBoard.TITLE }}</p>
                            <p><strong>내용:</strong> {{ selectedBoard.CONTENTS }}</p>

                            <h3>💬 댓글 목록</h3>
                            <ul v-if="boardComments && boardComments.length > 0" class="comment-list">

                                <li v-for="comment in boardComments" :key="comment.COMMENTNO" class="comment-item">
                                    <div class="comment-content">
                                        <div class="comment-nickname">{{ comment.userId }}</div>
                                        <div class="comment-text">{{ comment.contents }}</div>
                                    </div>
                                </li>
                            </ul>
                            <p v-else class="no-comments">댓글이 없습니다.</p>


                            <button class="action-button" @click="selectedBoard = null; boardComments = []">닫기</button>
                        </div>



                        <!-- 신고내용 상세 내용 표시 -->
                        <div v-if="selectedReport" class="report-detail">
                            <h5>📌 신고 상세 정보</h5>
                            <p><strong>신고자 ID:</strong> {{ selectedReport.reported_user_id }}</p>
                            <p><strong>닉네임:</strong> {{ selectedReport.reported_nickname }}</p>
                            <p><strong>상태:</strong> {{ selectedReport.reported_status }}</p>
                            <p><strong>신고내용:</strong> {{ selectedReport.CONTENT }}</p>
                            <button class="action-button" @click="selectedReport = null">닫기</button>
                        </div>
                    </div>
                    <div v-if="reportTab === 'badUsers'" style="text-align: center;">
                        <h4>불량 유저</h4>
                        <table style="margin: 0 auto;">
                            <tr>
                                <th>유저ID</th>
                                <th>이름</th>
                                <th>상태</th>
                            </tr>
                            <tr v-for="user in badUsers.filter(u => u.STATUS === 'B')" :key="user.USERID">
                                <td>{{ user.USERID }}</td>
                                <td>{{ user.NAME }}</td>
                                <td>{{ user.STATUS === 'B' ? '제한' : user.STATUS }}</td>
                            </tr>

                        </table>
                    </div>
                    <!-- 유저 제한 -->
                    <div v-if="reportTab === 'block'" class="unblock-section">
                        <h4>유저 제한</h4>
                        <input v-model="targetUserId" placeholder="유저 ID 입력" class="input-box" />
                        <button @click="blockUser" class="action-button">제한하기</button>
                    </div>
                    <!-- 제한 해제 -->
                    <div v-if="reportTab === 'unblock'" class="unblock-section">
                        <h4>제한 해제</h4>
                        <input v-model="targetUserId" placeholder="유저 ID 입력" class="input-box" />

                        <div class="custom-select-wrapper">
                            <select v-model="selectedStatus" class="custom-select">
                                <option disabled value="">상태 선택</option>
                                <option value="U">😀 (유저)</option>
                                <option value="A">🔑 (어드민)</option>
                                <option value="S">💎 (구독자)</option>
                            </select>
                        </div>

                        <button @click="unblockUser" class="action-button">해제하기</button>
                    </div>

                </div>
                <%@ include file="components/footer.jsp" %>
        </div>
        <script>
            const adminApp = Vue.createApp({

                data() {
                    return {
                        id: "${sessionId}", // 아이디
                        status: "${sessionStatus}", // 등급
                        nickname: "${sessionNickname}", // 닉네임
                        name: "${sessionName}", // 이름
                        point: "${sessionPoint}", //포인트
                        activeTab: 'inquiry',
                        reportTab: 'posts',
                        inquiries: [],
                        selectedInquiry: null,
                        reportList: [],
                        badUsers: [],
                        targetUserId: '',
                        replyTarget: null,
                        replyContent: '',
                        comments: [], // 게시글
                        selectedStatus: '', // 유저 status 
                        selectedReport: null, // 상세내용
                        reportTypeFilter: '', //신고 유형 필터
                        reportDisplayLimit: 5,  // 게시글 갯수 카운터
                        replyStatusFilter: '', // '완료', '미작성', ''(전체)
                        inquiryDisplayLimit: 5, // 문의게시판 갯수 카운터
                        selectedBoard: null,
                        boardComments: [],
                    };
                },
                mounted() {
                    this.fetchInquiries();
                },
                methods: {
                    gradeLabel() {
                        switch (this.status) {
                            case 'A': return '👑 ';
                            case 'S': return '✨ ';
                            case 'U': return '🙂 ';
                            default: return '❓ ';
                        }
                    },
                    selectBoard(boardNo) {
                        $.ajax({
                            url: "/board-detail.dox",
                            type: "POST",
                            dataType: "json",
                            data: { boardNo: boardNo },
                            success: (res) => {
                                console.log("댓글 응답:", res.comments);
                                this.selectedBoard = res.board;
                                this.boardComments = res.comments || [];
                                this.selectedReport = null; // 신고 상세 닫기
                            },
                            error: () => {
                                alert("게시글 상세 정보를 불러오지 못했습니다.");
                            }
                        });

                    },

                    switchTab(tabName) {
                        this.reportTab = tabName;

                        if (tabName === 'badUsers') {
                            this.fetchBadUsers();
                        } else if (tabName === 'posts') {
                            this.fetchReportList(); // ✅ 신고 게시글 불러오기
                        }
                    },
                    selectReport(report) {
                        this.selectedReport = report;
                    },
                    convertReportType(type) {
                        switch (type) {
                            case 'E': return '오류 제보';
                            case 'I': return '불편 사항';
                            case 'S': return '사기 신고';
                            default: return type;
                        }
                    },
                    getFilteredReports() {
                        let filtered = this.reportList;

                        if (this.reportTypeFilter) {
                            filtered = filtered.filter(r => r.REPORT_TYPE === this.reportTypeFilter);
                        }

                        return filtered.slice(0, this.reportDisplayLimit);
                    },

                    //---------------------문의사항 댓글 -------------------------
                    getFilteredInquiries() {
                        let filtered = this.inquiries;

                        if (this.replyStatusFilter === '완료') {
                            filtered = filtered.filter(i => i.hasAdminReply);
                        } else if (this.replyStatusFilter === '미작성') {
                            filtered = filtered.filter(i => !i.hasAdminReply);
                        }

                        return filtered.slice(0, this.inquiryDisplayLimit);
                    },
                    hasAdminReply(boardNo) {
                        const inquiry = this.inquiries.find(i => i.boardNo === boardNo);
                        if (!inquiry || !inquiry.comments) return false;
                        return inquiry.comments.some(c => c.userId === 'admin01');
                    },
                    reply(item) {
                        this.replyTarget = item;
                        this.replyContent = '';
                    },
                    cancelReply() {
                        this.replyTarget = null;
                        this.replyContent = '';
                    },
                    submitReply() {
                        const target = this.replyTarget;

                        const payload = {
                            boardNo: target?.boardNo,
                            userId: this.id,
                            nickname: this.nickname,
                            contents: this.replyContent
                        };

                        $.post("/api/comment/write", payload, () => {
                            alert("댓글이 등록되었습니다.");

                            if (target) {
                                $.get("/api/comment/list", { boardNo: target.boardNo }, commentRes => {
                                    target.comments = commentRes;
                                    target.hasAdminReply = commentRes.some(c => c.userId === 'admin01');
                                    this.cancelReply();
                                });
                            } else {
                                this.cancelReply();
                            }
                        });
                    }

                    ,
                    //-----------------------------------------------------------

                    fetchInquiries() {
                        $.get("/api/inquiries", res => {
                            this.inquiries = res;
                            // 각 문의글에 대해 댓글 불러오기
                            this.inquiries.forEach(inquiry => {
                                $.get("/api/comment/list", { boardNo: inquiry.boardNo }, commentRes => {
                                    inquiry.comments = commentRes;
                                    inquiry.hasAdminReply = commentRes.some(c => c.userId === 'admin01');
                                });
                            });
                        });
                    },

                    selectInquiry(item) {
                        let self = this;
                        self.selectedInquiry = item;

                        let param = {
                            boardNo: item.boardNo
                        };

                        $.ajax({
                            url: "/api/comment/list",
                            dataType: "json",
                            type: "GET",
                            data: param,
                            success: function (data) {
                                //  댓글 저장
                                item.comments = data;

                                //  관리자 댓글 여부 저장
                                item.hasAdminReply = data.some(c => c.userId === 'admin01');

                                // 선택된 문의글에도 댓글 저장
                                self.selectedInquiry.comments = data;

                            },
                            error: function () {
                                alert("댓글을 불러오는 데 실패했습니다.");
                                self.selectedInquiry.comments = [];
                            }
                        });
                    },

                    blockUser() {
                        let self = this;
                        if (!self.targetUserId) {
                            alert("유저 ID를 입력해주세요.");
                            return;
                        }

                        $.ajax({
                            url: "/user-block.dox",
                            type: "POST",
                            dataType: "json",
                            data: { userId: self.targetUserId },
                            success: function (res) {
                                alert("유저가 제한되었습니다.");
                                self.targetUserId = '';
                                self.fetchBadUsers(); // 불량 유저 목록 갱신
                            },
                            error: function () {
                                alert("제한 처리에 실패했습니다.");
                            }
                        });
                    },

                    fetchBadUsers() {
                        let self = this;
                        $.ajax({
                            url: "/bad-users.dox",
                            type: "GET",
                            dataType: "json",
                            success: function (res) {
                                console.log("불량 유저 응답:", res);
                                self.badUsers = res.badUsers || [];
                            },
                            error: function () {
                                alert("불량 유저 목록을 불러오는 데 실패했습니다.");
                            }
                        });
                    },

                    deleteComment(commentNo) {
                        let self = this;
                        if (!confirm("정말 삭제하시겠습니까?")) return;

                        $.ajax({
                            url: "/comment-delete.dox",
                            type: "POST",
                            dataType: "json",
                            data: { commentNo: commentNo },
                            success: function (res) {
                                alert("댓글이 삭제되었습니다.");
                                self.selectInquiry(self.selectedInquiry); // 댓글 목록 다시 불러오기
                            },
                            error: function () {
                                alert("댓글 삭제에 실패했습니다.");
                            }
                        });
                    },
                    unblockUser() {
                        if (!this.targetUserId || !this.selectedStatus) {
                            alert("유저 ID와 상태를 모두 입력해주세요.");
                            return;
                        }

                        const payload = {
                            userId: this.targetUserId,
                            status: this.selectedStatus
                        };

                        $.ajax({
                            url: "/user-unblock.dox",
                            type: "POST",
                            dataType: "json",
                            data: payload,
                            success: () => {
                                alert("유저 상태가 변경되었습니다.");
                                this.targetUserId = '';
                                this.selectedStatus = '';
                                this.fetchBadUsers(); // 목록 갱신
                            },
                            error: () => {
                                alert("해제 처리에 실패했습니다.");
                            }
                        });
                    },
                    fetchReportList() {
                        $.ajax({
                            url: "/report-list.dox",
                            type: "POST",
                            dataType: "json",
                            success: (res) => {
                                this.reportList = res.reportList;
                                this.reportList.forEach((r, i) => {
                                    console.log(`신고 ${i}번 → 신고자:`, r.report_user_id || r.REPORT_USER_ID);
                                });
                            },
                            error: () => {
                                alert("신고 목록을 불러오지 못했습니다.");
                            }
                        });
                    },
                }

            });

            adminApp.mount('#adminApp');
        </script>
    </body>

    </html>