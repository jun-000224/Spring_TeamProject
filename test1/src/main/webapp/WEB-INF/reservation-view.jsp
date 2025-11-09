<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>예약 상세 확인</title>

  <script src="https://code.jquery.com/jquery-3.7.1.js"
    integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services"></script>

  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation.css" />

  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background-color: #f4f7f6;
      color: #333;
    }
    .page-title { font-size: 2.25rem; font-weight: 700; color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-bottom: 20px; }
    .panel { background: #ffffff; border: 1px solid #e0e0e0; border-radius: 12px; padding: 24px; margin-bottom: 25px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); }
    .panel h2, .panel h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .info-list { list-style-type: none; padding-left: 0; margin: 0; }
    .info-list li { font-size: 1.1em; line-height: 2; color: #555; display: flex; align-items: center; gap: 10px; }
    .info-list li strong { color: #333; width: 120px; flex-shrink: 0; }
    .info-list input[type="text"] { font-size: 1em; padding: 8px; border: 1px solid #ccc; border-radius: 4px; flex-grow: 1; }
    .budget-status-main { display: flex; flex-direction: column; }
    .budget-total { font-size: 1.2em; font-weight: bold; color: #333; margin-bottom: 15px; }
    .budget-status-wrap { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; padding: 15px; background: #f9f9f9; border-radius: 8px; }
    .budget-status-item { flex: 1; background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; padding: 10px 5px; text-align: center; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03); min-height: 70px; }
    .budget-status-item .label { font-size: 0.8em; color: #555; display: block; margin-bottom: 5px; }
    .budget-status-item .amount { font-size: 1.2em; font-weight: 600; color: #3498db; display: block; }
    .budget-status-item .amount .current { color: #d9480f; }
    .budget-status-item .amount .total { font-size: 0.8em; color: #888; }
    #map-container { width: 100%; height: 440px; border: 1px solid #ddd; border-radius: 8px; margin-top: 10px; }
    .poi-item { background: #fff; border: 1px solid #e0e0e0; border-radius: 8px; padding: 15px; margin-bottom: 10px; }
    .poi-item p { margin: 0; line-height: 1.6; }
    .poi-item p:first-child strong { font-size: 1.2em; color: #2c3e50; }
    .save-button-wrap { text-align: center; margin-top: 30px; }
    .save-button-wrap button { padding: 12px 40px; font-size: 1.2em; font-weight: bold; background-color: #3498db; color: white; border: none; border-radius: 8px; cursor: pointer; transition: background-color: 0.2s; }
    .save-button-wrap button:hover { background-color: #2980b9; }
    .date-tabs { display: flex; gap: 5px; margin-bottom: 15px; border-bottom: 2px solid #ddd; }
    .tab-btn { padding: 10px 15px; border: none; background: #f0f0f0; cursor: pointer; border-radius: 6px 6px 0 0; font-size: 0.95em; color: #555; position: relative; bottom: -2px; }
    .tab-btn.active { background: #fff; border: 2px solid #ddd; border-bottom: 2px solid #fff; font-weight: bold; color: #3498db; }
    .route-toolbar { display: flex; gap: 8px; align-items: center; margin-bottom: 8px; flex-wrap: wrap; }
    .route-summary { font-size: 14px; color: #444; padding: 6px 10px; background: #f5f7fa; border: 1px solid #e5e7eb; border-radius: 6px; }
  </style>
</head>

<body>
  <%@ include file="components/header.jsp" %>

  <div class="wrap">
    <div id="app">

      <h1 class="page-title">예약 상세 확인</h1>

      <div class="panel">
        <h3>기본 예약 정보 확인</h3>
        <ul class="info-list">
          <li>
            <strong>여행 코스 이름</strong>
            <input type="text" v-model="reservation.packname" placeholder="코스 별칭을 입력하세요">
            <button class="tab-btn" @click="fnUpdatePackname">저장</button>
          </li>
          <li><strong>여행 기간</strong> {{ formatDate(reservation.startDate) }} ~ {{ formatDate(reservation.endDate) }}</li>
          <li><strong>방문 예정 장소</strong> 총 {{ poiList ? poiList.length : 0 }}지점</li>
          <li><strong>테마</strong> {{ displayThemes }}</li>
        </ul>
      </div>

      <div class="panel">
        <h3>예산 현황</h3>

        <div class="budget-total"><strong>총 예산:</strong> {{ formatPrice(reservation.price) }}원</div>

        <div class="budget-status-wrap">
          <div class="budget-status-item">
            <span class="label">기타 예산</span>
            <span class="amount" id="budget-etc">0원</span>
          </div>
          <div class="budget-status-item">
            <span class="label">관광지 예산</span>
            <span class="amount" id="budget-activity">0원</span>
          </div>
          <div class="budget-status-item">
            <span class="label">숙박 예산</span>
            <span class="amount" id="budget-accom">
              <span class="current">0원</span> / <span class="total">0원</span>
            </span>
          </div>
          <div class="budget-status-item">
            <span class="label">식비 예산</span>
            <span class="amount" id="budget-food">
              <span class="current">0원</span> / <span class="total">0원</span>
            </span>
          </div>
        </div>
      </div>

      <div class="panel">
        <h2>🗺️ 여행 경로 지도</h2>

        <div class="route-toolbar">
          <button id="btnBuildRoute" @click="buildCarRoute" class="tab-btn">차량 경로 보기</button>
          <button v-if="routePolyline" @click="clearRoute" class="tab-btn">경로 지우기</button>
          <div v-if="routeSummary" class="route-summary">
            총 거리: {{ (routeSummary.distance/1000).toFixed(1) }} km ·
            예상 소요: {{ Math.round(routeSummary.duration/60) }} 분
            <span v-if="routeSummary.toll">· 톨비: {{ routeSummary.toll.toLocaleString() }}원</span>
          </div>
        </div>

        <div id="map-container">지도 로딩 중...</div>
      </div>

      <div class="panel">
        <h2>📋 상세 일정 목록</h2>

        <div class="date-tabs" v-if="Object.keys(itineraryByDate).length > 0">
          <button type="button" v-for="(pois, date, index) in itineraryByDate" :key="date"
            :class="['tab-btn', { active: activeDate === date }]" @click="setActiveDate(date)">
            {{ index + 1 }}일차 ({{ formatDate(date) }})
          </button>
        </div>

        <div id="detail-schedule-list">
          <p v-if="poiList.length === 0">유효한 POI 일정이 없습니다.</p>

          <div v-else v-for="(poi, index) in itineraryByDate[activeDate]" :key="poi.poiId" class="poi-item">
            <p>[{{ index + 1 }}] <strong>{{ poi.placeName }}</strong></p>
            <p>방문 예정일: {{ formatDate(poi.reservDate) }} </p>
          </div>
        </div>
      </div>

      <div class="save-button-wrap">
        <button @click="fnSave">저장하기</button>
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
        reservation: {
          resNum: 0,
          packName: "사용자 지정 코스 이름",
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

        itineraryByDate: {},
        activeDate: null,

        // 테마 옵션
        themeOptions: [
          { code: 'FAMILY', label: '가족' }, { code: 'FRIEND', label: '친구' },
          { code: 'COUPLE', label: '연인' }, { code: 'LUXURY', label: '호화스러운' },
          { code: 'BUDGET', label: '가성비' }, { code: 'HEALING', label: '힐링' },
          { code: 'UNIQUE', label: '이색적인' }, { code: 'ADVENTURE', label: '모험' },
          { code: 'QUIET', label: '조용한' }
        ],

        // 경로 표시 상태
        routePolyline: null,
        routeSummary: null,
        markers: []
      };
    },
    computed: {
      displayThemes() {
        if (!this.reservation.themNum) return "선택 안 함";
        const codes = this.reservation.themNum.split(',');
        return codes.map(code => {
          const theme = this.themeOptions.find(t => t.code === code.trim());
          return theme ? theme.label : code;
        }).join(', ');
      }
    },
    methods: {
      fnUpdatePackname() {
        let self = this;
        if (!self.reservation.packname || self.reservation.packname.trim() === "") {
          alert("별칭을 입력해주세요.");
          return;
        }
        $.ajax({
          url: '/api/reservation/update/packname',
          type: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({
            resNum: self.reservation.resNum,
            packName: self.reservation.packname
          }),
          success: function () {
            alert('별칭이 저장되었습니다.');
            self.reservation.packName = self.reservation.packname;
          },
          error: function (jqXHR) {
            alert(`저장 실패 (${jqXHR.status}): 백엔드 API 수정이 필요합니다.`);
          }
        });
      },

      formatPrice(value) {
        return value ? Number(value).toLocaleString() : '0';
      },

      formatDate(dateString) {
        if (!dateString) return "날짜 없음";
        try {
          return String(dateString).split(' ')[0];
        } catch (e) {
          return dateString;
        }
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

        // 마커 표시 + bounds
        const bounds = new kakao.maps.LatLngBounds();
        this.clearMarkers();

        markerData.forEach((poi) => {
          const pos = new kakao.maps.LatLng(poi.mapY, poi.mapX);
          const marker = new kakao.maps.Marker({ position: pos });
          marker.setMap(this.map);
          this.markers.push(marker);

          const infowindow = new kakao.maps.InfoWindow({
            content: `<div style="padding:5px;">${poi.placeName || poi.contentId}</div>`
          });
          kakao.maps.event.addListener(marker, 'mouseover', () => infowindow.open(this.map, marker));
          kakao.maps.event.addListener(marker, 'mouseout', () => infowindow.close());

          bounds.extend(pos);
        });

        this.map.setBounds(bounds);
      },

      clearMarkers() {
        if (!this.markers) return;
        this.markers.forEach(m => m.setMap(null));
        this.markers = [];
      },

      drawPolyline(points) {
        if (!this.map) return;
        if (this.routePolyline) {
          this.routePolyline.setMap(null);
          this.routePolyline = null;
        }
        if (!points || points.length === 0) return;

        const path = points.map(pt => new kakao.maps.LatLng(pt.y, pt.x));
        this.routePolyline = new kakao.maps.Polyline({
          path: path,
          strokeWeight: 5,
          strokeOpacity: 0.9
        });
        this.routePolyline.setMap(this.map);

        const bounds = new kakao.maps.LatLngBounds();
        path.forEach(latlng => bounds.extend(latlng));
        this.map.setBounds(bounds);
      },

      clearRoute() {
        if (this.routePolyline) {
          this.routePolyline.setMap(null);
          this.routePolyline = null;
        }
        this.routeSummary = null;
      },

      async buildCarRoute() {
        const pois = this.itineraryByDate[this.activeDate] || [];
        const valid = pois.filter(p =>
          p.mapX != null && p.mapY != null && !isNaN(p.mapX) && !isNaN(p.mapY)
        );

        if (valid.length < 2) {
          alert('경로를 그릴 최소 2개 지점(출발/도착)이 필요합니다.');
          return;
        }

        try {
          const payload = {
            resNum: this.reservation.resNum,
            day: this.activeDate, // "YYYY-MM-DD"
            pois: valid.map(p => ({
              contentId: p.contentId,
              name: p.placeName || '',
              x: Number(p.mapX),   // 경도
              y: Number(p.mapY)    // 위도
            }))
          };

          const resp = await $.ajax({
            url: '/api/route/build',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload)
          });

          // resp = { points: [{x,y}, ...], summary: {distance, duration, toll?} }
          this.drawPolyline(resp.points);
          this.routeSummary = resp.summary || null;

        } catch (e) {
          console.error(e);
          alert('경로 계산에 실패했습니다. (서버 로그와 Kakao REST 키 확인)');
        }
      },

      fnSave() {
        let self = this;
        if (!self.reservation.packname || self.reservation.packname.trim() === "") {
          alert("여행 코스 이름을 입력해주세요.");
          return;
        }
        let param = {
          resNum: self.reservation.resNum,
          packName: self.reservation.packname
        };
        $.ajax({
          url: "/reservation-view/save.dox",
          dataType: "json",
          type: "POST",
          contentType: 'application/json',
          data: JSON.stringify(param),
          success: function () {
            alert("여행 일정 저장이 완료되었습니다.")
            location.href = "/main-list.do"
          },
          error: function (jqXHR) {
            alert(`저장 실패 (${jqXHR.status}): 백엔드 API 구현이 필요합니다.`);
          }
        });
      },

      groupPoisByDate(poiList) {
        const sortedList = [...poiList].sort((a, b) =>
          new Date(a.reservDate) - new Date(b.reservDate)
        );
        const grouped = {};
        sortedList.forEach(poi => {
          const date = this.formatDate(poi.reservDate);
          if (!grouped[date]) grouped[date] = [];
          grouped[date].push(poi);
        });
        this.itineraryByDate = grouped;
        if (Object.keys(grouped).length > 0) {
          this.activeDate = Object.keys(grouped)[0];
        }
      },

      setActiveDate(date) {
        this.activeDate = date;
        // 날짜 바꾸면 경로 요약/라인은 초기화
        this.clearRoute();
      }
    },
    mounted() {
      let self = this;

      // 서버에서 내려준 JSON 바인딩
      self.reservation = JSON.parse('<c:out value="${reservationJson}" escapeXml="false"/>');
      self.reservation.packname = self.reservation.packName;

      const rawPoiList = JSON.parse('<c:out value="${poiListJson}" escapeXml="false"/>');

      // 유효 POI만 필터링
      self.poiList = rawPoiList.filter(poi =>
        poi.contentId && !isNaN(poi.contentId) && poi.contentId > 0
      );

      // 날짜별 그룹화
      self.groupPoisByDate(self.poiList);

      // 지도 마커용 좌표 필터
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
