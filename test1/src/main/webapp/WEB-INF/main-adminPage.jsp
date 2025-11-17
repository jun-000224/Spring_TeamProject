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

            .pagination {
                text-align: center;
                margin-top: 16px;
            }

            .page-btn {
                margin: 0 4px;
                padding: 8px 14px;
                font-size: 14px;
                border: 1px solid #ccc;
                background-color: #fff;
                color: #333;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .page-btn:hover:not(:disabled) {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .page-btn:disabled {
                background-color: #eee;
                color: #aaa;
                cursor: not-allowed;
            }

            .page-btn.active {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                border-color: #007bff;
            }

            .user-header-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
            }

            .user-actions-inline {
                display: flex;
                gap: 6px;
                align-items: center;
                flex-wrap: wrap;
            }

            .input-mini,
            .select-mini,
            .btn-mini {
                height: 28px;
                font-size: 13px;
                padding: 2px 8px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }

            .select-mini {
                min-width: 80px;
            }

            .btn-mini {
                background-color: #007bff;
                color: white;
                border: none;
                cursor: pointer;
            }

            .btn-mini:hover {
                background-color: #0056b3;
            }

            .pagination {
                margin-top: 20px;
                text-align: center;
            }

            .pagination button {
                margin: 0 4px;
                padding: 6px 12px;
                border: 1px solid #ccc;
                background-color: #f9f9f9;
                color: #333;
                cursor: pointer;
                border-radius: 4px;
                font-size: 14px;
                transition: background-color 0.2s ease;
            }

            .pagination button:hover:not(:disabled) {
                background-color: #e0e0e0;
            }

            .pagination button.active {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                border-color: #007bff;
            }

            .pagination button:disabled {
                background-color: #eee;
                color: #aaa;
                cursor: not-allowed;
                border-color: #ddd;
            }

            .select-mini {
                padding: 4px 8px;
                font-size: 13px;
                border-radius: 4px;
                border: 1px solid #ccc;
                background-color: #fff;
            }

            .status-filter {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .status-filter label {
                font-weight: bold;

                font-size: 14px;
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
                            <th style="text-align: center;">사용자</th>
                            <th style="text-align: center;">등록일</th>
                            <th style="text-align: center;">답변</th>
                            <th style="text-align: center;">답변여부</th>
                        </tr>
                        <tr v-for="item in getPaginatedInquiries()" :key="item.boardNo">
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
                    </table>

                    <!-- 페이징 버튼 -->
                    <div class="pagination" v-if="Array.isArray(users) && users.length > 0">

                        <button class="page-btn" :disabled="currentInquiryPage === 1"
                            @click="goToInquiryPage(currentInquiryPage - 1)">
                            ◀ 이전
                        </button>

                        <button v-for="page in getInquiryPageNumbers()" :key="page" @click="goToInquiryPage(page)"
                            :class="['page-btn', { active: page === currentInquiryPage }]">
                            {{ page }}
                        </button>

                        <button class="page-btn" :disabled="currentInquiryPage === getTotalInquiryPages()"
                            @click="goToInquiryPage(currentInquiryPage + 1)">
                            다음 ▶
                        </button>
                    </div>




                    <!-- 메신저 댓글창 -->
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

                    <!-- 문의 상세 -->
                    <div v-else-if="selectedInquiry" class="inquiry-detail">
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
                        <button @click="switchTab('users')">유저 관리</button>
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
                                <th>신고 번호</th>
                                <th>게시글 번호</th>
                                <th>신고 유형</th>
                                <th>신고 대상</th>
                                <th>댓글 번호</th>
                            </tr>
                            <tr v-for="report in getFilteredReports()" :key="report.REPORTNUM">
                                <td>{{ report.REPORTNUM }}</td>
                                <td>
                                    <span class="" @click="selectBoard(report.BOARDNO)">
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
                        <div class="pagination">
                            <button @click="goToPrevReportPage" :disabled="currentReportPage === 1">
                                ◀
                            </button>

                            <button v-for="page in getReportPageGroup()" :key="page" @click="currentReportPage = page"
                                :class="{ active: currentReportPage === page }">
                                {{ page }}
                            </button>

                            <button @click="goToNextReportPage" :disabled="currentReportPage === getReportPageCount()">
                                ▶
                            </button>
                        </div>
                    </div>


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
                        <p><strong>ID:</strong> {{ selectedReport.reported_user_id }}</p>
                        <p><strong>닉네임:</strong> {{ selectedReport.reported_nickname }}</p>
                        <p><strong>상태:</strong> {{ selectedReport.reported_status }}</p>
                        <p><strong>신고내용:</strong> {{ selectedReport.CONTENT }}</p>
                        <button class="action-button" @click="selectedReport = null">닫기</button>
                    </div>
                </div>
                <!-- 유저 관리 통합 영역 -->
                <div v-if="reportTab === 'users'" class="unblock-section">
                    <div class="user-management">
                        <h4>👥 유저 관리</h4>
                        <div class="slider-control"
                            style="display: flex; justify-content: space-between; align-items: center;">
                            <!-- 왼쪽: 표시 개수 슬라이더 -->
                            <div>
                                <label for="userLimitSlider">표시 개수: {{ userDisplayLimit }}명</label>
                                <input id="userLimitSlider" type="range" min="5" max="15" step="5"
                                    v-model="userDisplayLimit" />
                            </div>

                            <!-- 오른쪽: 상태 필터 -->
                            <div class="status-filter">
                                <label for="statusFilter">상태별 보기:</label>
                                <select v-model="userStatusFilter" id="statusFilter" class="select-mini">
                                    <option value="">전체</option>
                                    <option value="A">🔑 어드민</option>
                                    <option value="S">💎 구독자</option>
                                    <option value="U">😀 일반</option>
                                    <option value="B">🚫 제한</option>
                                    <option value="D">❌ 탈퇴</option>
                                </select>
                            </div>
                        </div>

                        <table class="styled-table">
                            <thead>
                                <tr>
                                    <th>유저ID</th>
                                    <th>이름</th>
                                    <th>닉네임</th>
                                    <th>전화번호</th>
                                    <th>현재 상태</th>
                                    <th>상태 변경</th>
                                    <th>변경</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="user in getPaginatedUsers()" :key="user.USERID">
                                    <td>{{ user.USERID }}</td>
                                    <td>{{ user.NAME }}</td>
                                    <td>{{ user.NICKNAME || '-' }}</td>
                                    <td>{{ user.PHONE }}</td>
                                    <td>{{ convertStatus(user.STATUS) }}</td>
                                    <td>
                                        <select v-model="user.newStatus" class="select-mini">
                                            <option value="">선택</option>
                                            <option value="U">😀 유저</option>
                                            <option value="A">🔑 어드민</option>
                                            <option value="S">💎 구독자</option>
                                            <option value="B">🚫 제한</option>
                                            <option value="D">❌ 탈퇴</option>
                                        </select>

                                    </td>
                                    <td>
                                        <button @click="updateUserStatus(user)" class="btn-mini">변경</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="pagination" v-if="users.length > 0">
                            <button @click="goToUserPage(currentUserPage - 1)" :disabled="currentUserPage === 1">
                                ◀ 이전
                            </button>

                            <button v-for="page in getUserPageNumbers()" :key="page" @click="goToUserPage(page)"
                                :class="{ active: currentUserPage === page }">
                                {{ page }}
                            </button>

                            <button @click="goToUserPage(currentUserPage + 1)"
                                :disabled="currentUserPage === getTotalUserPages()">
                                다음 ▶
                            </button>
                        </div>
                    </div>



                </div>
            </div>
            <%@ include file="components/footer.jsp" %>
    </body>

    </html>
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
                    currentInquiryPage: 1, //페이징
                    inquiriesPerPage: 4, //페이징 게시글 4개
                    users: [],
                    currentReportPage: 1,
                    reportsPerPage: 5,
                    reportPageGroupSize: 5,
                    currentUserPage: 1,
                    userDisplayLimit: 5,
                    usersPerPage: 5,
                    userStatusFilter: '',

                };
            },
            mounted() {
                this.fetchReportList();
                this.fetchInquiries();
                this.fetchUsers();
            },
            watch: {
                userDisplayLimit() {
                    this.currentUserPage = 1;
                },
                users() {
                    this.currentUserPage = 1;
                },
                userStatusFilter() {
                    this.currentUserPage = 1;
                }
            }
            ,
            computed: {
                filteredUsers() {
                    return this.userStatusFilter
                        ? this.users.filter(u => u.STATUS === this.userStatusFilter)
                        : this.users;
                },
                totalUserPages() {
                    return Math.ceil(this.filteredUsers.length / this.userDisplayLimit);
                },
                userPageList() {
                    const start = (this.pageGroup - 1) * this.pagesPerGroup + 1;
                    const end = Math.min(start + this.pagesPerGroup - 1, this.totalUserPages);
                    return Array.from({ length: end - start + 1 }, (_, i) => start + i);
                }
            }
            ,
            methods: {

                getPaginatedUsers() {
                    const filtered = this.filteredUsers;

                    const totalPages = Math.ceil(filtered.length / this.userDisplayLimit);
                    if (this.currentUserPage > totalPages) {
                        this.currentUserPage = totalPages || 1;
                    }

                    const start = (this.currentUserPage - 1) * this.userDisplayLimit;
                    const end = start + this.userDisplayLimit;

                    return filtered.slice(start, end);
                },

                getTotalUserPages() {
                    const usersArray = Array.isArray(this.users) ? this.users : [];

                    const filtered = this.userStatusFilter
                        ? usersArray.filter(u => u.STATUS === this.userStatusFilter)
                        : usersArray;

                    return Math.ceil(filtered.length / this.userDisplayLimit);
                }
                ,


                getUserPageNumbers() {
                    const total = this.getTotalUserPages();
                    const pages = [];
                    for (let i = 1; i <= total; i++) {
                        pages.push(i);
                    }
                    return pages;
                },

                goToUserPage(page) {
                    this.currentUserPage = page;
                },

                fetchUsers() {
                    $.ajax({
                        url: '/user-list.dox',
                        method: 'GET',
                        success: (res) => {
                            const list = res.userList || res.users || [];
                            this.users = Array.isArray(list) ? list : [];
                        },
                        error: () => {
                            alert('유저 목록을 불러오지 못했습니다.');
                            this.users = [];
                        }
                    });
                },
                convertStatus(code) {
                    const map = {
                        U: '😀 유저',
                        A: '🔑 어드민',
                        S: '💎 구독자',
                        B: '🚫 제한',
                        D: '❌ 탈퇴'
                    };
                    return map[code] || '❓ 알 수 없음';
                },
                updateUserStatus(user) {
                    if (!user.newStatus) {
                        alert('변경할 상태를 선택해주세요.');
                        return;
                    }

                    const userId = user.USER_ID;
                    const newStatus = user.newStatus;

                    $.ajax({
                        url: '/user-status-update.dox',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            userId: user.USERID,
                            status: user.newStatus
                        }),
                        success: () => {
                            alert(user.USERID + '의 상태가 변경되었습니다.');
                            this.users = this.users.map(u =>
                                u.USERID === user.USERID ? { ...u, STATUS: user.newStatus, newStatus: '' } : u
                            );
                        }
                        ,
                        error: () => {
                            alert('서버 오류 발생');
                        }
                    });
                },
                getInquiryPageNumbers() {
                    const total = this.getTotalInquiryPages();
                    const pages = [];
                    for (let i = 1; i <= total; i++) {
                        pages.push(i);
                    }
                    return pages;
                },
                getTotalInquiryPages() {
                    const filtered = this.getFilteredInquiries();
                    return Math.ceil(filtered.length / this.inquiryDisplayLimit);
                },

                getPaginatedInquiries() {
                    const filtered = this.getFilteredInquiries();
                    const start = (this.currentInquiryPage - 1) * this.inquiryDisplayLimit;
                    const end = start + this.inquiryDisplayLimit;
                    return filtered.slice(start, end);
                },
                getTotalInquiryPages() {
                    const filtered = this.getFilteredInquiries();
                    return Math.ceil(filtered.length / this.inquiryDisplayLimit);
                },
                goToInquiryPage(page) {
                    this.currentInquiryPage = page;
                },
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
                            //console.log("댓글 응답:", res.comments);
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

                    if (tabName === 'users') {
                        this.fetchAllUsers();
                    }
                },
                fetchAllUsers() {
                    $.ajax({
                        url: '/user-list.dox',
                        method: 'GET',
                        success: (res) => {
                            //console.log("유저 응답:", res);


                            const list = res.userList || res.users || [];


                            if (Array.isArray(list)) {
                                this.users = list.map(user => ({
                                    USERID: user.USERID,
                                    NAME: user.NAME,
                                    NICKNAME: user.NICKNAME,
                                    PHONE: user.PHONE,
                                    STATUS: user.STATUS,
                                    newStatus: ''
                                }));
                            } else {
                                console.warn("userList가 배열이 아닙니다:", list);
                                this.users = [];
                            }
                        },
                        error: () => {
                            alert('유저 목록을 불러오지 못했습니다.');
                            this.users = [];
                        }
                    });
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
                    const filtered = this.reportList.filter(report => {
                        return this.reportTypeFilter === '' || report.REPORT_TYPE === this.reportTypeFilter;
                    });

                    const start = (this.currentReportPage - 1) * this.reportDisplayLimit;
                    const end = start + this.reportDisplayLimit;
                    return filtered.slice(start, end);
                },
                getReportPageCount() {
                    const filtered = this.reportList.filter(report => {
                        return this.reportTypeFilter === '' || report.REPORT_TYPE === this.reportTypeFilter;
                    });
                    return Math.ceil(filtered.length / this.reportDisplayLimit);
                },
                getReportPageGroup() {
                    const totalPages = this.getReportPageCount();
                    const groupSize = this.reportPageGroupSize;
                    const currentGroup = Math.floor((this.currentReportPage - 1) / groupSize);
                    const start = currentGroup * groupSize + 1;
                    const end = Math.min(start + groupSize - 1, totalPages);

                    const pages = [];
                    for (let i = start; i <= end; i++) {
                        pages.push(i);
                    }
                    return pages;
                },
                goToPrevReportPage() {
                    if (this.currentReportPage > 1) {
                        this.currentReportPage--;
                    }
                },
                goToNextReportPage() {
                    const totalPages = this.getReportPageCount();
                    if (this.currentReportPage < totalPages) {
                        this.currentReportPage++;
                    }
                },


                //---------------------문의사항 댓글 -------------------------
                getFilteredInquiries() {
                    let filtered = this.inquiries;

                    if (this.replyStatusFilter === '완료') {
                        filtered = filtered.filter(i => i.hasAdminReply);
                    } else if (this.replyStatusFilter === '미작성') {
                        filtered = filtered.filter(i => !i.hasAdminReply);
                    }

                    return filtered;
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
                },
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
                            //console.log("불량 유저 응답:", res);
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
                            this.fetchBadUsers();     //  불량 유저 목록 갱신
                            this.fetchAllUsers();     //  전체 유저 목록 다시 불러오기
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
                                //console.log(`신고 ${i}번 → 신고자:`, r.report_user_id || r.REPORT_USER_ID);
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