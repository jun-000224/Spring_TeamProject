<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>예약 상세 확인</title>

  <!-- Vendor -->
  <script src="https://code.jquery.com/jquery-3.7.1.js"
          integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
          crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <script type="text/javascript"
          src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services"></script>

  <!-- Global CSS (있으면 유지) -->
  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation.css" />

  <style>
    :root{
      --brand:#3498db;
      --brand-600:#2980b9;
      --text:#333; --muted:#555; --border:#e0e0e0; --bg:#f4f7f6;
    }
    /* Layout */
    body { font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif; background:var(--bg); color:var(--text); }
    .wrap { max-width: 1100px; margin: 24px auto 60px; padding: 0 16px; }
    .page-title { font-size: 2.25rem; font-weight: 700; color: #2c3e50; border-bottom: 3px solid var(--brand); padding-bottom: 10px; margin-bottom: 20px; }
    .panel { background: #fff; border: 1px solid var(--border); border-radius: 12px; padding: 24px; margin-bottom: 25px; box-shadow: 0 4px 12px rgba(0,0,0,.05); }
    .panel h2, .panel h3 { margin: 0 0 14px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .info-list { list-style: none; margin: 0; padding: 0; }
    .info-list li { font-size: 1.05rem; line-height: 2; color: var(--muted); display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
    .info-list li strong { color:#222; width: 120px; flex-shrink: 0; }
    .info-list input[type="text"] { font-size: 1rem; padding: 8px 10px; border:1px solid #ccc; border-radius: 8px; flex: 1 1 260px; }

    /* Budget */
    .budget-total { font-size: 1.1rem; font-weight: 700; color:#333; margin-bottom: 14px; }
    .budget-status-wrap { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; padding: 15px; background: #f9f9f9; border-radius: 10px; }
    .budget-status-item { background: #fff; border: 1px solid var(--border); border-radius: 10px; padding: 12px 10px; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,.03); min-height: 72px; }
    .budget-status-item .label { font-size: .85rem; color:#666; display:block; margin-bottom:6px; }
    .budget-status-item .amount { font-size: 1.15rem; font-weight: 700; color: var(--brand); display:block; }

    /* Map */
    #map-container { width: 100%; height: 440px; border: 1px solid #ddd; border-radius: 10px; margin-top: 10px; overflow: hidden; }

    /* Tabs & route */
    .date-tabs { display: flex; gap: 6px; margin-bottom: 15px; border-bottom: 2px solid #ddd; flex-wrap: wrap; }
    .tab-btn { padding: 10px 14px; border: none; background: #f0f0f0; cursor: pointer; border-radius: 8px 8px 0 0; font-size: .95rem; color:#555; position: relative; bottom:-2px; }
    .tab-btn.active { background: #fff; border: 2px solid #ddd; border-bottom: 2px solid #fff; font-weight: 700; color: var(--brand); }
    .route-toolbar { display:flex; gap: 8px; align-items: center; margin-bottom: 10px; flex-wrap: wrap; }
    .route-summary { font-size: .9rem; color:#444; padding: 6px 10px; background:#f5f7fa; border:1px solid #e5e7eb; border-radius: 8px; }

    /* POI list */
    .poi-item { background:#fff; border:1px solid var(--border); border-radius: 10px; padding: 14px; margin-bottom: 10px; }
    .poi-item p { margin:0; line-height: 1.6; }
    .poi-item p:first-child strong { font-size: 1.05rem; color:#2c3e50; }

    /* Save button */
    .save-button-wrap { text-align:center; margin-top: 26px; }
    .save-button-wrap button { padding: 12px 38px; font-size: 1.05rem; font-weight: 800; background: var(--brand); color:#fff; border:0; border-radius: 10px; cursor:pointer; transition: .18s; }
    .save-button-wrap button:hover { background: var(--brand-600); }

    /* Responsive */
    @media (max-width: 860px){
      .budget-status-wrap { grid-template-columns: repeat(2, 1fr); }
    }
    @media (max-width: 520px){
      .budget-status-wrap { grid-template-columns: 1fr; }
      .info-list li strong{ width: 100%; }
    }
  </style>
</head>
<body>
  <%@ include file="components/header.jsp" %>

  <div class="wrap">
    <div id="app">
      <h1 class="page-title">예약 상세 확인</h1>

      <!-- 기본 정보 -->
      <div class="panel">
        <h3>기본 예약 정보 확인</h3>
        <ul class="info-list">
          <li>
            <strong>여행 코스 이름</strong>
            <input type="text" v-model="reservation.packname" placeholder="코스 별칭을 입력하세요" />
            <button class="tab-btn" @click="fnUpdatePackname">저장</button>
          </li>
          <li>
            <strong>여행 기간</strong>
            <span>{{ formatDate(reservation.startDate) }} ~ {{ formatDate(reservation.endDate) }}</span>
          </li>
          <li>
            <strong>방문 예정 장소</strong>
            <span>총 {{ poiList ? poiList.length : 0 }}지점</span>
          </li>
          <li>
            <strong>테마</strong>
            <span>{{ displayThemes }}</span>
          </li>
        </ul>
      </div>

      <!-- 예산 -->
      <div class="panel">
        <h3>예산 현황</h3>
        <div class="budget-total"><strong>총 예산:</strong> {{ formatPrice(reservation.price) }}원</div>
        <div class="budget-status-wrap">
          <div class="budget-status-item">
            <span class="label">기타 예산</span>
            <span class="amount">{{ formatPrice(reservation.etcBudget) }}원</span>
          </div>
          <div class="budget-status-item">
            <span class="label">관광지 예산</span>
            <span class="amount">{{ formatPrice(reservation.actBudget) }}원</span>
          </div>
          <div class="budget-status-item">
            <span class="label">숙박 예산</span>
            <span class="amount">{{ formatPrice(reservation.accomBudget) }}원</span>
          </div>
          <div class="budget-status-item">
            <span class="label">식비 예산</span>
            <span class="amount">{{ formatPrice(reservation.foodBudget) }}원</span>
          </div>
        </div>
      </div>

      <!-- 지도 -->
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

      <!-- 일정 리스트 -->
      <div class="panel">
        <h2>📋 상세 일정 목록</h2>
        <div class="date-tabs" v-if="Object.keys(itineraryByDate).length > 0">
          <button type="button"
                  v-for="(pois, date, index) in itineraryByDate"
                  :key="date"
                  :class="['tab-btn', { active: activeDate === date }]"
                  @click="setActiveDate(date)">
            {{ index + 1 }}일차 ({{ formatDate(date) }})
          </button>
        </div>

        <div id="detail-schedule-list">
          <p v-if="poiList.length === 0">유효한 POI 일정이 없습니다.</p>
          <div v-else v-for="(poi, index) in itineraryByDate[activeDate]" :key="poi.poiId" class="poi-item">
            <p>[{{ index + 1 }}] <strong>{{ poi.placeName }}</strong></p>
            <p>방문 예정일: {{ formatDate(poi.reservDate) }}</p>
          </div>
        </div>
      </div>

      <!-- 저장 -->
      <div class="save-button-wrap">
        <button @click="fnSave">저장하기</button>
      </div>
    </div>
  </div>

  <%@ include file="components/footer.jsp" %>

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
            packname: "",
            // DB 금액 필드(원 단위)
            etcBudget: 0,
            accomBudget: 0,
            foodBudget: 0,
            actBudget: 0
          },
          poiList: [],
          kakaoAppKey: '${kakaoAppKey}',
          map: null,
          itineraryByDate: {},
          activeDate: null,
          // 테마 라벨 매핑
          themeOptions: [
            { code: 'FAMILY', label: '가족' }, { code: 'FRIEND', label: '친구' },
            { code: 'COUPLE', label: '연인' }, { code: 'LUXURY', label: '호화스러운' },
            { code: 'BUDGET', label: '가성비' }, { code: 'HEALING', label: '힐링' },
            { code: 'UNIQUE', label: '이색적인' }, { code: 'ADVENTURE', label: '모험' },
            { code: 'QUIET', label: '조용한' }
          ],
          // 지도/경로 상태
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
        // 공용 포맷터
        formatPrice(value) {
          const n = Number(value);
          return isFinite(n) ? n.toLocaleString() : '0';
        },
        formatDate(dateString) {
          if (!dateString) return "날짜 없음";
          try { return String(dateString).split(' ')[0]; }
          catch (e) { return dateString; }
        },

        // 코스명 업데이트
        fnUpdatePackname() {
          if (!this.reservation.packname || this.reservation.packname.trim() === "") {
            alert("별칭을 입력해주세요."); return;
          }
          $.ajax({
            url: '/api/reservation/update/packname',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
              resNum: this.reservation.resNum,
              packName: this.reservation.packname
            }),
            success: () => {
              alert('별칭이 저장되었습니다.');
              this.reservation.packName = this.reservation.packname;
            },
            error: (jqXHR) => {
              alert(`저장 실패 (${jqXHR.status}): 백엔드 API 수정이 필요합니다.`);
            }
          });
        },

        // 지도 초기화
        initializeMap(markerData) {
          if (!window.kakao || !kakao.maps) {
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

          // 마커 + bounds
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

        // 경로 라인
        drawPolyline(points) {
          if (!this.map) return;
          if (this.routePolyline) {
            this.routePolyline.setMap(null);
            this.routePolyline = null;
          }
          if (!points || points.length === 0) return;

          const path = points.map(pt => new kakao.maps.LatLng(pt.y, pt.x));
          this.routePolyline = new kakao.maps.Polyline({
            path,
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

        // 자동차 경로 생성 요청
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

        // 저장(별칭 저장 placeholder)
        fnSave() {
          if (!this.reservation.packname || this.reservation.packname.trim() === "") {
            alert("여행 코스 이름을 입력해주세요."); return;
          }
          const param = {
            resNum: this.reservation.resNum,
            packName: this.reservation.packname
          };
          $.ajax({
            url: "/reservation-view/save.dox",
            dataType: "json",
            type: "POST",
            contentType: 'application/json',
            data: JSON.stringify(param),
            success: () => {
              alert("여행 일정 저장이 완료되었습니다.");
              location.href = "/main-list.do";
            },
            error: (jqXHR) => {
              alert(`저장 실패 (${jqXHR.status}): 백엔드 API 구현이 필요합니다.`);
            }
          });
        },

        // 일정 그룹화
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
          // 날짜 변경 시 경로 초기화
          this.clearRoute();
        }
      },
      mounted() {
        // 서버에서 내려준 JSON 바인딩
        this.reservation = JSON.parse('<c:out value="${reservationJson}" escapeXml="false"/>');
        // packName → packname 양방향 표시용
        this.reservation.packname = this.reservation.packName;

        const rawPoiList = JSON.parse('<c:out value="${poiListJson}" escapeXml="false"/>');

        // 유효 POI만 필터링
        this.poiList = rawPoiList.filter(poi =>
          poi.contentId && !isNaN(poi.contentId) && Number(poi.contentId) > 0
        );

        // 날짜별 그룹화
        this.groupPoisByDate(this.poiList);

        // 지도 마커용 좌표 필터
        const validMapPois = this.poiList.filter(poi =>
          poi.mapY != null && poi.mapX != null &&
          !isNaN(poi.mapY) && !isNaN(poi.mapX)
        );

        if (validMapPois.length > 0) {
          this.initializeMap(validMapPois);
        } else {
          document.getElementById('map-container').innerText = 'DB에 저장된 좌표 정보가 없습니다.';
        }
      }
    });

    app.mount('#app');
  </script>
</body>
</html>
