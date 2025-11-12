<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>나의게시글/답글</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            .tab-buttons {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .tab-buttons button {
                padding: 8px 16px;
                border: 1px solid #ccc;
                background: #f4f4f4;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
                transition: background 0.3s ease;
            }

            .tab-buttons button.active {
                background: #4a90e2;
                color: white;
                border-color: #4a90e2;
            }



            .card-grid {
                display: grid;
                grid-template-columns: repeat(3, 300px);

                gap: 24px;
                justify-content: center;

                padding: 20px;
                box-sizing: border-box;
                width: 100%;
                margin: 0 auto;

                flex-direction: row;
                overflow-x: auto;
                scroll-snap-type: x mandatory;
                padding-bottom: 10px;
            }

            .card {
                background: rgba(255, 255, 255, 0.7);
                backdrop-filter: blur(4px);

                border-radius: 16px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                padding: 20px;
                cursor: pointer;
                transition: transform 0.3s ease;
                min-height: 200px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                min-width: 280px;
                flex-shrink: 0;
                scroll-snap-align: start;
                backdrop-filter: blur(4px);
                -webkit-backdrop-filter: blur(4px);
            }


            .card:hover {
                transform: translateY(-4px);
            }

            .card h4 {
                margin: 0;
                font-size: 18px;
                color: #333;
            }

            .card .date {
                font-size: 13px;
                color: #888;
                margin-top: 4px;
            }

            .card .preview {
                margin-top: 12px;
                color: #555;
            }

            /* 모달 오버레이 */
            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 999;
            }

            /* 모달 카드 */
            .modal-card {
                background: #fff;
                border-radius: 16px;
                width: 640px;
                max-height: 80vh;
                overflow-y: auto;
                padding: 32px;
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
                animation: fadeIn 0.3s ease;
                font-family: 'Segoe UI', 'Noto Sans KR', sans-serif;
            }

            /* 글씨체 동일 */
            input,
            textarea {
                font-family: inherit;

                font-size: 14px;
            }

            /* 애니메이션 */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.95);
                }

                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            /* 헤더 */
            .modal-header {
                display: flex;
                flex-direction: column;
                gap: 4px;
                margin-bottom: 24px;
            }

            .modal-body {
                font-size: 16px;
                line-height: 1.6;
                color: #444;
            }

            .post-content {
                margin-bottom: 24px;
            }

            .comment-content {
                background: #f0f8ff;
                padding: 12px;
                border-radius: 8px;
                margin-top: 16px;
            }

            .modal-header h2 {
                font-size: 24px;
                font-weight: 700;
                color: #333;
                margin-bottom: 8px;
                border-bottom: 2px solid #4a90e2;
                padding-bottom: 4px;
            }

            .meta-info {
                font-size: 14px;
                color: #666;
                display: flex;
                justify-content: space-between;
            }

            /* 본문 */
            .content {
                font-size: 16px;
                line-height: 1.7;
                color: #333;
                margin-bottom: 24px;
            }

            .content p {
                margin: 0;
            }

            /* 답글 */
            .reply {
                margin-top: 24px;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }

            .reply h3 {
                font-size: 16px;
                font-weight: 500;
                margin-bottom: 8px;
                color: #555;
            }

            .reply p {
                font-size: 15px;
                color: #444;
            }

            /* 댓글 리스트 */
            .reply-list {
                margin-top: 32px;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }

            .reply-list h3 {
                font-size: 16px;
                font-weight: 500;
                margin-bottom: 12px;
                color: #555;
            }

            .reply-item {
                background: #f9f9f9;
                border-left: 4px solid #4a90e2;
                padding: 12px;
                margin-bottom: 12px;
                border-radius: 8px;
            }

            .reply-content {
                font-size: 15px;
                color: #333;
                margin-bottom: 6px;
            }

            .reply-meta {
                font-size: 13px;
                color: #888;
                text-align: right;
            }

            /* 버튼 영역 */
            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 32px;
            }

            .close-btn {
                background: #4a90e2;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background 0.2s ease;
            }

            .close-btn:hover {
                background: #357ac9;
            }

            .modal-footer .btn {
                background: #4a90e2;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 500;
                transition: background 0.2s ease;
            }

            .modal-footer .btn:hover {
                background: #357ac9;
            }

            .mypage-container {
                display: flex;
                flex-direction: column;
                align-items: center;

                justify-content: center;

                text-align: center;
                padding: 40px 20px;
            }

            .tab-buttons {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }

            .chat-style {
                display: flex;
                flex-direction: column;
                gap: 12px;
                padding: 10px;
            }

            .chat-input-wrapper {
                background-color: #f5f7fa;
                border-radius: 20px;
                padding: 8px 12px;
                box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
            }

            .chat-input,
            .chat-textarea {
                width: 100%;
                border: none;
                background: transparent;
                font-size: 14px;
                line-height: 1.5;
                resize: none;
                outline: none;
            }

            .chat-textarea {
                min-height: 80px;
                max-height: 200px;
                overflow-y: auto;
            }

            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 16px;
                margin-top: 24px;
                font-family: 'Pretendard', 'Noto Sans KR', sans-serif;
            }

            .page-btn {
                background: linear-gradient(135deg, #6c5ce7, #a29bfe);
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 30px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 10px rgba(108, 92, 231, 0.2);
            }

            .page-btn:hover:not(:disabled) {
                transform: translateY(-2px);
                box-shadow: 0 6px 14px rgba(108, 92, 231, 0.3);
            }

            .page-btn:disabled {
                opacity: 0.4;
                cursor: not-allowed;
            }

            .page-indicator {
                font-size: 15px;
                font-weight: 500;
                color: #555;
            }

            .tab-buttons select {
                appearance: none;
                background: linear-gradient(135deg, #6c5ce7, #a29bfe);
                color: white;
                font-size: 15px;
                font-weight: 600;
                padding: 10px 16px;
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(108, 92, 231, 0.3);
                cursor: pointer;
                transition: all 0.3s ease;
                outline: none;
                text-align: center;
                min-width: 180px;
            }

            .tab-buttons select:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(108, 92, 231, 0.4);
            }

            .tab-buttons select:focus {
                box-shadow: 0 0 0 3px rgba(108, 92, 231, 0.5);
            }

            .tab-buttons option {
                background-color: white;
                color: #333;
                font-weight: 500;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <%@ include file="components/header.jsp" %>

                <div class="mypage-container">
                    <h2>📝 나의 작성글 / 💬 답글</h2>

                    <div class="tab-buttons">
                        <button :class="{ active: activeTab === 'posts' }" @click="switchToPosts">📝 작성글</button>

                        <button :class="{ active: activeTab === 'comments' }" @click="switchToComments">💬 답글</button>
                    </div>
                    <div class="tab-buttons">
                        <select v-model="selectedBoardType" @change="filterPostsByType(); filterCommentsByType();">

                            <option value="">전체 게시판</option>
                            <option value="Q">질문 게시판</option>
                            <option value="F">자유 게시판</option>
                            <option value="SQ">문의 게시판</option>
                            <option v-if="userStatus === 'A'" value="N">공지 게시판</option>

                        </select>
                    </div>

                    <!-- 게시글 카드 -->
                    <div v-if="activeTab === 'posts'" class="card-grid">
                        <div class="card" v-for="post in paginatedPosts" :key="post.BOARDNO" @click="openModal(post)">
                            <div class="card-header">
                                <h4>
                                    {{ post.TITLE || '제목 없음' }}

                                </h4>
                                <p class="date">{{ post.CDATETIME || '날짜 없음' }}
                                    <span style="color: #888; font-size: 14px;">[{{ getBoardTypeLabel(post.TYPE)
                                        }}]</span>

                                </p>
                            </div>
                            <p class="preview">
                                {{ post.CONTENTS ? stripTags(post.CONTENTS).slice(0, 60) + '...' : '내용 없음' }}
                            </p>
                            <p class="nickname">작성자: {{ post.USER_ID || '알 수 없음' }}</p>
                        </div>
                        <p v-if="myPosts.length === 0">작성한 게시글이 없습니다.</p>
                    </div>

                    <!-- 답글 카드 -->
                    <div v-if="activeTab === 'comments'" class="card-grid">
                        <div class="card" v-for="comment in paginatedComments" :key="comment.commentNo"
                            @click="openModal(comment)">
                            <div class="card-header">
                                <h4>
                                    답글
                                </h4>

                                <p class="date">{{ comment.CDATETIME || '날짜 없음' }}

                                    <span style="color: #888; font-size: 14px;">[{{
                                        getBoardTypeLabel(comment.BOARD_TYPE) }}]</span>
                                </p>
                            </div>
                            <p class="preview">
                                {{ comment.COMMENT_CONTENT ? stripTags(comment.COMMENT_CONTENT).slice(0, 60) + '...' :
                                '내용 없음' }}
                            </p>
                            <p class="nickname">작성자: {{ comment.USER_ID || '알 수 없음' }}</p>
                        </div>
                        <p v-if="filteredComments.length === 0">작성한 답글이 없습니다.</p>
                    </div>

                    <!-- 페이징 버튼 -->
                    <div class="pagination" v-if="totalPages > 1">
                        <button class="page-btn" @click="prevPage" :disabled="currentPage === 1"> 이전</button>
                        <span class="page-indicator">{{ currentPage }} / {{ totalPages }}</span>
                        <button class="page-btn" @click="nextPage" :disabled="currentPage === totalPages">다음 </button>
                    </div>





                    <!-- 모달 카드 -->
                    <div v-if="selectedItem" class="modal-overlay" @click.self="closeModal">
                        <div class="modal-card">
                            <!-- 헤더 -->
                            <div class="modal-header">
                                <h2 class="modal-title">
                                    {{ modalType === 'post' ? selectedItem.TITLE : selectedItem.BOARD_TITLE || '제목 없음'
                                    }}

                                </h2>
                                <div class="meta-info">
                                    <span class="date">{{ selectedItem.CDATETIME }}</span>

                                    <span class="author">작성자: {{ selectedItem.USER_ID || '알 수 없음' }}</span>
                                </div>
                            </div>

                            <!-- 본문 -->
                            <div class="modal-body">
                                <div class="post-content"
                                    v-html="modalType === 'post' ? selectedItem.CONTENTS : selectedItem.BOARD_CONTENTS || '게시글 내용 없음'">
                                </div>

                                <!-- 답글 -->
                                <div v-if="modalType === 'comment'" class="comment-content">
                                    <h3>💬 답글</h3>
                                    <p>{{ selectedItem.COMMENT_CONTENT || '답글 없음' }}</p>

                                </div>

                                <!-- 댓글 리스트 -->
                                <div v-if="modalType === 'post'" class="reply-list">
                                    <h3>💬 댓글</h3>
                                    <div v-if="selectedComments.length > 0">
                                        <div class="reply-item" v-for="reply in selectedComments"
                                            :key="reply.commentNo">
                                            <p class="reply-text">{{ reply.contents || '내용 없음' }}</p>
                                            <p class="reply-meta">작성자: {{ reply.userId || '알 수 없음' }} / {{
                                                reply.cdatetime || '날짜 없음' }}</p>
                                        </div>
                                    </div>

                                    <p v-else>댓글이 없습니다.</p>
                                </div>
                            </div>

                            <!-- 푸터 -->
                            <div class="modal-footer">
                                <button class="btn" @click="editItem(selectedItem)">✏️ 수정</button>
                                <button class="btn" @click="deleteItem(selectedItem)">🗑️ 삭제</button>
                                <button class="btn" @click="closeModal">❌ 닫기</button>
                            </div>
                        </div>
                    </div>
                    <div v-if="showEditModal" class="modal-overlay" @click.self="closeModal">
                        <div class="modal-card">
                            <div class="modal-header">
                                <h2 class="modal-title">
                                    {{ modalType === 'post' ? '게시글 수정' : '댓글 수정' }}
                                </h2>
                            </div>

                            <div class="modal-body chat-style">
                                <div v-if="modalType === 'post'" class="chat-input-wrapper">
                                    <input v-model="editForm.title" placeholder="제목" class="chat-input" />
                                </div>
                                <div class="chat-input-wrapper">
                                    <textarea v-model="editForm.contents" placeholder="내용을 입력하세요"
                                        class="chat-textarea"></textarea>
                                </div>
                            </div>


                            <div class="modal-footer">
                                <button class="btn" @click="submitEdit">💾 저장</button>
                                <button class="btn" @click="closeEditModal">❌ 닫기</button>

                            </div>
                        </div>
                    </div>
                </div>
                <br>
                <br>
                <%@ include file="components/footer.jsp" %>
        </div>
    </body>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    activeTab: 'posts',
                    selectedItem: null,
                    userId: "${sessionId}",
                    myPosts: [],
                    myComments: [],
                    selectedComments: [],
                    boardNo: '',
                    title: '',
                    contents: '',
                    showEditModal: false,
                    editForm: {
                        boardNo: '',
                        commentNo: '',
                        title: '',
                        contents: ''
                    },
                    modalType: '',
                    selectedItem: null,
                    currentPage: 1,
                    itemsPerPage: 6,
                    selectedBoardType: '', // 선택된 게시판 타입
                    filteredPosts: [],     // 필터링된 게시글
                    filteredComments: [],
                    myPosts: [],           // 전체 내 게시글
                    userStatus: ''


                };
            },

            computed: {
                paginatedPosts() {
                    const start = (this.currentPage - 1) * this.itemsPerPage;
                    const paginated = this.filteredPosts.slice(start, start + this.itemsPerPage);
                    //console.log(" 페이지 게시글:", paginated);
                    return paginated;
                },
                paginatedComments() {
                    const start = (this.currentPage - 1) * this.itemsPerPage;
                    return this.filteredComments.slice(start, start + this.itemsPerPage);
                },
                totalPages() {
                    return this.activeTab === 'posts'
                        ? Math.ceil(this.filteredPosts.length / this.itemsPerPage)
                        : Math.ceil(this.myComments.length / this.itemsPerPage);
                },


            },
            methods: {
                switchToComments() {
                    this.activeTab = 'comments';
                    this.filterCommentsByType(); 
                },
                switchToPosts() {
                    this.activeTab = 'posts';
                    this.selectedBoardType = '';
                    this.filterPostsByType();    
                },
                getBoardTypeLabel(type) {
                    if (!type || typeof type !== 'string') return '전체게시판';

                    switch (type.trim().toUpperCase()) {
                        case 'Q': return '질문게시판';
                        case 'F': return '자유게시판';
                        case 'SQ': return '문의게시판';
                        case 'N': return '공지게시판';
                        default: return '전체게시판';
                    }
                },
                fetchUserInfo() {
                    $.ajax({
                        url: '/getUserInfo.dox',
                        type: 'POST',
                        data: { userId: this.userId },
                        dataType: 'json',
                        success: (res) => {
                            //console.log(" 로그인한 사용자 상태:", this.userStatus);
                            this.userStatus = res.status;
                        }
                    });
                },
                filterCommentsByType() {
                    const type = this.selectedBoardType?.trim().toUpperCase();

                    if (!type || type === '') {
                        this.filteredComments = this.myComments;
                    } else {
                        this.filteredComments = this.myComments.filter(comment =>
                            comment.BOARD_TYPE?.trim().toUpperCase() === type
                        );
                    }

                    this.currentPage = 1;
                }
                ,
                filterPostsByType() {
                    const type = this.selectedBoardType?.trim().toUpperCase();
                    const isCommentTab = this.activeTab === 'comments';

                    if (isCommentTab) {
                        const commentedBoardNos = this.myComments.map(comment => String(comment.BOARDNO));
                        this.filteredPosts = this.myPosts.filter(post =>
                            commentedBoardNos.includes(String(post.BOARDNO))
                        );
                    } else if (!type || type === '') {
                        this.filteredPosts = this.myPosts;
                    } else {
                        this.filteredPosts = this.myPosts.filter(post =>
                            post.TYPE?.trim().toUpperCase() === type
                        );
                    }

                    //console.log(" 게시판 타입:", type);
                    //console.log(" 게시글:", this.filteredPosts);
                    this.currentPage = 1;
                }
                ,
                fetchMyPosts() {
                    const param = {
                        userId: this.userId
                    };


                    if (this.selectedBoardType === 'N') {
                        param.boardType = 'N';
                    }
                    $.ajax({
                        url: '/getMyPosts.dox',
                        type: 'POST',
                        data: { userId: this.userId, boardType: this.selectedBoardType },
                        dataType: 'json',
                        success: (res) => {
                            this.myPosts = res.posts;
                            this.userStatus = res.status;
                            //console.log(" userStatus:", this.userStatus);
                            this.filteredPosts = res.posts; // 전체 게시판 초기화
                            //console.log(" myPosts:", this.myPosts);
                            //console.log(" filteredPosts:", this.filteredPosts);
                            this.filterPostsByType();
                        },
                        error: (err) => {
                            console.error('게시글 불러오기 실패:', err);
                        }
                    });
                },
                nextPage() {
                    if (this.currentPage < this.totalPages) {
                        this.currentPage++;
                    }
                },
                prevPage() {
                    if (this.currentPage > 1) {
                        this.currentPage--;
                    }
                },
                stripTags(html) {
                    const div = document.createElement("div");
                    div.innerHTML = html;
                    return div.textContent || div.innerText || "";
                },

                editComment(item) {
                    const newContent = prompt("댓글 내용을 수정하세요:", item.CONTENTS);

                    if (newContent && newContent !== item.CONTENTS) {
                        $.ajax({
                            url: '/api/comment/update',
                            type: 'POST',
                            data: {
                                commentNo: item.COMMENTNO,
                                contents: newContent
                            },
                            success: () => {
                                alert("댓글이 수정되었습니다.");
                                this.fetchMyComments(); //갱신
                                this.showEditModal = false;
                                this.closeModal();

                            },
                            error: (err) => {
                                console.error("❌ 댓글 수정 실패:", err.responseJSON || err.responseText);
                            }
                        });
                    }
                },

                editItem(item) {
                    this.selectedItem = item;

                    if (item.TITLE !== undefined) {
                        this.modalType = 'post';
                        this.editForm.boardNo = item.BOARDNO;
                        this.editForm.title = item.TITLE;
                        this.editForm.contents = this.stripTags(item.CONTENTS);
                    } else {
                        this.modalType = 'comment';
                        this.editForm.commentNo = item.COMMENTNO;
                        this.editForm.contents = this.stripTags(item.COMMENT_CONTENT);
                    }

                    this.showEditModal = true;
                },
                submitEdit() {
                    if (this.modalType === 'post') {
                        this.updatePost(this.editForm.boardNo, this.editForm.title, this.editForm.contents);
                    } else if (this.modalType === 'comment') {
                        this.updateComment(this.editForm.commentNo, this.editForm.contents);
                    }
                },
                closeModal() {
                    this.selectedItem = null;
                    this.showEditModal = false;
                    this.editForm = {
                        boardNo: '',
                        commentNo: '',
                        title: '',
                        contents: ''
                    };
                },
                closeEditModal() {
                    this.showEditModal = false;
                    this.editForm = {
                        boardNo: '',
                        commentNo: '',
                        title: '',
                        contents: ''
                    };
                },
                deleteItem(item) {
                    if (this.modalType === 'post') {
                        //console.log("🧪 삭제할 게시글 번호:", item.BOARDNO);

                        this.deletePost(item.BOARDNO);
                    } else if (this.modalType === 'comment') {
                        //console.log("🧪 삭제할 댓글 번호:", item.COMMENTNO);
                        this.deleteComment(item.COMMENTNO);
                    }
                },
                fetchMyComments() {
                    $.ajax({
                        url: '/getMyComments.dox',
                        type: 'POST',
                        data: { userId: this.userId },
                        dataType: 'json',
                        success: (res) => {
                            this.myComments = res.comments;
                            this.filterCommentsByType(); // 
                        },
                        error: (err) => {
                            console.error('댓글 목록 불러오기 실패:', err);
                        }
                    });
                }
                ,
                // 게시글 수정
                editPost(item) {
                    const newTitle = prompt("제목을 수정하세요:", item.TITLE);
                    const newContent = prompt("내용을 수정하세요:", item.CONTENTS);

                    $.ajax({
                        url: '/api/post/update',
                        type: 'POST',
                        data: {
                            boardNo: item.BOARDNO,
                            title: newTitle,
                            contents: newContent
                        },
                        success: () => {
                            alert("게시글이 수정되었습니다.");
                            this.closeModal();
                            this.fetchMyPosts();
                        },
                        error: (err) => {
                            console.error("❌ 게시글 수정 실패:", err);
                        }
                    });
                },

                // 게시글 삭제
                deletePost(boardNo) {
                    if (confirm("이 게시글을 삭제하시겠습니까?")) {
                        $.ajax({
                            url: '/api/post/delete',
                            type: 'POST',
                            data: { boardNo },
                            success: () => {
                                alert("게시글이 삭제되었습니다.");
                                this.closeModal();
                                this.fetchMyPosts();
                            },
                            error: (err) => {
                                console.error("❌ 게시글 삭제 실패:", err);
                            }
                        });
                    }
                },

                // 댓글 삭제
                deleteComment(commentNo) {
                    if (confirm("이 댓글을 삭제하시겠습니까?")) {
                        $.ajax({
                            url: '/api/comment/delete',
                            type: 'POST',
                            data: { commentNo },
                            success: () => {
                                alert("댓글이 삭제되었습니다.");
                                this.closeModal();
                                this.fetchMyComments(); // 댓글 목록 갱신

                            },
                            error: (err) => {
                                console.error("❌ 댓글 삭제 실패:", err.responseJSON || err.responseText);
                            }
                        });
                    }
                },
                updatePost(boardNo, title, contents) {
                    $.ajax({
                        url: '/api/post/update',
                        type: 'POST',
                        data: {
                            boardNo,
                            title,
                            contents
                        },
                        success: () => {
                            alert("게시글이 수정되었습니다.");
                            this.fetchMyPosts(); // 게시글 목록 갱신
                            this.showEditModal = false; // 모달 닫기
                            this.selectedItem = null;
                            this.editForm = {
                                boardNo: '',
                                commentNo: '',
                                title: '',
                                contents: ''
                            };
                        },
                        error: (err) => {
                            console.error("❌ 게시글 수정 실패:", err.responseJSON || err.responseText);
                        }
                    });
                },

                updateComment(commentNo, contents) {
                    $.ajax({
                        url: '/api/comment/update',
                        type: 'POST',
                        data: { commentNo, contents },
                        success: () => {
                            alert("댓글이 수정되었습니다.");
                            this.fetchMyComments(); // 목록 갱신

                            // 댓글 수정 모달 닫기
                            this.showEditModal = false;
                            this.selectedItem = null;
                            this.editForm = {
                                boardNo: '',
                                commentNo: '',
                                title: '',
                                contents: ''
                            };
                        },
                        error: (err) => {
                            console.error("❌ 댓글 수정 실패:", err.responseJSON || err.responseText);
                        }
                    });
                }
                ,


                // 게시글 / 댓글 리스트
                openModal(item) {
                    this.selectedItem = item;

                    if (item.COMMENTNO) {
                        this.modalType = 'comment';
                    } else {
                        this.modalType = 'post';

                        $.ajax({
                            url: '/api/comment/list', // 
                            type: 'GET',
                            data: { boardNo: item.BOARDNO },
                            dataType: 'json',
                            success: (res) => {
                                this.selectedComments = Array.isArray(res) ? res : [];
                            },
                            error: (err) => {
                                console.error("❌ 댓글 불러오기 실패:", err);
                                this.selectedComments = [];
                            }
                        });

                    }
                },
                closeModal() {
                    this.selectedItem = null;
                    this.fetchUserInfo();
                    document.body.style.overflow = '';
                },

            },
            mounted() {
                this.fetchMyPosts();
                this.fetchMyComments();
                const self = this;
                $.ajax({
                    url: '/getMyComments.dox',
                    type: 'POST',
                    data: { userId: self.userId },
                    dataType: 'json',
                    success(res) {

                        //console.log(" 답글 데이터:", res.comments);
                        self.myComments = res.comments;
                    }
                });

                $.ajax({
                    url: '/getMyPosts.dox',
                    type: 'POST',
                    data: { userId: self.userId },
                    dataType: 'json',
                    success(res) {
                        //console.log(" 게시글 데이터:", res.posts);
                        self.myPosts = res.posts;
                    },
                    error(err) {
                        console.error('게시글 불러오기 실패:', err);
                        // alert('게시글을 불러오는 중 오류가 발생했습니다.');
                    }
                });
            }
        });

        app.mount('#app');
    </script>

    </html>