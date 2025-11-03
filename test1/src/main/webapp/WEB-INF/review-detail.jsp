<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>방문자 후기</title>
        <script
            src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
            crossorigin="anonymous"
        ></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
        <script src="/js/page-change.js"></script>

        <style>
            body {
                background: #f3f7ff;
                font-family: "Pretendard", sans-serif;
                margin: 0;
                padding: 20px;
                color: #333;
            }

            .container {
                background-color: #fff;
                border-radius: 16px;
                max-width: 800px;
                margin: 0 auto;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                overflow: hidden;
            }

            /* 관광지 이미지 */
            #app > div:first-child img {
                width: 100%;
                max-height: 400px;
                object-fit: cover;
            }

            /* 정보 영역 */
            .info-con {
                padding: 20px;
                border-bottom: 1px solid #eee;
            }

            .info-con h3 {
                margin: 0 0 10px;
                font-size: 20px;
                color: #222;
            }

            .info-con p {
                margin: 0;
                font-size: 15px;
                line-height: 1.6;
                color: #555;
            }

            /* 후기 제목 */
            h3 {
                font-size: 18px;
                margin-bottom: 15px;
                color: #222;
            }

            /* 후기 카드 */
            .review-card {
                background-color: #ffffff;
                border-radius: 12px;
                padding: 15px 20px;
                margin-bottom: 15px;
                box-shadow: 0 3px 12px rgba(0, 0, 0, 0.08);
            }

            /* 후기 헤더 */
            .review-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 6px;
            }

            .review-header span {
                font-weight: 600;
            }

            /* 후기 날짜 */
            .review-date {
                font-size: 12px;
                color: #999;
                margin-bottom: 8px;
            }

            /* 별점 */
            .star-rating {
                display: flex;
                align-items: center;
                gap: 2px;
                font-size: 20px;
                color: #ffca28;
            }

            /* 후기 내용 */
            .review-content {
                margin-bottom: 10px;
                color: #555;
                font-size: 14px;
                line-height: 1.5;
            }

            /* 후기 이미지 */
            .review-images {
                display: flex;
                gap: 8px;
            }

            .review-images img {
                height: 120px;
                object-fit: cover;
                border-radius: 10px;
                border: 1px solid #ddd;
                transition: transform 0.2s;
                cursor: pointer;
            }
            .review-images img:hover {
                transform: scale(1.05);
            }

            /* +n 버튼 */
            .more-overlay {
                width: 100%;
                border-radius: 10px;
                background-color: rgba(0, 0, 0, 0.6);
                color: #fff;
                font-size: 18px;
                font-weight: 600;
                display: flex;
                justify-content: center;
                align-items: center;
                cursor: pointer;
            }

            /* 모달 */
            .modal {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.7);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 999;
            }

            .modal-content {
                position: relative;
                background: #fff;
                padding: 15px;
                border-radius: 10px;
                max-width: 90%;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                overflow-y: auto;
            }

            .modal-content img {
                width: 150px;
                height: 150px;
                border-radius: 8px;
                object-fit: cover;
            }

            .close-btn {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 24px;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <div class="container">
                <div>
                    <div>
                        <img :src="info.firstimage" alt="" />
                    </div>
                    <div class="info-con">
                        <h3>{{ info.title }}</h3>
                        <p>{{ info.addr1 }}</p>
                    </div>
                    <div class="info-con">
                        <h3>상세설명</h3>
                        <p>{{ info.overview }}</p>
                    </div>
                </div>

                <div>
                    <h3 style="padding: 20px">방문자 후기</h3>
                    <div v-for="item in reviewList" :key="item.reviewNo" class="review-card">
                        <div class="review-header">
                            <span>{{ item.nickname }}</span>
                            <div class="star-rating">
                                <span v-for="i in 5" :key="i" class="material-icons">
                                    {{ getStarIcon(i, item.rating) }}
                                </span>
                            </div>
                        </div>
                        <div class="review-date">{{ item.rdatetime }}</div>
                        <div class="review-content">{{ item.content }}</div>

                        <!-- 이미지 출력 -->
                        <div class="review-images" v-if="getImages(item.resNum).length > 0">
                            <template v-for="(img, index) in getImages(item.resNum).slice(0,3)" :key="img.sortNo">
                                <!-- 클릭 시 해당 img만 넘김 -->
                                <img :src="img.storUrl" :alt="img.title" @click="openModal(img)" />
                            </template>

                            <!-- +n 버튼 -->
                            <div
                                v-if="getImages(item.resNum).length > 3"
                                class="more-overlay"
                                @click="openModal(getImages(item.resNum))"
                            >
                                +{{ getImages(item.resNum).length - 3 }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 모달 -->
            <div v-if="isModalOpen" class="modal" @click.self="closeModal">
                <div class="modal-content">
                    <span class="close-btn" @click="closeModal">&times;</span>
                    <img v-for="(img, index) in selectedImages" :key="index" :src="img.storUrl" />
                </div>
            </div>
        </div>
    </body>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    contentId: "${contentId}",
                    info: {},
                    reviewList: [],
                    reviewImgList: [],
                    isModalOpen: false,
                    selectedImages: [],
                };
            },
            methods: {
                fninfo() {
                    let self = this;
                    $.ajax({
                        url: "/review-detail.dox",
                        type: "GET",
                        data: { contentId: self.contentId },
                        success: function (data) {
                            self.info = data[0];
                            self.reviewList = data[0].list;
                            self.reviewImgList = data[0].imgList;
                            console.log(data);

                            console.log(self.reviewImgList);
                            console.log(self.reviewList);
                        },
                    });
                },
                getStarIcon(index, rating) {
                    if (rating >= index) return "star";
                    else if (rating >= index - 0.5) return "star_half";
                    else return "star_border";
                },
                // reviewNo별로 이미지 매칭
                getImages(resNum) {
                    let self = this;
                    console.log(
                        self.reviewImgList.filter((img) => img.resNum === resNum).sort((a, b) => a.sortNo - b.sortNo)
                    );
                    return self.reviewImgList
                        .filter((img) => img.resNum === resNum)
                        .sort((a, b) => a.sortNo - b.sortNo);
                },
                openModal(image) {
                    // 단일 이미지 클릭 시
                    if (!Array.isArray(image)) {
                        this.selectedImages = [image];
                    }
                    // "+n" 버튼 클릭 시 → 모든 이미지 보여주기
                    else {
                        this.selectedImages = image;
                    }
                    this.isModalOpen = true;
                },
                closeModal() {
                    let self = this;
                    self.isModalOpen = false;
                    self.selectedImages = [];
                },
            },
            mounted() {
                let self = this;
                self.fninfo();
            },
        });
        app.mount("#app");
    </script>
</html>
