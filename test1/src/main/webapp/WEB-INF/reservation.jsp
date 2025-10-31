<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8" />
  <title>Reservation</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />

  <script src="https://code.jquery.com/jquery-3.7.1.js"
    integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

  <script type="text/javascript"
    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"></script>

  <script>const ctx = '${pageContext.request.contextPath}';</script>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservation.css" />
  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">

  <style>
  </style>
</head>

<body>
  <div id="app">

    <%@ include file="components/header.jsp" %>
    <div class="wrap">
      <h1 class="page-title">예약하기</h1>
      <div class="grid two-col">
        <section class="panel">
          <h3>테마 선택 <span class="desc">복수 선택 가능</span></h3>
          <div class="desc">선택된 테마는 아래에 간단히 표시됩니다.</div>
          <div class="theme-grid">
            <button v-for="item in themeOptions" :key="item.code" type="button"
              :class="['theme-btn', { active: selectedThemes.includes(item.code) }]"
              @click="toggleTheme(item.code)">
              {{ item.label }}
            </button>
          </div>
          <div class="chips" v-if="selectedThemes.length">
            <span class="chip" v-for="t in selectedThemes" :key="t">{{ labelOf(t) }}</span>
          </div>
          <div class="desc" v-else>선택: 없음</div>
          <h3 style="margin-top:14px">지역 선택</h3>
          <div class="grid" style="grid-template-columns:1fr 1fr; gap:10px">
            <div class="field">
              <label>시/도</label>
              <select v-model="selectedSido" @change="onChangeSido" :disabled="loadingSido">
                <option value="">선택</option>
                <option v-for="s in sidoList" :key="s.code" :value="s.code">{{ s.name }}</option>
              </select>
            </div>
            <div class="field">
              <label>시/군/구</label>
              <select v-model="selectedSigungu" :disabled="!sigunguList.length || loadingSigungu">
                <option value="">전체</option>
                <option v-for="g in sigunguList" :key="g.code" :value="g.code">{{ g.name }}</option>
              </select>
            </div>
          </div>
          <div class="inline" style="margin-top:4px">
            선택된 지역: <strong>{{ displayRegion }}</strong>
          </div>
          <br>
          <h3>인원 / 예산</h3>
          <div class="field">
            <label>총원</label>
            <input type="number" min="1" v-model.number="headCount" placeholder="총 인원수를 입력하세요." />
          </div>
          <div class="field">
            <label>예산(원)</label>
            <input type="number" min="0" step="1000" v-model.number="budget" @input="onBudgetChange"
              placeholder="예산을 입력하세요." />
          </div>
          <div class="inline" style="margin-top:2px">
            입력값: 인원 <strong>{{ headCount || 0 }}</strong>명 / 예산 <strong>{{ (budget ?? 0).toLocaleString()
              }}</strong>원
          </div>
        </section>

        <section class="panel">
          <h3 style="margin-top:14px">일정 선택</h3>
          <div class="field-row">
            <div class="field">
              <label>시작일</label>
              <input type="text" :value="startDate || ''" readonly placeholder="달력에서 선택">
            </div>
            <div class="field">
              <label>종료일</label>
              <input type="text" :value="endDate || ''" readonly placeholder="달력에서 선택">
            </div>
          </div>
          <div class="inline" style="margin-top:2px; margin-bottom:8px;">
            선택된 일정: <strong>{{ displayDateRange }}</strong>
          </div>
          <div class="calendar">
            <div class="cal-header">
              <button @click.prevent="prevMonth" type="button">&lt;</button>
              <strong>{{ currentYear }}년 {{ monthName }}</strong>
              <button @click.prevent="nextMonth" type="button">&gt;</button>
            </div>
            <div class="cal-grid week-days">
              <div class="cal-day-label">일</div>
              <div class="cal-day-label">월</div>
              <div class="cal-day-label">화</div>
              <div class="cal-day-label">수</div>
              <div class="cal-day-label">목</div>
              <div class="cal-day-label">금</div>
              <div class="cal-day-label">토</div>
            </div>
            <div class="cal-grid days">
              <div v-for="(day, i) in calendarGrid" :key="i" :class="['cal-day', getDayClasses(day)]"
                @click="selectDate(day)">
                {{ day.dayNum }}
              </div>
            </div>
          </div>
          <div class="actions">
            <button class="btn-primary" @click="fnCreate">코스 생성하기</button>
          </div>
        </section>
      </div>
      <section class="panel" style="margin-top:10px">
        <h3>예산 배분</h3>
        <div class="desc">
          원형 차트의 분기점을 <b>드래그</b>하거나, 오른쪽 슬라이더로 가중치를 조정하세요.
          (총합 100%) 체크박스를 켜면 해당 항목이 <b>잠금</b>됩니다.
        </div>
        <div class="pie-wrap">
          <div>
            <canvas id="budgetPie" width="640" height="480" @mousedown="onPieDown" @mousemove="onPieMove"
              @mouseup="onPieUp" @mouseleave="onPieUp" @touchstart.prevent="onPieDownTouch"
              @touchmove.prevent="onPieMoveTouch" @touchend.prevent="onPieUp"></canvas>
            <div class="help">도넛 두께 영역을 잡고 분기점을 회전시키세요. (잠금된 항목은 비율 고정)</div>
          </div>
          <div class="legend">
            <div class="legend-row" v-for="(c,idx) in categories" :key="c.key">
              <label style="display:flex;align-items:center;gap:6px;min-width:22px;">
                <input type="checkbox" v-model="locks[idx]" @change="normalizeWeights(); drawPie()" />
              </label>
              <span class="swatch" :style="{ background:c.color }"></span>
              <div style="flex:1">
                <div
                  style="display:flex; justify-content:space-between; align-items:center; gap:10px; margin-bottom:4px">
                  <strong>
                    {{ c.label }}
                    <span v-if="locks[idx]" style="font-weight:600; color:#2563eb; margin-left:6px;">🔒</span>
                  </strong>
                  <span class="pct">{{ weights[idx] }}%</span>
                  <span class="amount">{{ amountFor(idx).toLocaleString() }}원</span>
                </div>
                <input type="range" min="5" max="90" :value="weights[idx]"
                  @input="onSlider(idx, $event.target.value)" :disabled="locks[idx]">
              </div>
            </div>
            <div class="inline" style="margin-top:4px">
              합계: <strong>{{ weights.reduce((a,b)=>a+Number(b),0) }}</strong>%
            </div>
          </div>
        </div>
      </section>
      <section class="panel" style="margin-top:10px">
        <h3>추천 코스 (지도)</h3>
        <div class="tabs">
          <button type="button" :class="['tab-btn', { active: activeTab === 12 }]" @click="setActiveTab(12)">
            <i class="fa-solid fa-camera"></i> 관광지 ({{ countForTab(12) }})
          </button>
          <button type="button" :class="['tab-btn', { active: activeTab === 32 }]" @click="setActiveTab(32)">
            <i class="fa-solid fa-hotel"></i> 숙박 ({{ countForTab(32) }})
          </button>
          <button type="button" :class="['tab-btn', { active: activeTab === 39 }]" @click="setActiveTab(39)">
            <i class="fa-solid fa-utensils"></i> 식당 ({{ countForTab(39) }})
          </button>
        </div>
        <div id="map-recommend" class="map-recommend-area"></div>
        <div id="debugOut" style="display: none;"></div>
      </section>
      <button class="fab" @click="openBoardModal" aria-label="커뮤니티 열기" title="커뮤니티">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
          stroke-linejoin="round" aria-hidden="true">
          <path d="M21 15a4 4 0 0 1-4 4H7l-4 4V7a4 4 0 0 1 4-4h10a4 4 0 0 1 4 4z" />
        </svg>
      </button>
      <div class="modal-backdrop" :class="{ show: showBoardModal }" @click="closeBoardModal"></div>
      <div class="modal-card" :class="{ show: showBoardModal }">
        <div class="card">
          <div class="modal-header">
            <h4>커뮤니티</h4>
            <button class="modal-close" @click="closeBoardModal" aria-label="닫기">✕</button>
          </div>
          <div class="modal-body">
            <iframe :src="boardUrl"></iframe>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/reservation-pie.js"></script>
  <script src="${pageContext.request.contextPath}/js/reservation-calendar.js"></script>

  <script>
    const app = Vue.createApp({
      data() {
        return {
          // 테마
          themeOptions: [
            { code: 'FAMILY', label: '가족' }, { code: 'FRIEND', label: '친구' },
            { code: 'COUPLE', label: '연인' }, { code: 'LUXURY', label: '호화스러운' },
            { code: 'BUDGET', label: '가성비' }, { code: 'HEALING', label: '힐링' },
            { code: 'UNIQUE', label: '이색적인' }, { code: 'ADVENTURE', label: '모험' },
            { code: 'QUIET', label: '조용한' }
          ],
          selectedThemes: [],
          // 지역
          sidoList: [],
          sigunguList: [],
          selectedSido: '',
          selectedSigungu: '',
          loadingSido: false,
          loadingSigungu: false,
          // 예산, 인원
          budget: null,
          headCount: null,
          // 날짜 (Mixin)
          startDate: null,
          endDate: null,
          selectionState: 'start',
          // 모달
          showBoardModal: false,
          boardUrl: ctx + '/board-view.do',

          // --- 지도/추천 관련 데이터 ---
          mapInstance: null,      // map: 카카오맵 인스턴스 저장용
          geocoder: null,       // geocoder: 주소-좌표 변환기
          markers: [],          // 지도에 찍힌 마커들 (나중에 지우려고 들고있음)
          fullPoiList: [],      // API에서 받아온 추천 장소 원본 리스트
          activeTab: 12         // 지금 보고있는 탭 (12: 관광지, 32: 숙소, 39: 식당)
        }
      },

      computed: {
        // (isFormValid, displayRegion은 그대로)
        isFormValid() {
          return this.selectedThemes.length > 0 && this.headCount > 0 && this.budget >= 0;
        },
        displayRegion() {
          if (!this.selectedSido) return '미선택';
          const s = this.sidoList.find(x => x.code === this.selectedSido)?.name || '';
          const g = this.sigunguList.find(x => x.code === this.selectedSigungu)?.name || '';
          return s + (g ? ' ' + g : ' (전체)');
        },

        /** 지금 선택된 탭(관광지, 숙소, 식당)에 맞는 목록만 거르기 */
        filteredPoiList() {
          return this.fullPoiList.filter(poi => poi.typeId === this.activeTab);
        }
      },

      /** 'filteredPoiList'가 바뀔 때마다 'drawMarkers' 자동 호출 */
      watch: {
        filteredPoiList(newList, oldList) {
          this.drawMarkers();
        }
      },

      methods: {
        // (기존 메소드들은 생략)
        async loadSido() {
          const self = this;
          self.loadingSido = true;
          self.sidoList = [];
          try {
            const data = await $.get(ctx + '/api/areas/sido');
            self.sidoList = Array.isArray(data) ? data : [];
          } catch (e) { console.error('시/도 조회 실패', e); }
          finally { self.loadingSido = false; }
        },
        async loadSigungu() {
          const self = this;
          self.loadingSigungu = true;
          self.sigunguList = [];
          try {
            if (!self.selectedSido) return;
            const data = await $.get(ctx + '/api/areas/sigungu', { areaCode: self.selectedSido });
            self.sigunguList = Array.isArray(data) ? data : [];
          } catch (e) { console.error('시/군/구 조회 실패', e); }
          finally { self.loadingSigungu = false; }
        },
        onChangeSido() {
          this.selectedSigungu = '';
          this.sigunguList = [];
          this.loadSigungu();
          this.fullPoiList = []; // 시/도 바꾸면 기존 추천 목록은 날리기
        },
        toggleTheme(code) {
          const i = this.selectedThemes.indexOf(code);
          if (i === -1) this.selectedThemes.push(code);
          else this.selectedThemes.splice(i, 1);
        },
        labelOf(code) { return this.themeOptions.find(t => t.code === code)?.label || code; },
        openBoardModal() { this.showBoardModal = true; /* ... */ },
        closeBoardModal() { this.showBoardModal = false; /* ... */ },


        /** 탭 누르면 activeTab 값 변경 */
        setActiveTab(typeId) {
          this.activeTab = typeId;
        },

        /** 탭 옆에 (숫자) 표시용 카운트 */
        countForTab(typeId) {
          return this.fullPoiList.filter(p => p.typeId === typeId).length;
        },

        /** "코스 생성하기" 버튼 눌렀을 때 */
        async fnCreate() {
          const el = document.getElementById('debugOut');
          const param = {
            themes: this.selectedThemes,
            areaCode: this.selectedSido || null,
            sigunguCode: this.selectedSigungu || null,
            headCount: this.headCount,
            budget: this.budget,
            startDate: this.startDate,
            endDate: this.endDate,
            budgetWeights: {
              etc: this.weights[0], accom: this.weights[1],
              food: this.weights[2], act: this.weights[3]
            }
          };

          // API로 보낼 파라미터들 확인
          const lines = [
            ['themes', (param.themes && param.themes.length) ? param.themes.join(', ') : '(없음)'],
            ['areaCode', String(param.areaCode)], ['sigunguCode', String(param.sigunguCode)],
            ['startDate', String(param.startDate || '미선택')], ['endDate', String(param.endDate || '미선택')]
          ];
          const paramText = lines.map(p => p[0] + ' : ' + p[1]).join('\n');

          // 로딩 중... (일단 디버그용으로만)
          if (el) el.textContent = '===== 전송 파라미터 =====\n' + paramText + '\n\n===== POI 조회 중... =====';
          console.log('전송 파라미터:', param);

          this.fullPoiList = []; // API 새로 부르기 전에 기존 목록 비우기
          this.clearMarkers();   // 지도에 있던 마커들도 싹 지우기

          try {
            const response = await $.ajax({
              url: ctx + '/api/recommend/generate',
              type: 'POST',
              contentType: 'application/json',
              data: JSON.stringify(param)
            });

            // [핵심] API 응답 결과를 fullPoiList에 넣기 (이러면 watch가 알아서 마커 그림)
            this.fullPoiList = response;

            console.log('백엔드 응답 (POI 목록):', response);
            if (el) el.textContent = paramText + '\n\nPOI 로드 완료. (총 ' + response.length + '개)';

            // 추천 장소 목록이 있으면
            if (response.length > 0) {
              this.panToFirstPoi(response); // 1순위 장소로 지도 이동
            } else {
              // 결과가 없으면 그냥 선택한 지역으로 지도 이동
              this.panToSelectedRegion();
            }

          } catch (e) {
            console.error('코스 생성 실패', e);
            if (el) el.textContent = paramText + '\n\nAPI 호출 실패: ' + (e.responseJSON?.message || e.responseText || e.statusText);
          }
        },

        // --- 지도 관련 함수들 ---

        /** 맨 처음에 지도 세팅 */
        initMap() {
          if (!window.kakao || !window.kakao.maps) {
            console.error("카카오맵 SDK가 로드되지 않았습니다. API 키를 확인하세요.");
            const mapEl = document.getElementById('map-recommend');
            if (mapEl) mapEl.innerHTML = "<h4 style='text-align:center; padding-top: 20px;'>카카오맵 SDK 로딩 실패. API 키(appkey)를 확인하거나, 등록된 도메인(http://localhost:8081)이 맞는지 확인하세요.</h4>";
            return;
          }

          const mapContainer = document.getElementById('map-recommend');
          if (!mapContainer) {
            console.error("#map-recommend 요소를 찾을 수 없습니다.");
            return;
          }

          const mapOption = {
            center: new kakao.maps.LatLng(36.2, 127.6), // (지도의 중심 - 그냥 한반도 중앙쯤)
            level: 12
          };

          this.mapInstance = new kakao.maps.Map(mapContainer, mapOption);
          this.geocoder = new kakao.maps.services.Geocoder();
        },

        /** 지도에 표시된 마커들 지우기 */
        clearMarkers() {
          for (let marker of this.markers) {
            marker.setMap(null);
          }
          this.markers = [];
        },

        /** 필터링된 목록(filteredPoiList)으로 마커 새로 그리기 */
        drawMarkers() {
          if (!this.mapInstance) return;

          this.clearMarkers(); // 일단 기존 마커 싹 지우고 시작

          for (const poi of this.filteredPoiList) {
            // 점수(score)에 따라서 마커 크기를 좀 다르게 해보자
            const scale = 0.7 + (poi.score * 0.6); // 점수(0~1)를 스케일(0.7~1.3)로 변환
            const imgSize = Math.round(32 * scale); // 기본 32px 기준으로 크기 계산

            const markerImage = new kakao.maps.MarkerImage(
              'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
              new kakao.maps.Size(imgSize, imgSize),
              { offset: new kakao.maps.Point(imgSize / 2, imgSize / 2) }
            );

            // 마커 찍기
            const marker = new kakao.maps.Marker({
              map: this.mapInstance,
              position: new kakao.maps.LatLng(poi.mapy, poi.mapx),
              title: poi.title + ` (점수: ${poi.score})`,
              image: markerImage
            });

            this.markers.push(marker); // 나중에 한방에 지우려고 배열에 담아두기
          }
        },

        /** API 결과 오면 첫번째 장소로 지도 이동시키기 */
        panToFirstPoi(poiList) {
          if (!this.mapInstance || !poiList || poiList.length === 0) return;

          const firstPoi = poiList[0]; // 1순위 장소 (제일 점수 높은 곳)
          const coords = new kakao.maps.LatLng(firstPoi.mapy, firstPoi.mapx);

          this.mapInstance.panTo(coords);
          this.mapInstance.setLevel(7); // 줌 레벨은 7 정도로
        },

        /** 추천 장소가 없을 때, 사용자가 고른 지역으로 지도 이동 */
        panToSelectedRegion() {
          if (!this.geocoder || !this.mapInstance || !this.selectedSido) return;

          const address = this.displayRegion; // 예: "서울특별시 강남구"

          this.geocoder.addressSearch(address, (result, status) => {
            if (status === kakao.maps.services.Status.OK) {
              const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
              this.mapInstance.panTo(coords);
              const level = this.selectedSigungu ? 7 : 9;
              this.mapInstance.setLevel(level);
            }
          });
        }
      },
      async mounted() {
        await this.loadSido();
        this.initMap(); // 페이지 열릴 때 딱 한 번 실행
        // (파이 차트/캔버스 관련 기능은 다른 JS 파일에서 가져옴)
      }
    });

    // (달력 관련 기능도 다른 JS 파일에서 가져옴)
    app.mixin(window.ReservationPieMixin);
    app.mixin(window.ReservationCalendarMixin);

    app.mount('#app'); // Vue 앱 시작
  </script>
</body>

</html>