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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
            integrity="sha512-..." crossorigin="anonymous" referrerpolicy="no-referrer" />

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
                        <div class="slider-mask">
                            <div class="slider-track" id="sliderTrack">
                                <a href="main-list.do" target="_blank"><img src="/images/banner1.jpg" alt="배너1"></a>
                                <a href="main-list.do" target="_blank"><img src="/images/banner2.jpg" alt="배너2"></a>
                                <a href="main-list.do" target="_blank"><img src="/images/banner3.jpg" alt="배너3"></a>
                                <a href="main-list.do" target="_blank"><img src="/images/banner4.jpg" alt="배너4"></a>
                                <a href="main-list.do" target="_blank"><img src="/images/banner5.jpg" alt="배너5"></a>
                            </div>
                            <div id="sliderClone"></div>
                        </div>
                        <button class="slider-arrow left"><i class="fas fa-angle-left"></i></button>
                        <button class="slider-arrow right"><i class="fas fa-angle-right"></i></button>
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
                            <button id="exitRoadviewBtn" style="
                            position: absolute;
                            top: 10px;
                            right: 80px;
                            z-index: 10;
                            padding: 8px 12px;
                            background-color: #FF5050;
                            color: white;
                            border: none;
                            border-radius: 5px;
                            cursor: pointer;
                            display: none;">나가기</button>

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
                        <div class="promo-card">
                            <img src="/images/your-banner.jpg" alt="11.11 메가세일">
                            <div class="promo-info">
                                <h4>11.11 메가세일 🎉</h4>
                                <p>항공권·호텔 최대 <strong>91%</strong> 할인!</p>
                                <a href="/event/mega-sale" class="promo-btn">지금 확인하기</a>
                            </div>
                        </div>
                    </div>

                    <!-- 지도 아래에 POI 순위 테이블 추가 -->
                    <!-- 지역 선택 탭 -->


                    <div class="region-tabs">
                        <h2 class="region-title" style="text-align: center;">인기 호텔 및 숙소</h2>
                        <div class="button-group">

                            <div class="region-buttons">
                                <button class="hotel-btn active" data-region="jeju">제주</button>
                                <button class="hotel-btn" data-region="busan">부산</button>
                                <button class="hotel-btn" data-region="gyeonggi">경기</button>
                                <button class="hotel-btn" data-region="daegu">대구</button>
                                <button class="hotel-btn" data-region="cheongju">강릉</button>
                                <button class="hotel-btn" data-region="yeosu">여수</button>
                            </div>
                        </div>
                    </div>
                    <br>

                    <!-- 지역별 호텔 리스트 -->
                    <div class="region-hotels">

                        <!-- 제주 -->
                        <div class="hotel-list active" id="jeju">
                            <div class="hotel-card">
                                <img src="/images/jeju.jpg" alt="맹그로브 제주시티">
                                <div class="hotel-details">
                                    <div class="hotel-name">맹그로브 제주시티</div>
                                    <div class="hotel-rating">⭐ 9.2 <span>(313명 리뷰)</span></div>
                                    <div class="hotel-price">₩92,710 / 1박</div>
                                </div>
                            </div>
                            <div class="hotel-card">
                                <img src="/images/jeju2.jpg" alt="라마다 제주시티호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">라마다 제주시티호텔</div>
                                    <div class="hotel-rating">⭐ 8.6 <span>(943명 리뷰)</span></div>
                                    <div class="hotel-price">₩148,506 / 1박</div>
                                </div>
                            </div>
                            <!-- 초특가 호텔 카드 -->
                            <div class="hotel-card">
                                <img src="/images/global.jpg" alt="전 세계 초특가 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">🌍 전 세계 초특가 호텔</div>
                                    <div class="hotel-rating">지금 예약하면 최대 70% 할인!</div>
                                    <a href="/global-deals" class="deal-btn">지금 예약하기</a>
                                </div>
                            </div>
                        </div>


                        <!-- 부산 -->
                        <div class="hotel-list" id="busan">
                            <div class="hotel-card">
                                <img src="/images/busan.jpg" alt="부산 오션뷰 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">부산 오션뷰 호텔</div>
                                    <div class="hotel-rating">⭐ 8.9 <span>(512명 리뷰)</span></div>
                                    <div class="hotel-price">₩132,000 / 1박</div>
                                </div>
                            </div>
                            <div class="hotel-card">
                                <img src="/images/busan2.jpg" alt="부산 센텀호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">부산 센텀호텔</div>
                                    <div class="hotel-rating">⭐ 8.4 <span>(678명 리뷰)</span></div>
                                    <div class="hotel-price">₩119,000 / 1박</div>
                                </div>
                            </div>
                            <!-- 초특가 호텔 카드 -->
                            <div class="hotel-card">
                                <img src="/images/global.jpg" alt="전 세계 초특가 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">🌍 전 세계 초특가 호텔</div>
                                    <div class="hotel-rating">지금 예약하면 최대 70% 할인!</div>
                                    <a href="/global-deals" class="deal-btn">지금 예약하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 경기 -->
                        <div class="hotel-list" id="gyeonggi">
                            <div class="hotel-card">
                                <img src="/images/suwon.jpg" alt="수원 노보텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">수원 노보텔</div>
                                    <div class="hotel-rating">⭐ 8.7 <span>(421명 리뷰)</span></div>
                                    <div class="hotel-price">₩110,000 / 1박</div>
                                </div>
                            </div>
                            <div class="hotel-card">
                                <img src="/images/suwon2.jpg" alt="더블트리 바이 힐튼 서울 판교">
                                <div class="hotel-details">
                                    <div class="hotel-name">더블트리 바이 힐튼 서울 판교</div>
                                    <div class="hotel-rating">⭐ 9.1 <span>(1,200명 리뷰)</span></div>
                                    <div class="hotel-price">₩165,000 / 1박</div>
                                </div>
                            </div>
                            <!-- 초특가 호텔 카드 -->
                            <div class="hotel-card">
                                <img src="/images/global.jpg" alt="전 세계 초특가 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">🌍 전 세계 초특가 호텔</div>
                                    <div class="hotel-rating">지금 예약하면 최대 70% 할인!</div>
                                    <a href="/global-deals" class="deal-btn">지금 예약하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 대구 -->
                        <div class="hotel-list" id="daegu">
                            <div class="hotel-card">
                                <img src="/images/dagu.jpg" alt="대구 인터불고 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">대구 인터불고 호텔</div>
                                    <div class="hotel-rating">⭐ 8.5 <span>(389명 리뷰)</span></div>
                                    <div class="hotel-price">₩105,000 / 1박</div>
                                </div>
                            </div>
                            <div class="hotel-card">
                                <img src="/images/dagu2.jpg" alt="토요코인 대구 동성로">
                                <div class="hotel-details">
                                    <div class="hotel-name">토요코인 대구 동성로</div>
                                    <div class="hotel-rating">⭐ 9.0 <span>(1,050명 리뷰)</span></div>
                                    <div class="hotel-price">₩89,000 / 1박</div>
                                </div>
                            </div>
                            <!-- 초특가 호텔 카드 -->
                            <div class="hotel-card">
                                <img src="/images/global.jpg" alt="전 세계 초특가 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">🌍 전 세계 초특가 호텔</div>
                                    <div class="hotel-rating">지금 예약하면 최대 70% 할인!</div>
                                    <a href="/global-deals" class="deal-btn">지금 예약하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 강릉 -->
                        <div class="hotel-list" id="cheongju">
                            <div class="hotel-card">
                                <img src="/images/gang.jpg" alt="세인트존스 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">세인트존스 호텔</div>
                                    <div class="hotel-rating">⭐ 8.3 <span>(274명 리뷰)</span></div>
                                    <div class="hotel-price">₩98,000 / 1박</div>
                                </div>
                            </div>
                            <div class="hotel-card">
                                <img src="/images/gang2.jpg" alt="스카이베이 호텔 경포">
                                <div class="hotel-details">
                                    <div class="hotel-name">스카이베이 호텔 경포</div>
                                    <div class="hotel-rating">⭐ 8.9 <span>(504명 리뷰)</span></div>
                                    <div class="hotel-price">₩109,000 / 1박</div>
                                </div>
                            </div>
                            <!-- 초특가 호텔 카드 -->
                            <div class="hotel-card">
                                <img src="/images/global.jpg" alt="전 세계 초특가 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">🌍 전 세계 초특가 호텔</div>
                                    <div class="hotel-rating">지금 예약하면 최대 70% 할인!</div>
                                    <a href="/global-deals" class="deal-btn">지금 예약하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 여수 -->
                        <div class="hotel-list" id="yeosu">
                            <div class="hotel-card">
                                <img src="/images/yeosu.jpg" alt="라마다프라자 바이 윈덤 여수">
                                <div class="hotel-details">
                                    <div class="hotel-name">라마다프라자 바이 윈덤 여수</div>
                                    <div class="hotel-rating">⭐ 9.0 <span>(502명 리뷰)</span></div>
                                    <div class="hotel-price">₩125,000 / 1박</div>
                                </div>
                            </div>
                            <div class="hotel-card">
                                <img src="/images/yeosu2.jpg" alt="여수 베네치아호텔 & 스위트">
                                <div class="hotel-details">
                                    <div class="hotel-name">여수 베네치아호텔 & 스위트</div>
                                    <div class="hotel-rating">⭐ 9.2 <span>(4,097명 리뷰)</span></div>
                                    <div class="hotel-price">₩158,000 / 1박</div>
                                </div>
                            </div>

                            <!-- 초특가 호텔 카드 -->
                            <div class="hotel-card">
                                <img src="/images/global.jpg" alt="전 세계 초특가 호텔">
                                <div class="hotel-details">
                                    <div class="hotel-name">🌍 전 세계 초특가 호텔</div>
                                    <div class="hotel-rating">지금 예약하면 최대 70% 할인!</div>
                                    <a href="/global-deals" class="deal-btn">지금 예약하기</a>
                                </div>
                            </div>
                        </div>

                    </div>
                    <br>
                    <!-- 여행지 선택 탭 -->
                    <div class="region-tabs">
                        <h2 class="section-title" style="text-align: center;">추천 여행지</h2>
                        <div class="button-group">

                            <div class="region-buttons">
                                <button class="travel-btn active" data-city="dubai">두바이</button>
                                <button class="travel-btn" data-city="rome">로마</button>
                                <button class="travel-btn" data-city="shanghai">상하이</button>
                                <button class="travel-btn" data-city="sydney">시드니</button>
                                <button class="travel-btn" data-city="la">LA</button>
                                <button class="travel-btn" data-city="paris">파리</button>
                            </div>
                        </div>
                    </div>
                    <br>
                    <!-- 도시별 추천 여행지 리스트 -->
                    <div class="region-destinations">

                        <!-- 두바이 -->
                        <div class="destination-list active" id="dubai">
                            <div class="dest-card">
                                <img src="/images/burj.jpg" alt="부르즈 할리파">
                                <div class="dest-info">
                                    <div class="dest-name">부르즈 할리파</div>
                                    <div class="dest-rating">⭐ 4.6 <span>(5,315개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 1.2k &nbsp;&nbsp; 💖 980 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card">
                                <img src="/images/palm.jpg" alt="더 뷰 앳 더 팜">
                                <div class="dest-info">
                                    <div class="dest-name">더 뷰 앳 더 팜</div>
                                    <div class="dest-rating">⭐ 4.6 <span>(469개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 6418 &nbsp;&nbsp; 💖 510 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>

                            <div class="dest-card highlight-card">
                                <img src="/images/global1.jpg" alt="인기 여행지">
                                <div class="dest-info">
                                    <div class="dest-name">🌍 인기 여행지</div>
                                    <div class="hotel-rating">지금 예약하면 최대 50% 할인!</div>
                                    <a href="/popular-destinations" class="deal-btn">지금 확인하기</a>
                                </div>
                            </div>
                        </div>
                        <!-- 로마 -->
                        <div class="destination-list" id="rome">
                            <div class="dest-card">
                                <img src="/images/colosseum.jpg" alt="콜로세움">
                                <div class="dest-info">
                                    <div class="dest-name">콜로세움</div>
                                    <div class="dest-rating">⭐ 4.7 <span>(8,120개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 2.6k &nbsp;&nbsp; 💖 2510 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card">
                                <img src="/images/vatican.jpg" alt="바티칸 박물관">
                                <div class="dest-info">
                                    <div class="dest-name">바티칸 박물관</div>

                                    <div class="dest-rating">⭐ 4.6 <span>(6,540개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 1.4k &nbsp;&nbsp; 💖 1260 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card highlight-card">
                                <img src="/images/global1.jpg" alt="인기 여행지">
                                <div class="dest-info">
                                    <div class="dest-name">🌍 인기 여행지</div>
                                    <div class="hotel-rating">지금 예약하면 최대 50% 할인!</div>
                                    <a href="/popular-destinations" class="deal-btn">지금 확인하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 상하이 -->
                        <div class="destination-list" id="shanghai">
                            <div class="dest-card">
                                <img src="/images/tower.jpg" alt="동방명주">
                                <div class="dest-info">
                                    <div class="dest-name">동방명주</div>
                                    <div class="dest-rating">⭐ 4.5 <span>(2,870개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 2257 &nbsp;&nbsp; 💖 280 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card">
                                <img src="/images/disney.jpg" alt="상하이 디즈니랜드">
                                <div class="dest-info">
                                    <div class="dest-name">상하이 디즈니랜드</div>
                                    <div class="dest-rating">⭐ 4.7 <span>(9,120개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 5.4k &nbsp;&nbsp; 💖 3980 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card highlight-card">
                                <img src="/images/global1.jpg" alt="인기 여행지">
                                <div class="dest-info">
                                    <div class="dest-name">🌍 인기 여행지</div>
                                    <div class="hotel-rating">지금 예약하면 최대 50% 할인!</div>
                                    <a href="/popular-destinations" class="deal-btn">지금 확인하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 시드니 -->
                        <div class="destination-list" id="sydney">
                            <div class="dest-card">
                                <img src="/images/opera.jpg" alt="오페라 하우스">
                                <div class="dest-info">
                                    <div class="dest-name">오페라 하우스</div>
                                    <div class="dest-rating">⭐ 4.8 <span>(7,310개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 8653 &nbsp;&nbsp; 💖 1284 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card">
                                <img src="/images/bridge.jpg" alt="하버 브리지">
                                <div class="dest-info">
                                    <div class="dest-name">하버 브리지</div>
                                    <div class="dest-rating">⭐ 4.6 <span>(5,420개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 1.8k &nbsp;&nbsp; 💖 1820 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card highlight-card">
                                <img src="/images/global1.jpg" alt="인기 여행지">
                                <div class="dest-info">
                                    <div class="dest-name">🌍 인기 여행지</div>
                                    <div class="hotel-rating">지금 예약하면 최대 50% 할인!</div>
                                    <a href="/popular-destinations" class="deal-btn">지금 확인하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- LA -->
                        <div class="destination-list" id="la">
                            <div class="dest-card">
                                <img src="/images/hollywood.jpg" alt="할리우드 사인">
                                <div class="dest-info">
                                    <div class="dest-name">할리우드 사인</div>
                                    <div class="dest-rating">⭐ 4.6 <span>(4,890개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 3.9k &nbsp;&nbsp; 💖 1460 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card">
                                <img src="/images/santamonica.jpg" alt="산타모니카 해변">
                                <div class="dest-info">
                                    <div class="dest-name">산타모니카 해변</div>
                                    <div class="dest-rating">⭐ 4.7 <span>(5,320개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 1.6k &nbsp;&nbsp; 💖 1105 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card highlight-card">
                                <img src="/images/global1.jpg" alt="인기 여행지">
                                <div class="dest-info">
                                    <div class="dest-name">🌍 인기 여행지</div>
                                    <div class="hotel-rating">지금 예약하면 최대 50% 할인!</div>
                                    <a href="/popular-destinations" class="deal-btn">지금 확인하기</a>
                                </div>
                            </div>
                        </div>

                        <!-- 파리 -->
                        <div class="destination-list" id="paris">
                            <div class="dest-card">
                                <img src="/images/eiffel.jpg" alt="에펠탑">
                                <div class="dest-info">
                                    <div class="dest-name">에펠탑</div>
                                    <div class="dest-rating">⭐ 4.8 <span>(10,210개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 7.2k &nbsp;&nbsp; 💖 5980 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card">
                                <img src="/images/louvre.jpg" alt="루브르 박물관">
                                <div class="dest-info">
                                    <div class="dest-name">루브르 박물관</div>
                                    <div class="dest-rating">⭐ 4.7 <span>(8,430개 리뷰)</span></div>
                                    <div class="dest-reactions">
                                        👍 1.8k &nbsp;&nbsp; 💖 520 &nbsp;&nbsp; 📷 포토존
                                    </div>
                                </div>
                            </div>
                            <div class="dest-card highlight-card">
                                <img src="/images/global1.jpg" alt="인기 여행지">
                                <div class="dest-info">
                                    <div class="dest-name">🌍 인기 여행지</div>
                                    <div class="hotel-rating">지금 예약하면 최대 50% 할인!</div>
                                    <a href="/popular-destinations" class="deal-btn">지금 확인하기</a>
                                </div>
                            </div>
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
                    currCategory: '',

                    //새 페이지 개설 시, 복붙
                    //------------------------------------------------------------------------------------------------------
                    id: window.sessionData.id,
                    status: window.sessionData.status,
                    nickname: window.sessionData.nickname,
                    name: window.sessionData.name,
                    point: window.sessionData.point,



                    // tempProperties : {}
                    //------------------------------------------------------------------------------------------------------
                };
            },
            methods: {

                //복붙
                //------------------------------------------------------------------------------------------------------
                // toggleLogoutMenu() {
                //     this.showLogoutMenu = !this.showLogoutMenu;
                // },
                //------------------------------------------------------------------------------------------------------

                goToService() {
                    location.href = "/Service.do";
                },


                removeMarker() {
                    for (let i = 0; i < this.markers.length; i++) {
                        this.markers[i].setMap(null);
                    }
                    this.markers = [];
                },
                // goToMyPage() {
                //     location.href = "/main-myPage.do";
                // },

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

                initMap() {
                    kakao.maps.load(() => {
                        const mapContainer = document.getElementById('map');
                        const roadviewContainer = document.getElementById('roadview');
                        const roadviewBtn = document.getElementById('roadviewBtn');
                        exitRoadviewBtn.addEventListener('click', () => {
                            location.href = "/main-list.do"; // ✅ 원하는 페이지로 이동
                        });


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
                                    exitRoadviewBtn.style.display = 'block';
                                    roadview.setPanoId(panoId, lastClickedLatLng);
                                    function handleInit() {
                                        const overlayContent = document.createElement('div');
                                        overlayContent.style.pointerEvents = 'none'; //  커서 방지
                                        overlayContent.style.cursor = 'default';     //  커서 방지

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

                                        kakao.maps.event.removeListener(roadview, 'init', handleInit); //한 번만 실행되도록 제거
                                    }

                                    kakao.maps.event.addListener(roadview, 'init', handleInit);
                                }
                            });
                        });
                    });
                }

            },
            mounted() {
                // 호텔 버튼 제어
                const hotelButtons = document.querySelectorAll('.hotel-btn');
                const hotelLists = document.querySelectorAll('.hotel-list');

                hotelButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        hotelButtons.forEach(btn => btn.classList.remove('active'));
                        button.classList.add('active');

                        const selectedRegion = button.getAttribute('data-region');
                        hotelLists.forEach(list => {
                            list.classList.remove('active');
                            if (list.id === selectedRegion) {
                                list.classList.add('active');
                            }
                        });
                    });
                });

                // 여행지 버튼 제어
                const travelButtons = document.querySelectorAll('.travel-btn');
                const travelLists = document.querySelectorAll('.destination-list');

                travelButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        travelButtons.forEach(btn => btn.classList.remove('active'));
                        button.classList.add('active');

                        const selectedCity = button.getAttribute('data-city');
                        travelLists.forEach(list => {
                            list.classList.remove('active');
                            if (list.id === selectedCity) {
                                list.classList.add('active');
                            }
                        });
                    });
                });

                this.$nextTick(() => {

                    this.initMap();
                    waitForImagesThenStartSlider();
                    startSlider();
                    animateSlider();


                    // ✅ 강제 재실행: 페이지 돌아올 때 슬라이더 복구
                    setTimeout(() => {
                        const track = document.getElementById('sliderTrack');
                        if (track && track.offsetWidth === 0) {
                            // 이미지가 아직 로드되지 않았거나 슬라이더가 멈춰있음
                            waitForImagesThenStartSlider();
                            startSlider();
                            animateSlider();
                        }
                    }, 500); // 0.5초 후 강제 재실행

                });
                let self = this;

                const queryParams = new URLSearchParams(window.location.search);
                window.code = queryParams.get('code') || '';
                if (window.code != null) {
                    fnKakao();
                }

                if (this.nickname && this.nickname !== "${sessionNickname}") {
                    this.isLoggedIn = true;
                }
                // ------------------------------구글 번역 -------------------------------------------                    
                {
                    new google.translate.TranslateElement({ pageLanguage: 'ko', autoDisplay: false }, 'google_translate_element');
                }

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
                        const exitRoadviewBtn = document.getElementById('exitRoadviewBtn'); // 나가기

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

                        exitRoadviewBtn.addEventListener('click', () => {
                            location.href = "/main-list.do"; // ✅ 원하는 페이지로 이동
                        });


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
                                    exitRoadviewBtn.style.display = 'block'; // ✅ 이 줄이 꼭 있어야 함
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


        //--------------------------배너 슬라이더 ------------------------------
        function startSlider() {
            const track = document.getElementById('sliderTrack');
            if (!track) return;

            document.querySelectorAll('.slider-track a').forEach(anchor => {
                anchor.classList.remove('active');
            });

            const images = track.querySelectorAll('img');
            if (images.length === 0) return;

            const imageWidth = images[0].offsetWidth;
            const gap = 10;
            const spacerGap = 1; // ✅ 간격 크기 조절 가능
            const imageCount = images.length;
            const totalWidth = imageCount * imageWidth + (imageCount - 1) * gap;


            track.style.width = totalWidth + 'px';

            // ✅ 기존 clone 제거
            const oldClone = document.getElementById('sliderClone');
            if (oldClone) oldClone.remove();

            // ✅ 복제 트랙 생성
            const clone = track.cloneNode(true);
            clone.setAttribute('id', 'sliderClone');
            clone.classList.add('slider-track');
            clone.style.pointerEvents = 'none';
            clone.style.position = 'absolute';
            clone.style.width = totalWidth + 'px';

            // ✅ 간격용 spacer 추가
            const spacer = document.createElement('div');
            spacer.style.width = spacerGap + 'px';
            spacer.style.height = '1px';
            spacer.style.position = 'absolute';
            spacer.style.left = totalWidth + 'px';
            spacer.style.top = '0px';

            // ✅ 트랙, 간격, 복제 순서대로 삽입
            track.parentNode.appendChild(spacer);
            track.parentNode.appendChild(clone);

            // ✅ 복제 트랙에도 동일한 스타일 적용
            clone.style.display = 'flex';
            clone.style.gap = '10px';
            clone.querySelectorAll('a').forEach(anchor => {
                anchor.style.borderRadius = '12px';
                anchor.style.overflow = 'hidden';
            });

            const cloneOffset = totalWidth + gap + spacerGap;
            clone.style.left = cloneOffset + 'px';
            track.style.left = '0px';
            track.style.position = 'absolute';

            let sliderAnimationId = null;
            let position = 0;
            const speed = 1;


            function animateSlider() {
                position -= speed;

                track.style.transition = 'none';
                clone.style.transition = 'none';

                track.style.left = position + 'px';
                clone.style.left = (position + cloneOffset) + 'px';

                updateActiveSlide();

                if (position <= -cloneOffset) {
                    position = 0;
                }

                sliderAnimationId = requestAnimationFrame(animateSlider);
            }

            function stopSlider() {
                if (sliderAnimationId) {
                    cancelAnimationFrame(sliderAnimationId);
                    sliderAnimationId = null;
                }
            }


            animateSlider();

            document.querySelector('.slider-arrow.left').addEventListener('click', () => {
                stopSlider();
                position += 410;

                // 무한 반복 처리: 왼쪽 끝을 넘었을 때 리셋
                if (position > 0) {
                    position = -cloneOffset + 410;
                }

                track.style.left = position + 'px';
                clone.style.left = (position + cloneOffset) + 'px';
            });

            document.querySelector('.slider-arrow.right').addEventListener('click', () => {
                stopSlider();
                position -= 410;

                // 무한 반복 처리: 오른쪽 끝을 넘었을 때 리셋
                if (Math.abs(position) > cloneOffset) {
                    position = 0;
                }

                track.style.left = position + 'px';
                clone.style.left = (position + cloneOffset) + 'px';
            });

        }




        function updateActiveSlide() {
            const centerX = window.innerWidth / 2;
            const anchors = [];

            document.querySelectorAll('.slider-track').forEach(track => {
                anchors.push(...track.querySelectorAll('a'));
            });
            anchors.forEach(anchor => {
                const rect = anchor.getBoundingClientRect();
                const anchorCenter = rect.left + rect.width / 2;
                const distance = Math.abs(centerX - anchorCenter);

                if (distance < rect.width * 0.3) {
                    anchor.classList.add('active');
                } else {
                    anchor.classList.remove('active');
                }
            });
        }

        // 이미지 로딩 후 슬라이더 실행
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

        // 페이지 복귀 시 지도와 슬라이더 재실행
        window.addEventListener('popstate', () => {
            const track = document.getElementById('sliderTrack');
            if (track && track.offsetWidth === 0) {
                waitForImagesThenStartSlider();
                startSlider();
            }
        });


        app.mount('#app');
    </script>