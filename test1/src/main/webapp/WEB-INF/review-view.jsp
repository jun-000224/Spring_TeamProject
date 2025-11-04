<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>여행 일정</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=arrow_back"
        />
        <script src="/js/page-change.js"></script>

        <style>
            body {
                background: #f3f7ff;
                font-family: "Pretendard", sans-serif;
                margin: 0;
                padding: 20px;
            }

            /* 전체 레이아웃 */
            .main-con {
                width: 70%;
                margin: 0 auto;
            }

            .page-title {
                display: flex;
                align-items: center;
                justify-content: center; /* 중앙 정렬 기준 */
                position: relative; /* 뒤로가기 버튼 절대 위치 가능하게 */
                max-width: 70%;
                margin: 0 auto 28px;
                text-align: center;
            }

            /* 제목 */
            .page-title h2 {
                margin: 0;
                font-size: 24px;
                font-weight: 700;
            }

            /* 뒤로가기 버튼 */
            .back-btn {
                position: absolute;
                left: 0; /* 맨 왼쪽으로 이동 */
            }

            .back {
                background: none;
                border: none;
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 16px;
                cursor: pointer;
                transition: 0.3s;
            }

            .material-symbols-outlined {
                font-size: 32px;
                vertical-align: middle;
            }
            /* 탭 버튼 영역 */
            .tab-menu {
                display: flex;
                justify-content: center;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .tab-btn {
                background: #e3f2fd;
                color: #1565c0;
                border: none;
                padding: 10px 20px;
                margin: 6px;
                border-radius: 20px;
                cursor: pointer;
                font-weight: 600;
                transition: 0.3s;
            }
            .tab-btn:hover {
                background: #bbdefb;
            }
            .tab-btn.active {
                background: #1565c0;
                color: #fff;
            }

            /* 날짜 제목 */
            .day-num {
                font-size: 20px;
                font-weight: 700;
                color: #0d47a1;
                margin-bottom: 15px;
                border-left: 4px solid #1565c0;
                padding-left: 8px;
            }

            /* 카드 (일정 아이템) */
            .day-item-con {
                display: flex;
                border-radius: 16px;
                background: #fff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                transition: 0.3s;
                margin-bottom: 20px;
                cursor: pointer;
            }
            .day-item-con:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
            }

            .day-item-con img {
                width: 280px;
                object-fit: cover;
            }

            /* 본문 */
            .item-md {
                flex: 1;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .item-title {
                font-size: 20px;
                font-weight: 600;
                color: #222;
                margin-bottom: 6px;
            }

            .item-addr {
                font-size: 14px;
                color: #666;
                margin-bottom: 12px;
            }

            .item-overview {
                font-size: 15px;
                color: #444;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                margin-bottom: 15px;
            }

            /* 별점 */
            .star-rating {
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 30px;
                color: #ffca28;
                cursor: pointer;
                margin-bottom: 8px;
            }

            /* 버튼 */
            .review-btn {
                align-self: flex-start;
                background-color: #1976d2;
                color: #fff;
                border: none;
                border-radius: 8px;
                padding: 8px 16px;
                font-weight: 600;
                transition: 0.3s;
            }
            .review-btn:hover {
                background-color: #0d47a1;
            }

            a {
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div id="app">
            <div class="page-title">
                <div class="back-btn">
                    <button class="back" @click="fnbck">
                        <span class="material-symbols-outlined">arrow_back</span>
                        뒤로가기
                    </button>
                </div>
                <h2>📅 여행 일정</h2>
            </div>

            <!-- 탭 메뉴 -->
            <div class="tab-menu">
                <button
                    v-for="(list, day) in positionsByDay"
                    :key="day"
                    @click="selectedDay = day"
                    :class="['tab-btn', { active: selectedDay == day }]"
                >
                    {{ day }}일차 ({{ list.length }}곳)
                </button>
            </div>

            <div class="main-con" v-if="positionsByDay[selectedDay]">
                <div class="day-num">{{ selectedDay }}일차 - {{ positionsByDay[selectedDay][0].day }}</div>

                <div
                    v-for="item in positionsByDay[selectedDay]"
                    :key="item.title"
                    class="day-item-con"
                    @click="fnView(item.contentId)"
                >
                    <img :src="item.firstimage" alt="이미지" />
                    <div class="item-md">
                        <div>
                            <div class="item-title">{{ item.title }}</div>
                            <div class="item-addr">📍 {{ item.addr1 }}</div>
                            <div class="item-overview">{{ item.overview }}</div>
                            <div class="star-rating">
                                <span v-for="i in 5" :key="i" class="material-icons">
                                    {{ getStarIcon(i, item.rating) }}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        resNum: "${resNum}",
                        info: [],
                        positionsByDay: {},
                        selectedDay: 1,
                    };
                },
                methods: {
                    fninfo() {
                        let self = this;
                        $.ajax({
                            url: "/share.dox",
                            type: "GET",
                            data: { resNum: self.resNum },
                            success(data) {
                                self.info = data;
                                const days = Object.keys(data)
                                    .map((k) => parseInt(k))
                                    .sort((a, b) => a - b);
                                for (let day of days) {
                                    self.positionsByDay[day] = data[day].map((item) => ({
                                        title: item.title,
                                        lat: parseFloat(item.mapy),
                                        lng: parseFloat(item.mapx),
                                        overview: item.overview,
                                        dayNum: day,
                                        reserv_date: item.reserv_date,
                                        firstimage: item.firstimage,
                                        addr1: item.addr1,
                                        contentId: item.contentid,
                                        day: item.day,
                                        rating: item.rating,
                                    }));
                                    console.log( days);
                                    
                                }
                                self.selectedDay = days[0];
                                console.log(self.selectedDay);
                                
                            },
                        });
                    },
                    getStarIcon(index, rating) {
                        if (rating >= index) return "star";
                        else if (rating >= index - 0.5) return "star_half";
                        else return "star_border";
                    },
                    fnView(contentId) {
                        pageChange("review-detail.do", { contentId });
                    },
                    fnbck() {
                        history.back();
                    },
                    fncnt() {
                        let self = this;
                        $.ajax({
                            url: "/review-cnt.dox",
                            dataType: "json",
                            type: "POST",
                            data: {
                                resNum: self.resNum,
                            },
                            success: function (data) {},
                        });
                    },
                },
                mounted() {
                    let self = this;
                    self.fninfo();
                    self.fncnt();

                    window.addEventListener("popstate", () => {
                        self.fninfo();
                        self.fncnt();
                    });
                    window.addEventListener("pageshow", (event) => {
                        if (event.persisted) {
                            self.fninfo();
                            self.fncnt();
                        }
                    });
                },
            });
            app.mount("#app");
        </script>
    </body>
</html>
