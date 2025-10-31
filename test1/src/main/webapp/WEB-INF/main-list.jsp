<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Team Project</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
        <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"></script>

        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <link rel="stylesheet" href="/css/main-images.css">
        <style>
            .map_wrap,
            .map_wrap * {
                margin: 0;
                padding: 0;
                font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
                font-size: 12px;
            }

            .map_wrap {
                position: relative;
                width: 100%;
                height: 350px;
            }

            #category {
                position: absolute;
                top: 10px;
                left: 10px;
                border-radius: 5px;
                border: 1px solid #909090;
                box-shadow: 0 1px 1px rgba(0, 0, 0, 0.4);
                background: #fff;
                overflow: hidden;
                z-index: 2;
            }

            #category li {
                float: left;
                list-style: none;
                width: 50px;
                border-right: 1px solid #acacac;
                padding: 6px 0;
                text-align: center;
                cursor: pointer;
            }

            #category li.on {
                background: #eee;
            }

            #category li:hover {
                background: #ffe6e6;
                border-left: 1px solid #acacac;
                margin-left: -1px;
            }

            #category li:last-child {
                margin-right: 0;
                border-right: 0;
            }

            #category li span {
                display: block;
                margin: 0 auto 3px;
                width: 27px;
                height: 28px;
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

            #category li.on .category_bg {
                background-position-x: -46px;
            }

            .placeinfo_wrap {
                position: absolute;
                bottom: 28px;
                left: -150px;
                width: 300px;
            }

            .placeinfo {
                position: relative;
                width: 100%;
                border-radius: 6px;
                border: 1px solid #ccc;
                border-bottom: 2px solid #ddd;
                padding-bottom: 10px;
                background: #fff;
            }

            .placeinfo:nth-of-type(n) {
                border: 0;
                box-shadow: 0px 1px 2px #888;
            }

            .placeinfo_wrap .after {
                content: '';
                position: relative;
                margin-left: -12px;
                left: 50%;
                width: 22px;
                height: 12px;
                background: url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')
            }

            .placeinfo a,
            .placeinfo a:hover,
            .placeinfo a:active {
                color: #fff;
                text-decoration: none;
            }

            .placeinfo a,
            .placeinfo span {
                display: block;
                text-overflow: ellipsis;
                overflow: hidden;
                white-space: nowrap;
            }

            .placeinfo span {
                margin: 5px 5px 0 5px;
                cursor: default;
                font-size: 13px;
            }

            .placeinfo .title {
                font-weight: bold;
                font-size: 14px;
                border-radius: 6px 6px 0 0;
                margin: -1px -1px 0 -1px;
                padding: 10px;
                color: #fff;
                background: #d95050;
                background: #d95050 url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;
            }

            .placeinfo .tel {
                color: #0f7833;
            }

            .placeinfo .jibun {
                color: #999;
                font-size: 11px;
                margin-top: 0;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <%@ include file="components/header.jsp" %>

                <!-- 가운데 정렬을 위한 래퍼 추가 -->
                <div class="content-wrapper">
                    <!-- 배너 슬라이더 -->
                    <div class="map-banner-slider">
                        <div class="slider-track" id="sliderTrack">
                            <a href="main-list.do" target="_blank"><img src="/images/banner1.jpg" alt="배너1"></a>
                            <a href="main-list.do" target="_blank"><img src="/images/banner2.jpg" alt="배너2"></a>
                            <a href="main-list.do" target="_blank"><img src="/images/banner3.jpg" alt="배너3"></a>
                            <a href="main-list.do" target="_blank"><img src="/images/banner4.jpg" alt="배너4"></a>
                            <a href="main-list.do" target="_blank"><img src="/images/banner5.jpg" alt="배너5"></a>
                        </div>
                    </div>

                    <div class="hero-section">
                        <div class="map_wrap">

                            <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
                            <!-- 로드뷰 버튼 (오른쪽 상단) -->
                            <button id="roadviewBtn" style="
                            position: absolute;
                            top: 10px;
                            right: 10px;
                            z-index: 10;
                            padding: 8px 12px;
                            background-color: #0078FF;
                            color: white;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            display: none;">로드뷰 보기</button>

                            <div id="roadview" style="width:100%;height:400px;display:none;"></div>

                            <ul id="category">
                                <li id="BK9"><span class="category_bg bank"></span>은행</li>
                                <li id="MT1"><span class="category_bg mart"></span>마트</li>
                                <li id="PM9"><span class="category_bg pharmacy"></span>약국</li>
                                <li id="AD5"><span class="category_bg oil"></span>주유소</li>
                                <li id="CE7"><span class="category_bg cafe"></span>카페</li>
                                <li id="CS2"><span class="category_bg store"></span>편의점</li>
                                <li id="AD5"><span class="category_bg home"></span>숙소</li>
                            </ul>
                        </div>
                    </div>
                    <!-- 지도 아래에 POI 순위 테이블 추가 -->
                    <div class="poi-card-section">
                        <h2>📍 관심지점 예약 순위</h2>
                        <div class="poi-card-container">
                            <%-- 나중에 DB에서 받아온 리스트로 반복 처리 예정 --%>
                                <div class="poi-card">
                                    <div class="poi-rank">1위</div>
                                    <div class="poi-name">서울역점</div>
                                    <div class="poi-address">서울 중구 한강대로 405</div>
                                    <div class="poi-reservation">예약 수: 128건</div>
                                </div>

                                <div class="poi-card">
                                    <div class="poi-rank">2위</div>
                                    <div class="poi-name">강남점</div>
                                    <div class="poi-address">서울 강남구 테헤란로 152</div>
                                    <div class="poi-reservation">예약 수: 97건</div>
                                </div>
                                <%-- ... --%>
                        </div>
                    </div>
                    <br>
                    <main>
                        <div class="table-wrapper">
                            <table class="centered-table">
                                <div id="google_translate_element">
                                </div>
                            </table>
                        </div>
                    </main>
                    <%@ include file="components/footer.jsp" %>
                </div>
        </div>
        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        map: null,
                        ps: null,
                        placeOverlay: null,
                        contentNode: null,
                        markers: [],
                        currCategory: '',
                        id: "${sessionId}",
                        status: "${sessionStatus}",
                        nickname: "${sessionNickname}",
                        name: "${sessionName}",
                        showLogoutMenu: false,
                        point: "${sessionPoint}",
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
                    goToLogin() {
                        location.href = "/member/login.do";
                    },
                    goToMyPage() {
                        location.href = "/myPage.do";
                    },

                    goToService() {
                        location.href = "/Service.do";
                    },
                    logout() {
                        let self = this;
                        let param = {
                        };
                        $.ajax({
                            url: "/member/logout.dox",
                            dataType: "json",
                            type: "POST",
                            data: param,
                            success: function (data) {
                                alert(data.msg);
                                self.searchPlaces(); // ✅ 마커 재검색
                                location.href = "/main-list.do";
                            }
                        });
                    },
                    removeMarker() {
                        for (let i = 0; i < this.markers.length; i++) {
                            this.markers[i].setMap(null);
                        }
                        this.markers = [];
                    },
                    goToMyPage() {
                        location.href = "/main-myPage.do";
                    },
                    goToSettings() {
                        location.href = "/settings.do";
                    },
                    LogoutMenu() {
                        this.showLogoutMenu = !this.showLogoutMenu;
                    },

                    onCategoryChange(event) {
                        this.currCategory = event.target.value;
                        this.searchPlaces();
                    },
                    searchPlaces() {
                        if (!this.currCategory) return;

                        this.placeOverlay.setMap(null);
                        this.removeMarker();

                        this.ps.categorySearch(this.currCategory, this.placesSearchCB, { useMapBounds: true });
                    },
                    placesSearchCB(data, status, pagination) {
                        if (status !== kakao.maps.services.Status.OK) return;

                        this.removeMarker();

                        for (let i = 0; i < data.length; i++) {
                            this.displayMarker(data[i]);
                        }
                    },
                    displayMarker(place) {
                        const marker = new kakao.maps.Marker({
                            map: this.map,
                            position: new kakao.maps.LatLng(place.y, place.x)
                        });

                        this.markers.push(marker);

                        kakao.maps.event.addListener(marker, 'click', () => {
                            const content = `<div style="padding:5px;font-size:12px;">${place.place_name}</div>`;
                            this.contentNode.innerHTML = content;
                            this.placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
                            this.placeOverlay.setMap(this.map);
                        });
                    },

                    // ------------------------------- 카카오 지도 --------------------------------                    
                    // ✅ 지도 초기화 함수로 분리
                    initMap() {
                        kakao.maps.load(() => {
                            const mapContainer = document.getElementById('map');
                            const roadviewContainer = document.getElementById('roadview');
                            const roadviewBtn = document.getElementById('roadviewBtn');

                            if (!mapContainer) return;

                            const mapOption = {
                                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                                level: 5
                            };

                            this.map = new kakao.maps.Map(mapContainer, mapOption);
                            this.ps = new kakao.maps.services.Places(this.map);
                            this.placeOverlay = new kakao.maps.CustomOverlay({ zIndex: 1 });
                            this.contentNode = document.createElement('div');

                            const roadview = new kakao.maps.Roadview(roadviewContainer);
                            const roadviewClient = new kakao.maps.RoadviewClient();
                            let lastClickedLatLng = null;

                            kakao.maps.event.addListener(this.map, 'click', (mouseEvent) => {
                                const clickedLatLng = mouseEvent.latLng;
                                lastClickedLatLng = clickedLatLng;
                                this.map.panTo(clickedLatLng);
                                this.removeMarker();

                                const marker = new kakao.maps.Marker({
                                    position: clickedLatLng,
                                    map: this.map
                                });

                                this.markers.push(marker);
                                roadviewBtn.style.display = 'block';
                            });

                            roadviewBtn.addEventListener('click', () => {
                                if (!lastClickedLatLng) return;

                                roadviewClient.getNearestPanoId(lastClickedLatLng, 50, function (panoId) {
                                    if (panoId) {
                                        mapContainer.style.display = 'none';
                                        roadviewContainer.style.display = 'block';
                                        roadviewBtn.style.display = 'none';

                                        roadview.setPanoId(panoId, lastClickedLatLng);

                                        kakao.maps.event.addListenerOnce(roadview, 'init', function () {
                                            const overlayContent = document.createElement('div');
                                            const customOverlay = new kakao.maps.CustomOverlay({
                                                content: overlayContent,
                                                position: lastClickedLatLng,
                                                xAnchor: 0.5,
                                                yAnchor: 0.5
                                            });

                                            customOverlay.setMap(roadview);

                                            const projection = roadview.getProjection();
                                            const viewpoint = projection.viewpointFromCoords(
                                                customOverlay.getPosition(),
                                                customOverlay.getAltitude()
                                            );
                                            roadview.setViewpoint(viewpoint);
                                        });
                                    }
                                });
                            });
                        });
                    }
                },
                mounted() {


                    this.$nextTick(() => {
                        this.initMap();
                        waitForImagesThenStartSlider();


                    });
                    let self = this;

                    if (this.nickname && this.nickname !== "${sessionNickname}") {
                        this.isLoggedIn = true;
                    }
                    // ------------------------------구글 번역 -------------------------------------------                    
                    {
                        new google.translate.TranslateElement({ pageLanguage: 'ko', autoDisplay: false }, 'google_translate_element');
                    }

                    const track = document.getElementById('sliderTrack');
                    const images = track.querySelectorAll('img');
                    let loadedCount = 0;

                    images.forEach(img => {
                        img.onload = () => {
                            loadedCount++;
                            if (loadedCount === images.length) {
                                startSlider();
                            }
                        };
                    });
                    //--------------------------------장소마커------------------------------------
                    const mapContainer = document.getElementById('map');
                    const mapOption = {
                        center: new kakao.maps.LatLng(37.566826, 126.9786567),
                        level: 5
                    };

                    this.map = new kakao.maps.Map(mapContainer, mapOption);
                    this.ps = new kakao.maps.services.Places(this.map);

                    this.placeOverlay = new kakao.maps.CustomOverlay({ zIndex: 1 });
                    this.contentNode = document.createElement('div');
                    this.contentNode.className = 'placeinfo_wrap';
                    this.placeOverlay.setContent(this.contentNode);

                    kakao.maps.event.addListener(this.map, 'idle', this.searchPlaces);

                    // ✅ 이 줄이 빠졌을 경우 오류 발생
                    const categoryItems = document.querySelectorAll('#category li');

                    categoryItems.forEach(item => {
                        item.addEventListener('click', () => {
                            categoryItems.forEach(el => el.classList.remove('on'));
                            item.classList.add('on');

                            this.currCategory = item.id;
                            this.searchPlaces();
                        });
                    });


                    //------------------------------------- 카카오 지도 -------------------------------------------


                    this.$nextTick(() => {
                        kakao.maps.load(() => {
                            const mapContainer = document.getElementById('map');
                            const roadviewContainer = document.getElementById('roadview');
                            const roadviewBtn = document.getElementById('roadviewBtn');

                            if (!mapContainer) return;

                            const mapOption = {
                                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                                level: 5
                            };

                            this.map = new kakao.maps.Map(mapContainer, mapOption);
                            this.ps = new kakao.maps.services.Places(this.map);
                            this.placeOverlay = new kakao.maps.CustomOverlay({ zIndex: 1 });
                            this.contentNode = document.createElement('div');

                            const roadview = new kakao.maps.Roadview(roadviewContainer);
                            const roadviewClient = new kakao.maps.RoadviewClient();
                            let lastClickedLatLng = null;

                            kakao.maps.event.addListener(this.map, 'click', (mouseEvent) => {
                                const clickedLatLng = mouseEvent.latLng;
                                lastClickedLatLng = clickedLatLng;
                                this.map.panTo(clickedLatLng);
                                this.removeMarker();

                                const marker = new kakao.maps.Marker({
                                    position: clickedLatLng,
                                    map: this.map
                                });

                                this.markers.push(marker);
                                roadviewBtn.style.display = 'block';
                            });

                            roadviewBtn.addEventListener('click', () => {
                                if (!lastClickedLatLng) return;

                                roadviewClient.getNearestPanoId(lastClickedLatLng, 50, function (panoId) {
                                    if (panoId) {
                                        mapContainer.style.display = 'none';
                                        roadviewContainer.style.display = 'block';
                                        roadviewBtn.style.display = 'none';

                                        roadview.setPanoId(panoId, lastClickedLatLng);

                                        kakao.maps.event.addListenerOnce(roadview, 'init', function () {
                                            const overlayContent = document.createElement('div');
                                            const customOverlay = new kakao.maps.CustomOverlay({
                                                content: overlayContent,
                                                position: lastClickedLatLng,
                                                xAnchor: 0.5,
                                                yAnchor: 0.5
                                            });

                                            customOverlay.setMap(roadview);

                                            const projection = roadview.getProjection();
                                            const viewpoint = projection.viewpointFromCoords(
                                                customOverlay.getPosition(),
                                                customOverlay.getAltitude()
                                            );
                                            roadview.setViewpoint(viewpoint);
                                        });
                                    }
                                });
                            });
                        });
                    });
                }
            });

            app.mount('#app');
            //--------------------------배너  슬라이더 ------------------------------
            // ✅ 슬라이더 애니메이션 함수
            function startSlider() {
                const track = document.getElementById('sliderTrack');
                if (!track) return;

                const images = track.querySelectorAll('img');
                if (images.length === 0) return;

                const imageWidth = images[0].offsetWidth;
                const gap = 5;
                const imageCount = images.length;
                const totalWidth = imageCount * imageWidth + (imageCount - 1) * gap;

                track.style.width = totalWidth + 'px';

                const oldClone = document.getElementById('sliderClone');
                if (oldClone) oldClone.remove();

                const clone = track.cloneNode(true);
                clone.setAttribute('id', 'sliderClone');
                clone.classList.add('slider-track');
                track.parentNode.appendChild(clone);

                const cloneOffset = totalWidth + gap;
                clone.style.left = cloneOffset + 'px';
                track.style.position = 'absolute';
                clone.style.position = 'absolute';

                let position = 0;
                const speed = 1;

                function animateSlider() {
                    position -= speed;
                    track.style.left = position + 'px';
                    clone.style.left = (position + cloneOffset) + 'px';

                    if (position <= -cloneOffset) {
                        position = 0;
                    }

                    requestAnimationFrame(animateSlider);
                }

                animateSlider();
            }

            // ✅ 이미지 로딩 후 슬라이더 실행
            function waitForImagesThenStartSlider() {
                const track = document.getElementById('sliderTrack');
                if (!track) return;

                const images = track.querySelectorAll('img');
                let loadedCount = 0;

                images.forEach(img => {
                    if (img.complete) {
                        loadedCount++;
                    } else {
                        img.onload = () => {
                            loadedCount++;
                            if (loadedCount === images.length) {
                                startSlider();
                            }
                        };
                    }
                });

                if (loadedCount === images.length) {
                    startSlider();
                }
            }

            // ✅ 페이지 복귀 시 지도와 슬라이더 재실행
            window.addEventListener('pageshow', () => {
                if (app && app._instance && app._instance.proxy.initMap) {
                    app._instance.proxy.initMap();
                }
                waitForImagesThenStartSlider();
            });


        </script>
    </body>

    </html>