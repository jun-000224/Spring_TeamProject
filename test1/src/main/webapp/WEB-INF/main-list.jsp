<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trip Clone Site</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
        <link rel="stylesheet" href="/css/main-style.css">
        <link rel="stylesheet" href="/css/common-style.css">
        <link rel="stylesheet" href="/css/header-style.css">
        <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"></script>
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



            <header>
                <div class="logo">
                    <a href="http://localhost:8081/main-list.do">
                        <!-- <img src="이미지.png" alt="Team Project"> -->
                    </a>
                </div>
                <h1 class="logo">
                    <a href="#">Team Project</a>
                </h1>
                <nav>
                    <ul>
                        <li class="main-menu"><a href="#">여행하기</a></li>
                        <li class="main-menu"><a href="#">커뮤니티</a></li>
                        <li class="main-menu"><a href="#">마이페이지</a></li>
                    </ul>
                </nav>

                <div style="display: flex; align-items: center; gap: 15px;">
                    <div class="login-btn">
                        <button>로그인</button>
                    </div>
                </div>
            </header>
            <div class="hero-section">
                <div class="map_wrap">
                    <div id="map" style="width:100%;height:100%;position:relative;overflow:hidden;"></div>
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
            <main>
                <div id="google_translate_element">
                </div>
            </main>
            <footer>
                <div class="footer-content">
                    <div class="footer-links" style="display: flex">
                        <div class="footer-section">
                            <h4>회사 소개</h4>
                            <ul>
                                <li><a href="#">회사 연혁</a></li>
                                <li><a href="#">인재 채용</a></li>
                                <li><a href="#">투자자 정보</a></li>
                                <li><a href="#">제휴 및 협력</a></li>
                            </ul>
                        </div>
                        <div class="footer-section">
                            <h4>지원</h4>
                            <ul>
                                <li><a href="#">고객센터</a></li>
                                <li><a href="#">자주 묻는 질문</a></li>
                                <li><a href="#">개인정보 처리방침</a></li>
                                <li><a href="#">이용 약관</a></li>
                            </ul>
                        </div>
                        <div class="footer-section">
                            <h4>여행 상품</h4>
                            <ul>
                                <li><a href="#">호텔</a></li>
                                <li><a href="#">항공권</a></li>
                                <li><a href="#">렌터카</a></li>
                                <li><a href="#">투어 & 티켓</a></li>
                            </ul>
                        </div>
                        <div class="footer-section">
                            <h4>문의 및 제휴</h4>
                            <ul>
                                <li><a href="#">파트너십 문의</a></li>
                                <li><a href="#">광고 문의</a></li>
                                <li><a href="#">이메일: team@project.com</a></li>
                                <li><a href="#">대표전화: 02-1234-5678</a></li>
                            </ul>
                        </div>
                    </div>

                    <div class="footer-bottom">
                        <p>&copy; 2025 Team Project. All Rights Reserved. | 본 사이트는 프로젝트 학습 목적으로 제작되었습니다.
                        </p>
                    </div>
                </div>
            </footer>
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
                        currCategory: ''
                    };
                },
                methods: {
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
                    removeMarker() {
                        for (let i = 0; i < this.markers.length; i++) {
                            this.markers[i].setMap(null);
                        }
                        this.markers = [];
                    }

                },
                mounted() {
                    let self = this;
                    {
                        new google.translate.TranslateElement({ pageLanguage: 'ko', autoDisplay: false }, 'google_translate_element');
                    }
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
                }

                // **!!! 카카오맵 초기화 코드 모두 제거 (initMap으로 분리) !!!**

                // Google 번역 초기화 (카카오맵과 무관하므로 여기에 유지)



            });
            app.mount('#app');
            // Vue 인스턴스를 전역 변수에 할당
        </script>
    </body>

    </html>