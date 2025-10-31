<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <script
            src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
            crossorigin="anonymous"
        ></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />

        <style>
            body {
                background: #f3f7ff;
                font-family: "Pretendard", sans-serif;
                margin: 0;
                padding: 20px;
            }
            .main-con{
                width: 70%;
                margin: 0 auto;
            }
            .day-num {
                font-size: 20px;
                font-weight: 700;
                color: #0d47a1;
                margin-bottom: 15px;
                border-left: 4px solid #1565c0;
                padding-left: 8px;
            }

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
                height: 200px;
                object-fit: cover;
            }

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
            }

            .item-addr {
                font-size: 14px;
                color: #666;
                margin-bottom: 12px;
            }

            .item-overview {
                font-size: 15px;
                color: #444;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                display: -webkit-box;
                margin-bottom: 15px;
            }

            .review-btn {
                align-self: flex-start;
                background-color: #1976d2;
                color: white;
                border: none;
                border-radius: 8px;
                padding: 8px 16px;
                font-weight: 600;
                transition: 0.3s;
            }
            .review-btn:hover {
                background-color: #0d47a1;
            }

            .star-rating {
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 30px;
                color: #ffca28;
                cursor: pointer;
                margin-bottom: 8px;
            }
           
            .tab-btn {
                background: #e3f2fd;
                color: #1565c0;
                border: none;
                padding: 10px 20px;
                margin: 0 6px;
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
                color: white;
            }
        </style>
    </head>
    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div style="text-align: center; margin-bottom: 8px">
                <h2 style="margin: 0">📅 여행 일정</h2>
            </div>

            <!-- 탭 메뉴 -->
            <div style="display: flex; justify-content: center; margin-bottom: 20px">
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
    </body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                resNum: "${resNum}",
                info: [],
                positionsByDay: {},
                modalFlg: false,
                selectedItem: {},
                rating: 0,
                reviewText: "",
                selectedDay: 1,
                contentId: "",
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fninfo() {
                let self = this;
                let param = {
                    resNum: self.resNum,
                };
                $.ajax({
                    url: "/share.dox",
                    type: "GET",
                    data: param,
                    success: function (data) {
                        self.info = data; // dayMap 전체

                        //키값 넣어주기
                        const days = Object.keys(data)
                            .map((k) => parseInt(k))
                            .sort((a, b) => a - b);
                        for (let i = 0; i < days.length; i++) {
                            const day = days[i];
                            const dayList = data[day];
                            self.positionsByDay[day] = [];

                            for (let j = 0; j < dayList.length; j++) {
                                const item = dayList[j];
                                self.positionsByDay[day].push({
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
                                });
                                console.log(item.rating);
                            }
                            self.selectedDay = days[0];
                        }
                        console.log(data);
                    },
                });
            },
            setRating(i) {
                let self = this;
                self.rating = i;
            },
            getStarIcon(index, itemRating) {
                if (itemRating >= index) return "star";
                else if (itemRating >= index - 0.5) return "star_half";
                else return "star_border";
            },
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fninfo();
        },
    });

    app.mount("#app");
</script>
