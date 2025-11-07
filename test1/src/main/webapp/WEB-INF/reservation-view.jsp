<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 상세 확인</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services"></script>
    
    <%-- 🛑 [수정] reservation.jsp와 동일한 CSS 파일 링크 추가 --%>
    <link rel="stylesheet" href="/css/main-style.css">
    <link rel="stylesheet" href="/css/common-style.css">
    <link rel="stylesheet" href="/css/header-style.css">
    <link rel="stylesheet" href="/css/main-images.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation.css" />


    <style>
        table,
        tr,
        td,
        th {
            border: 1px solid black;
            border-collapse: collapse;
            padding: 5px 10px;
            text-align: center;
        }

        th {
            background-color: beige;
        }

        tr:nth-child(even) {
            background-color: azure;
        }

        .poi-item {
            border-bottom: 1px dashed #eee;
            padding: 5px 0;
        }

        .budget-status-wrap {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            padding: 10px;
            background: #f9f9f9;
            border-radius: 8px;
        }

        .budget-status-item {
            flex: 1;
        }

        .budget-status-item .label {
            font-size: 0.9em;
            color: #555;
            display: block;
        }

        .budget-status-item .amount {
            font-size: 1.2em;
            font-weight: bold;
        }

        .budget-status-item .amount .current {
            color: #d9480f;
        }

        .budget-status-item .amount .total {
            font-size: 0.9em;
            color: #888;
        }

        .packname-form-wrap {
            margin-top: 15px;
            padding: 10px;
            background: #f9f9f9;
            border-radius: 8px;
            display: none;
        }

        .packname-form-wrap input[type="text"] {
            width: 300px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1em;
        }

        .packname-form-wrap button {
            padding: 9px 12px;
            background: #3498db;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            vertical-align: middle;
            font-weight: bold;
        }

        #btn-toggle-packname {
            font-size: 10px;
            margin-left: 5px;
            background: #eee;
            border: 1px solid #ccc;
            padding: 2px 4px;
            cursor: pointer;
            border-radius: 3px;
        }
    </style>
</head>

<body>
    <%-- 🛑 [수정] header.jsp는 wrap 밖으로 이동 --%>
    <%@ include file="components/header.jsp" %>

    <%-- 🛑 [수정] <div class="wrap">이 #app을 감싸도록 수정 --%>
    <div class="wrap">
        <div id="app">

            <h1>예약 상세 확인</h1>

            <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px;">
                <h3>기본 예약 정보 확인</h3>
                <ul>
                    <li>
                        여행 코스 이름 : <input v-model='reservation.packname'></span>
                    </li>
                    <li><strong>총 예산:</strong> {{ formatPrice(reservation.price) }}원</li>
                    <li><strong>여행 기간:</strong> {{ reservation.startDate }} ~ {{ reservation.endDate }}</li>
                    <li><strong>방문 예정 지점 :</strong> 총 {{ reservation.pois ? reservation.pois.length : 0 }}개
                    </li>
                    <li><strong>테마:</strong> {{ reservation.themNum }}</li>
                </ul>
            </div>

            <div class="budget-status-wrap">
                <div class="budget-status-item">
                    <span class="label">기타 예산 (할당량)</span>
                    <span class="amount" id="budget-etc">0원</span>
                </div>
                <div class="budget-status-item">
                    <span class="label">관광지 예산 (할당량)</span>
                    <span class="amount" id="budget-activity">0원</span>
                </div>
                <div class="budget-status-item">
                    <span class="label">숙박 예산 (사용/할당량)</span>
                    <span class="amount" id="budget-accom">
                        <span class="current">0원</span> / <span class="total">0원</span>
                    </span>
                </div>
                <div class="budget-status-item">
                    <span class="label">식당 예산 (사용/할당량)</span>
                    <span class="amount" id="budget-food">
                        <span class="current">0원</span> / <span class="total">0원</span>
                    </span>
                </div>
            </div>

            <hr>

            <h2>🗺️ 여행 경로 지도</h2>
            <div id="map-container" style="width:100%; height:400px; border: 1px solid #ddd;">지도 로딩 중...
            </div>

            <hr>

            <h2>📋 상세 일정 목록</h2>
            <div id="detail-schedule-list">
                <p v-if="poiList.length === 0">유효한 POI 일정이 없습니다.</p>
                <div v-else v-for="(poi, index) in poiList" :key="poi.poiId" class="poi-item">
                    <p>[{{ index + 1 }}] <strong>{{ poi.placeName }}</strong></p>
                    <p>방문 예정일: {{ poi.reservDate }} </p>
                </div>
            </div>
            <div><button @click ="fnSave">저장하기</button></div>
        </div>
    </div> 
    <%@ include file="components/footer.jsp" %>
</body>

</html>

<script>
    const app = Vue.createApp({

        data() {
            return {
                reservation: {
                    resNum: 0,
                    packName: "로딩 중...",
                    price: 0,
                    startDate: "",
                    endDate: "",
                    pois: [],
                    themNum: "",
                    packname: "" 
                },
                poiList: [],
                kakaoAppKey: '${kakaoAppKey}',

                map: null,
                newPackName: "",
                showPacknameForm: false
            };
        },
        methods: {
            fnUpdatePackname() {
                let self = this;
                if (!self.newPackName || self.newPackName.trim() === "") {
                    alert("별칭을 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: '/api/reservation/update/packname',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        resNum: self.reservation.resNum,
                        packName: self.newPackName
                    }),
                    success: function (response) {
                        alert('별칭이 저장되었습니다.');
                        self.reservation.packName = self.newPackName;
                        self.showPacknameForm = false;
                    },
                    error: function (jqXHR) {
                        alert(`저장 실패 (${jqXHR.status}): 백엔드 API 수정이 필요합니다.`);
                    }
                });
            },

            togglePacknameForm() {
                this.showPacknameForm = !this.showPacknameForm;
            },

            formatPrice(value) {
                return value ? value.toLocaleString() : '0';
            },

            initializeMap(markerData) {
                if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
                    console.error("Kakao Map API 로드 실패.");
                    document.getElementById('map-container').innerText = 'Kakao Map API 로드 실패.';
                    return;
                }

                const container = document.getElementById('map-container');
                const options = {
                    center: new kakao.maps.LatLng(markerData[0].mapY, markerData[0].mapX),
                    level: 7
                };

                this.map = new kakao.maps.Map(container, options);

                const bounds = new kakao.maps.LatLngBounds();

                markerData.forEach((poi) => {
                    const markerPosition = new kakao.maps.LatLng(poi.mapY, poi.mapX);
                    const marker = new kakao.maps.Marker({
                        position: markerPosition
                    });
                    marker.setMap(this.map);

                    const infowindow = new kakao.maps.InfoWindow({
                        content: `<div style="padding:5px;">${poi.placeName || poi.contentId}</div>`
                    });
                    kakao.maps.event.addListener(marker, 'mouseover', () => {
                        infowindow.open(this.map, marker);
                    });
                    kakao.maps.event.addListener(marker, 'mouseout', () => {
                        infowindow.close();
                    });

                    bounds.extend(markerPosition);
                });

                this.map.setBounds(bounds);
            }
        },
        mounted() {
            let self = this;

            self.reservation = JSON.parse('<c:out value="${reservationJson}" escapeXml="false"/>');
            self.newPackName = self.reservation.packName;
            self.reservation.packname = self.reservation.packName; 

            const rawPoiList = JSON.parse('<c:out value="${poiListJson}" escapeXml="false"/>');

            self.poiList = rawPoiList.filter(poi =>
                poi.contentId && !isNaN(poi.contentId) && poi.contentId > 0
            );

            // 3. 지도 초기화
            const validMapPois = self.poiList.filter(poi =>
                poi.mapY != null && poi.mapX != null &&
                !isNaN(poi.mapY) && !isNaN(poi.mapX)
            );

            if (validMapPois.length > 0) {
                self.initializeMap(validMapPois);
            } else {
                document.getElementById('map-container').innerText = 'DB에 저장된 좌표 정보가 없습니다.';
            }
        }
    });

    app.mount('#app');
</script>
</body>

</html>