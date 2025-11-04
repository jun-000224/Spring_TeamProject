<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>신고 시스템</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-images.css">
        <style>
            .chat-box {
                width: 300px;
                border: 1px solid #ccc;
                padding: 15px;
                border-radius: 8px;
                background: #f9f9f9;
                position: relative;
                margin-bottom: 20px;
            }

            .close-btn {
                position: absolute;
                top: 5px;
                right: 10px;
                border: none;
                background: transparent;
                font-size: 18px;
                cursor: pointer;
            }

            .report-types button {
                margin: 5px 5px 10px 0;
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                background-color: #007bff;
                color: white;
                cursor: pointer;
            }

            .chat-input input {
                width: 100%;
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }

            .chat-confirm {
                margin-top: 10px;
                color: green;
            }

            .report-history {
                margin-top: 30px;
            }

            .report-history ul {
                list-style: none;
                padding: 0;
            }

            .report-history li {
                margin-bottom: 10px;
                background: #f1f1f1;
                padding: 10px;
                border-radius: 6px;
            }

            .admin-reply {
                margin-top: 5px;
                font-size: 13px;
                color: #555;
            }
        </style>

    </head>

    <body>
        <div id="app">
        
            <div class="report-btn">
                <button @click="openChat">🚨 신고하기</button>
            </div>

            <div v-if="showChat" class="chat-box">
                <button class="close-btn" @click="closeChat">X</button>
                <h3>신고 유형 선택</h3>
                <div class="report-types">
                    <button @click="selectType('오류제보')">오류제보</button>
                    <button @click="selectType('불편사항')">불편사항</button>
                    <button @click="selectType('사기신고')">사기신고</button>
                </div>

                <div v-if="selectedType" class="chat-input">
                    <p><strong>{{ selectedType }}</strong> 내용을 입력하세요:</p>
                    <input type="text" v-model="message" @keyup.enter="submitReport" placeholder="내용을 입력하고 엔터" />
                </div>

                <div v-if="reportSent" class="chat-confirm">
                    신고가 접수되었습니다. 감사합니다!
                </div>
            </div>

            <div class="report-history" v-if="reportList.length > 0">
                <h3>📋 신고 내역</h3>
                <ul>
                    <li v-for="(item, index) in reportList" :key="index">
                        <strong>[{{ item.type }}]</strong> {{ item.message }}
                        <div class="admin-reply">👮 관리자: {{ item.reply }}</div>
                    </li>
                </ul>
             
            </div>
        </div>

    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    showChat: false,
                    selectedType: "",
                    message: "",
                    reportSent: false,
                    reportList: [] // 신고 내역 저장
                };
            },
            methods: {
                openChat() {
                    let self = this;
                    self.showChat = true;
                    self.selectedType = "";
                    self.message = "";
                    self.reportSent = false;
                },
                closeChat() {
                    let self = this;
                    self.showChat = false;
                },
                selectType(type) {
                    let self = this;
                    self.selectedType = type;
                    self.message = "";
                    self.reportSent = false;
                },
                submitReport() {
                    let self = this;
                    if (!self.message.trim()) return;

                    const param = {
                        type: self.selectedType,
                        message: self.message
                    };

                    $.ajax({
                        url: "/report.do",
                        type: "POST",
                        data: param,
                        success: function (res) {
                            self.reportList.push({
                                type: self.selectedType,
                                message: self.message,
                                reply: "신고 내용을 확인했습니다. 감사합니다." // 관리자 응답 (모의)
                            });
                            self.reportSent = true;
                            self.message = "";
                        },
                        error: function () {
                            alert("신고 전송 중 오류가 발생했습니다.");
                        }
                    });
                }
            }
        });



        app.mount('#app');
    </script>