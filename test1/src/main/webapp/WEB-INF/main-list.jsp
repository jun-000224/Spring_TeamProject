<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Team Project</title>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script
            type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"
        ></script>
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            integrity="sha512-..."
            crossorigin="anonymous"
            referrerpolicy="no-referrer"
        />
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
            rel="stylesheet"
        />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>
        <link rel="stylesheet" href="/css/main-style.css" />
        <link rel="stylesheet" href="/css/common-style.css" />
        <link rel="stylesheet" href="/css/header-style.css" />
        <link rel="stylesheet" href="/css/main-images.css" />
        <script src="/js/page-change.js"></script>

        <style>
            /* ================================
               ✅ 기본 설정
            ================================ */
            body {
                margin: 0;
                background-color: #f8f8f8;
                font-family: "Noto Sans KR", sans-serif;
            }

            .content-wrapper {
                width: 100%;
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 20px;
            }

            /* ================================
               ✅ 지도 + 카테고리
            ================================ */
            .map_wrap {
                position: relative;
                width: 100%;
                height: 400px;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                margin-bottom: 40px;
            }

            #category {
                position: absolute;
                top: 10px;
                left: 10px;
                display: flex;
                justify-content: space-between;
                background: #fff;
                border: 1px solid #ccc;
                border-radius: 8px;
                overflow: hidden;
                z-index: 10;
            }

            #category li {
                list-style: none;
                width: 60px;
                text-align: center;
                cursor: pointer;
                padding: 8px 0;
                border-right: 1px solid #e0e0e0;
                transition: background 0.2s;
            }
            #category li:last-child {
                border-right: none;
            }
            #category li:hover {
                background: #e8f4ff;
            }
            #category li.on {
                background: #0078ff;
                color: #fff;
                font-weight: bold;
            }
            #category li span {
                display: block;
                width: 27px;
                height: 28px;
                margin: 0 auto 5px;
            }
            #category li .category_bg {
                background: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png) no-repeat;
            }
            #category li .bank {
                background-position: -10px 0;
            }
            #category li .mart {
                background-position: -10px -36px;
            }
            #category li .pharmacy {
                background-position: -10px -72px;
            }
            #category li .oil {
                background-position: -10px -108px;
            }
            #category li .cafe {
                background-position: -10px -144px;
            }
            #category li .store {
                background-position: -10px -180px;
            }

            #roadviewBtn,
            #exitRoadviewBtn {
                position: absolute;
                top: 10px;
                z-index: 10;
                padding: 8px 12px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                color: white;
                font-weight: bold;
            }
            #roadviewBtn {
                right: 10px;
                background-color: #0078ff;
            }
            #exitRoadviewBtn {
                right: 100px;
                background-color: #ff5050;
            }

            /* ================================
               ✅ 슬라이더 (Swiper)
            ================================ */
            .swiper-container {
                width: 100%;
                height: 330px;
                margin: 40px 0;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                position: relative;
            }
            .swiper-slide {
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .swiper-button-next,
            .swiper-button-prev {
                color: 0078ff;
                transition: color 0.3s;
            }
            .swiper-slide .card {
                width: 335px;
            }

            /* ================================
               ✅ 카드 레이아웃 (후기)
            ================================ */
            .card-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 25px;
                max-width: 1200px;
                margin: 0 auto;
            }

            /* 카드 기본 */
            .card {
                position: relative;
                height: 320px;
                perspective: 1000px;
                border-radius: 15px;
            }

            /* 카드 내부 (회전) */
            .card-inner {
                position: relative;
                width: 335px;
                height: 100%;
                transition: transform 0.8s;
                transform-style: preserve-3d;
            }
            .card:hover .card-inner {
                transform: rotateY(180deg);
            }

            /* 카드 앞/뒤 */
            .card-front,
            .card-back {
                position: absolute;
                width: 100%;
                height: 100%;
                border-radius: 15px;
                overflow: hidden;
                backface-visibility: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            }

            /* 앞면 - 이미지 */
            .card-front img {
                width: 100%;
                height: 100%;
                display: block; /* 하단 여백 제거 */
                border-radius: 0; /* 모서리 일치 */
                object-fit: cover;
                background-color: #ddd;
            }

            /* 뒷면 */
            .card-back {
                background-color: #fff;
                transform: rotateY(180deg);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            /* 카드 내부 구성 */
            .card-body {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                height: 100%;
                padding: 18px 20px;
            }

            /* 상단: 태그 + 좋아요 */
            .card-box {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
            }

            /* 테마 태그 */
            .card-theme {
                display: inline-block;
                background-color: #e3f2fd;
                color: #1976d2;
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 0.8em;
                font-weight: 500;
                margin: 0 6px 6px 0;
            }

            /* 좋아요 / 조회수 아이콘 */
            .material-symbols-outlined {
                font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 48;
                color: #777;
                font-size: 24px;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .material-symbols-outlined.liked {
                font-variation-settings: "FILL" 1;
                color: #e53935;
            }

            /* 조회수 */
            .card-cnt {
                display: flex;
                align-items: center;
                gap: 4px;
                font-size: 0.85em;
                color: #666;
            }

            /* 텍스트 */
            .card-title {
                font-size: 1.2em;
                font-weight: 600;
                color: #222;
                margin-bottom: 6px;
                line-height: 1.4em;
            }
            .card-desc {
                font-size: 0.95em;
                color: #555;
                line-height: 1.5em;
                flex: 1;
                margin-bottom: 10px;
            }
            .card-info {
                font-size: 0.9em;
                color: #777;
                margin-bottom: 12px;
            }

            /* 버튼 */
            .card-footer button {
                width: 100%;
                padding: 8px 0;
                background-color: #0078ff;
                border: none;
                color: white;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s;
            }
            .card-footer button:hover {
                background-color: #005fcc;
            }
            /* ================================
         ✅ 추천 게시글 컨테이너
      ================================ */
            .bestCard-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                gap: 30px;
                max-width: 1200px;
                margin: 0 auto 40px auto;
            }

            /* ================================
         ✅ 카드 기본 스타일
      ================================ */
            .bestCard-container .card {
                background-color: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                display: flex;
                flex-direction: column;
            }
            .bestCard-container .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            }

            /* ================================
         ✅ 카드 내용
      ================================ */
            .bestCard-container .card-body {
                padding: 15px;
                display: flex;
                flex-direction: column;
                flex: 1;
            }

            .bestCard-container .card-title {
                font-size: 1.15em;
                font-weight: 600;
                margin-bottom: 8px;
                color: #222;
            }

            .bestCard-container .card-desc {
                font-size: 0.95em;
                color: #555;
                flex: 1;
                margin-bottom: 10px;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 2; /* 2줄로 제한 */
                -webkit-box-orient: vertical;
            }

            .bestCard-container .card-info {
                font-size: 0.9em;
                color: #777;
                margin-bottom: 10px;
            }

            .bestCard-container .card-cnt {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 5px;
                font-size: 0.85em;
                color: #666;
            }

            /* 좋아요 아이콘 */
            .bestCard-container .material-symbols-outlined {
                font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 48;
                color: #777;
                font-size: 20px;
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .bestCard-container .material-symbols-outlined.liked {
                font-variation-settings: "FILL" 1;
                color: #e53935;
            }

            /* ================================
               ✅ 제목
            ================================ */
            h2 {
                font-size: 22px;
                margin-bottom: 20px;
                text-align: center;
                color: #333;
            }
        </style>
    </head>

    <body>
        <%@ include file="components/header.jsp" %>
        <div id="app">
            <!-- 가운데 정렬을 위한 래퍼 추가 -->
            <div class="content-wrapper">
                <div class="hero-section">
                    <div class="map_wrap">
                        <div id="map" style="width: 100%; height: 100%; position: relative; overflow: hidden"></div>
                        <!-- 로드뷰 버튼 (오른쪽 상단) -->
                        <button
                            id="roadviewBtn"
                            style="
                                position: absolute;
                                top: 10px;
                                right: 10px;
                                z-index: 10;
                                padding: 8px 12px;
                                background-color: #0078ff;
                                color: white;
                                border: none;
                                border-radius: 5px;
                                cursor: pointer;
                                display: none;
                            "
                        >
                            로드뷰 보기
                        </button>
                        <button
                            id="exitRoadviewBtn"
                            style="
                                position: absolute;
                                top: 10px;
                                right: 80px;
                                z-index: 10;
                                padding: 8px 12px;
                                background-color: #ff5050;
                                color: white;
                                border: none;
                                border-radius: 5px;
                                cursor: pointer;
                                display: none;
                            "
                        >
                            나가기
                        </button>

                        <div id="roadview" style="width: 100%; height: 400px; display: none"></div>

                        <ul id="category">
                            <li id="BK9"><span class="category_bg bank"></span>은행</li>
                            <li id="MT1"><span class="category_bg mart"></span>마트</li>
                            <li id="PM9"><span class="category_bg pharmacy"></span>약국</li>
                            <li id="OL7"><span class="category_bg oil"></span>주유소</li>
                            <li id="CE7"><span class="category_bg cafe"></span>카페</li>
                            <li id="CS2"><span class="category_bg store"></span>편의점</li>
                            <li id="AD5"><span class="category_bg home"></span>숙소</li>
                        </ul>
                    </div>
                    <div class="swiper review-slider">
                        <h2>추천 후기글</h2>
                        <div class="swiper-wrapper">
                            <!-- 후기 카드 하나씩 슬라이드로 -->
                            <div
                                class="swiper-slide card"
                                v-for="item in list"
                                :key="item.resNum"
                                @click="fnDetail(item.resNum)"
                            >
                                <div class="card-inner">
                                    <div class="card-front">
                                        <!-- 앞면 -->
                                        <img
                                            class="card-img"
                                            :src="thumbnailMap[item.resNum]?.firstimage || getRandomImage()"
                                            :alt="item.packname"
                                        />
                                    </div>
                                    <!-- 뒷면 -->
                                    <div class="card-back">
                                        <div class="card-body">
                                            <div class="card-box">
                                                <div>
                                                    <div
                                                        class="card-theme"
                                                        v-for="tag in item.themNum.split(',')"
                                                        :key="tag"
                                                    >
                                                        {{ tag }}
                                                    </div>
                                                </div>
                                                <div style="display: flex">
                                                    <span
                                                        class="material-symbols-outlined"
                                                        :class="{ liked: item.liked }"
                                                        @click.stop="toggleLike(item)"
                                                    >
                                                        favorite
                                                    </span>
                                                    <div>{{ item.fav }}</div>
                                                </div>
                                            </div>

                                            <div class="card-box">
                                                <div class="card-title">{{ item.packname }}</div>
                                                <div class="card-cnt">
                                                    <span class="material-symbols-outlined">visibility</span>
                                                    <div>{{ item.cnt }}</div>
                                                </div>
                                            </div>

                                            <div class="card-desc">{{ item.descript }}</div>

                                            <div class="card-info">
                                                💰 {{ Number(item.price).toLocaleString() }}원 <br />
                                                👤 {{ item.userId }}
                                            </div>

                                            <div class="card-footer">
                                                <button @click.stop="fnDetail(item.resNum)">상세보기</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-button-next review-button-next"></div>
                        <div class="swiper-button-prev review-button-prev"></div>
                    </div>
                    <div>
                        <h2>추천 게시글</h2>
                        <div class="bestCard-container">
                            <div
                                class="card"
                                v-for="item in bestList"
                                :key="item.resNum"
                                @click="fnboardDetail(item.boardNo)"
                            >
                                <div class="card-body">
                                    <div class="card-title">{{ item.title }}</div>
                                    <div class="card-cnt">
                                        <div class="card-info">👤 {{ item.userId }}</div>
                                        <div style="display: flex">
                                            <div style="display: flex; margin-right: 20px">
                                                <span class="material-symbols-outlined"> thumb_up </span>
                                                <div>{{ item.fav }}</div>
                                            </div>
                                            <div style="display: flex">
                                                <span class="material-symbols-outlined">visibility</span>
                                                <div>{{ item.cnt }}</div>
                                            </div>
                                            <div style="display: flex; margin-left: 20px">
                                                <span
                                                    class="material-symbols-outlined liked"
                                                    @click.stop="toggleLike(item)"
                                                >
                                                    favorite
                                                </span>
                                                <div>{{ item.fav }}</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-desc">{{ item.contents }}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="components/footer.jsp" %>
    </body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                map: null,
                ps: null,
                placeOverlay: null,
                contentNode: null,
                markers: [],
                currCategory: "",
                roadview: null,
                roadviewClient: null,
                lastClickedLatLng: null,
                sliderTimer: null,
                sliderIndex: 0,
                //리스트
                userId: "${sessionId}",
                list: [],
                bestList: [],
                liked: false,
                thumbnailMap: {},
                page: 1,
                pageSize: 6,
                randomImages: [
                    "/img/defaultImg01.jpg",
                    "/img/defaultImg02.jpg",
                    "/img/defaultImg03.jpg",
                    "/img/defaultImg04.jpg",
                    "/img/defaultImg05.jpg",
                    "/img/defaultImg06.jpg",
                ],
            };
        },
        methods: {
            // ✅ 초기화
            init() {
                let self = this;
                kakao.maps.load(() => {
                    self.initMap();
                    self.initCategory();
                    self.initRoadview();
                });
                self.$nextTick(() => {
                    self.initSwiper(); // ✅ Swiper 초기화 추가
                });
            },
            // ✅ 지도 초기화
            initMap() {
                let self = this;
                const mapContainer = document.getElementById("map");
                const mapOption = {
                    center: new kakao.maps.LatLng(37.566826, 126.9786567),
                    level: 5,
                };
                let geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch("인천광역시 부평구 부평1동 534-48", function (result, status) {
                    // 정상적으로 검색이 완료됐으면
                    if (status === kakao.maps.services.Status.OK) {
                        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                        // 결과값으로 받은 위치를 마커로 표시합니다
                        var marker = new kakao.maps.Marker({
                            map: self.map,
                            position: coords,
                        });

                        // 인포윈도우로 장소에 대한 설명을 표시합니다
                        var infowindow = new kakao.maps.InfoWindow({
                            content: '<div style="width:150px;text-align:center;padding:3px 0;">내 위치</div>',
                        });
                        infowindow.open(self.map, marker);

                        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
                        self.map.setCenter(coords);
                    }
                });
                self.map = new kakao.maps.Map(mapContainer, mapOption);
                self.ps = new kakao.maps.services.Places(self.map);
                self.placeOverlay = new kakao.maps.CustomOverlay({ zIndex: 1 });
                self.contentNode = document.createElement("div");
                self.placeOverlay.setContent(self.contentNode);
                kakao.maps.event.addListener(self.map, "idle", () => self.searchPlaces());
            },
            // ✅ 카테고리 기능
            initCategory() {
                let self = this;
                const items = document.querySelectorAll("#category li");
                items.forEach((item) => {
                    item.addEventListener("click", () => {
                        if (item.classList.contains("on")) {
                            item.classList.remove("on");
                            self.currCategory = "";
                            self.removeMarker();
                            return;
                        }
                        items.forEach((el) => el.classList.remove("on"));
                        item.classList.add("on");
                        self.currCategory = item.id;
                        self.searchPlaces();
                    });
                });
            },
            // ✅ 장소 검색
            searchPlaces() {
                let self = this;
                if (!self.currCategory || !self.ps) return;
                self.placeOverlay.setMap(null);
                self.removeMarker();
                self.ps.categorySearch(
                    self.currCategory,
                    (data, status) => {
                        if (status !== kakao.maps.services.Status.OK) return;
                        data.forEach((place) => self.displayMarker(place));
                    },
                    { useMapBounds: true }
                );
            },
            displayMarker(place) {
                let self = this;
                const marker = new kakao.maps.Marker({
                    map: self.map,
                    position: new kakao.maps.LatLng(place.y, place.x),
                });
                self.markers.push(marker);
                kakao.maps.event.addListener(marker, "click", () => {
                    const content = `<div style="padding:5px;font-size:12px;">${place.place_name}</div>`;
                    self.contentNode.innerHTML = content;
                    self.placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
                    self.placeOverlay.setMap(self.map);
                });
            },
            removeMarker() {
                let self = this;
                self.markers.forEach((m) => m.setMap(null));
                self.markers = [];
            },
            // ✅ 로드뷰
            initRoadview() {
                let self = this;
                const mapContainer = document.getElementById("map");
                const roadviewContainer = document.getElementById("roadview");
                const roadviewBtn = document.getElementById("roadviewBtn");
                const exitRoadviewBtn = document.getElementById("exitRoadviewBtn");
                self.roadview = new kakao.maps.Roadview(roadviewContainer);
                self.roadviewClient = new kakao.maps.RoadviewClient();
                kakao.maps.event.addListener(self.map, "click", function (mouseEvent) {
                    self.lastClickedLatLng = mouseEvent.latLng;
                    self.map.panTo(self.lastClickedLatLng);
                    self.removeMarker();
                    const marker = new kakao.maps.Marker({
                        position: self.lastClickedLatLng,
                        map: self.map,
                    });
                    self.markers.push(marker);
                    roadviewBtn.style.display = "block";
                });
                roadviewBtn.addEventListener("click", function () {
                    if (!self.lastClickedLatLng) return;
                    self.roadviewClient.getNearestPanoId(self.lastClickedLatLng, 50, function (panoId) {
                        if (panoId) {
                            mapContainer.style.display = "none";
                            roadviewContainer.style.display = "block";
                            roadviewBtn.style.display = "none";
                            exitRoadviewBtn.style.display = "block";
                            self.roadview.setPanoId(panoId, self.lastClickedLatLng);
                        }
                    });
                });
                exitRoadviewBtn.addEventListener("click", function () {
                    roadviewContainer.style.display = "none";
                    mapContainer.style.display = "block";
                    roadviewBtn.style.display = "none";
                    exitRoadviewBtn.style.display = "none";
                });
            },
            // ✅ Swiper 슬라이더 초기화
            initSwiper() {
                let self = this;
                // 메인 배너 슬라이더
                if (!self.mainSwiper) {
                    self.mainSwiper = new Swiper(".swiper-container", {
                        loop: true,
                        autoplay: { delay: 3000, disableOnInteraction: false },
                        pagination: { el: ".swiper-pagination", clickable: true },
                        navigation: {
                            nextEl: " .swiper-button-next",
                            prevEl: " .swiper-button-prev",
                        },
                    });
                }
                // 후기 슬라이더 (추천 게시글)
                if (!self.reviewSwiper) {
                    self.reviewSwiper = new Swiper(".review-slider", {
                        loop: true,
                        autoplay: { delay: 4000, disableOnInteraction: false },
                        slidesPerView: 3,
                        spaceBetween: 20,
                        pagination: { el: ".swiper-pagination", clickable: true },
                        navigation: {
                            nextEl: ".swiper-button-next",
                            prevEl: ".swiper-button-prev",
                        },
                        breakpoints: {
                            640: { slidesPerView: 1 },
                            1024: { slidesPerView: 2 },
                            1440: { slidesPerView: 3 },
                        },
                    });
                }
            },
            fnResList() {
                let self = this;
                $.ajax({
                    url: "/review-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        userId: self.userId,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize,
                    },
                    success: function (data) {
                        self.list = data.list;
                    },
                });
            },
            fnBestList() {
                let self = this;
                $.ajax({
                    url: "/bestList.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        userId: self.userId,
                        pageSize: self.pageSize,
                        page: (self.page - 1) * self.pageSize,
                    },
                    success: function (data) {
                        console.log(data);
                        self.bestList = data.list;
                    },
                });
            },
            fnThumnail() {
                let self = this;
                $.ajax({
                    url: "/thumbnail.dox",
                    dataType: "json",
                    type: "GET",
                    data: {},
                    success: function (data) {
                        console.log(data);
                        self.thumbnailMap = data.list;
                    },
                });
            },
            fnDetail(item) {
                // 상세 페이지 이동 (URL은 프로젝트에 맞게 수정)
                console.log(item);
                pageChange("review-view.do", { resNum: item });
            },
            fnboardDetail(item) {
                // 상세 페이지 이동 (URL은 프로젝트에 맞게 수정)
                console.log(item);
                pageChange("board-view.do", { boardNo: item });
            },
            toggleLike(item) {
                let self = this;
                param = {
                    userId: self.userId,
                    boardNo: item.boardNo,
                };
                $.ajax({
                    url: "review-favorite.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        item.liked = data.liked;
                        self.fnList();
                    },
                });
                console.log(item);
            },
            getRandomImage() {
                if (!this.shuffled) {
                    this.shuffled = [...this.randomImages].sort(() => Math.random() - 0.5);
                }

                // 하나 꺼내기 (없으면 다시 섞기)
                if (this.shuffled.length === 0) {
                    this.shuffled = [...this.randomImages].sort(() => Math.random() - 0.5);
                }

                return this.shuffled.pop();
            },
        },
        mounted() {
            let self = this;

            const queryParams = new URLSearchParams(window.location.search);
            window.code = queryParams.get('code') || '';
            if (window.code != null) {
                fnKakao();
            }

            self.init();
            self.fnResList();
            self.fnThumnail();
            self.fnBestList();
            window.addEventListener("popstate", () => {
                self.fnResList();
                self.fnThumnail();
                self.fnBestList();
            });
            window.addEventListener("pageshow", (event) => {
                if (event.persisted) {
                    self.fnResList();
                    self.fnThumnail();
                    self.fnBestList();
                }
            });
        },
    });
    app.mount("#app");
</script>
