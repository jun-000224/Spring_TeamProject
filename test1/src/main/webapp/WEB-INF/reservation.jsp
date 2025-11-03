<%-- [수정] 500 에러 방지를 위해 isELIgnored="true" 추가 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
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

  <%-- [수정] isELIgnored=true 사용 시 ${} 대신 <%= %> 사용 --%>
  <script>const ctx = '<%= request.getContextPath() %>';</script>

  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation.css" />
  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">

  <style>
    /* CSS는 분리된 .css 파일을 사용 */
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
          <div class="region-select-wrap">
            <div class="field">
              <label>시/도</label>
              <select v-model="currentSido" @change="onChangeSido" :disabled="loadingSido">
                <option value="">선택</option>
                <option v-for="s in sidoList" :key="s.code" :value="s.code">{{ s.name }}</option>
              </select>
            </div>
            <div class="field">
              <label>시/군/구</label>
              <select v-model="currentSigungu" :disabled="!sigunguList.length || loadingSigungu">
                <option value="">전체</option>
                <option v-for="g in sigunguList" :key="g.code" :value="g.code">{{ g.name }}</option>
              </select>
            </div>
            <button class="btn-add-region" @click="addRegion" :disabled="!currentSido" title="지역 추가">+</button>
          </div>
          
          <div class="chips" v-if="selectedRegions.length > 0">
            <span class="chip" v-for="(region, index) in selectedRegions" :key="index">
              {{ region.name }}
              <button @click="removeRegion(index)" title="삭제">&times;</button>
            </span>
          </div>
          <div class="desc" v-else>
            방문할 지역을 선택한 후 '+' 버튼을 눌러 목록에 추가해주세요. (복수 선택 가능)
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

            <div class.actions>
              <button class="btn-primary" @click="fnCreate">코스 생성하기</button>
            </div>

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

        <div class="tabs date-tabs" v-if="dateTabs.length > 0">
          <button type="button" 
                  v-for="tab in dateTabs" 
                  :key="tab.date"
                  :class="['tab-btn', { active: activeDate === tab.date }]" 
                  @click="setActiveDate(tab.date)">
            {{ tab.label }}
          </button>
        </div>
        <div class="desc" v-else>
          먼저 캘린더에서 여행 <strong>시작일</strong>과 <strong>종료일</strong>을 선택해주세요.
        </div>

        <div class="region-filter-wrap" v-if="selectedRegions.length > 0">
            <label for="region-filter">지역 필터:</label>
            <select id="region-filter" v-model="activeRegion" @change="onRegionChange">
                <option value="all">전체 보기</option>
                <option v-for="(region, index) in selectedRegions" :key="index" :value="index">
                    {{ region.name }}
                </option>
            </select>
        </div>

        <div class="tabs" v-if="activeDate">
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
        
        <div class="poi-add-panel" v-if="selectedPoi && activeDate">
           <strong>{{ selectedPoi.title || "이름 없음" }}</strong>
           <button class="btn-primary" @click="addPoiToItinerary">
              [ {{ activeDateLabel }} ] 일정에 추가하기
           </button>
           <button class="btn-secondary" @click="selectedPoi = null; infowindow.close();">취소</button>
        </div>
        
        <div class="itinerary-list" v-if="activeItinerary.length > 0">
          <h4>[ {{ activeDateLabel }} ] 일정 목록</h4>
          <ul>
            <li v-for="(poi, index) in activeItinerary" :key="poi.contentId + '-' + index">
              <span>{{ poi.title || "이름 없음" }} ({{ poi.typeId === 12 ? '관광' : (poi.typeId === 32 ? '숙박' : '식당') }})</span>
              <button @click="removePoiFromItinerary(index)">삭제</button>
            </li>
          </ul>
        </div>
        <div class="desc" v-if="activeDate && activeItinerary.length === 0">
          이 날짜의 일정이 비어있습니다. 지도에서 마커를 클릭하여 일정을 추가하세요.
        </div>

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

  <script src="<%= request.getContextPath() %>/js/reservation-pie.js"></script>
  <script src="<%= request.getContextPath() %>/js/reservation-calendar.js"></script>
  
  <%@ include file="components/footer.jsp" %>

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
          loadingSido: false,
          loadingSigungu: false,
          
          // [신규] 멀티 지역 선택용
          currentSido: '',      // 현재 <select>에서 선택중인 시/도
          currentSigungu: '', // 현재 <select>에서 선택중인 시/군/구
          selectedRegions: [],  // '+' 버튼으로 추가된 지역 목록 (백엔드에 보낼 데이터)
          
          // 예산, 인원
          budget: null,
          headCount: null,

          // [수정] 달력 믹스인(calendar.js)용 (data에 선언)
          startDate: null,
          endDate: null,
          selectionState: 'start',
          
          // 모달
          showBoardModal: false,
          boardUrl: ctx + '/board-view.do', // [수정] ctx 사용

          // 지도
          mapInstance: null,      
          geocoder: null,       
          markers: [],          
          fullPoiList: [],      // 백엔드에서 받은 '모든 지역'의 POI 원본
          activeTab: 12,        
          infowindow: null,
          
          // 일정 플래너
          itinerary: {}, 
          activeDate: null, 
          selectedPoi: null,
          
          // [신규] 지역 필터
          activeRegion: 'all' // 지도에 표시할 지역 필터 ('all' 또는 selectedRegions의 index)
        }
      },

      computed: {
        isFormValid() {
          return this.selectedThemes.length > 0 && this.headCount > 0 && this.budget >= 0;
        },
        // [신규] 현재 '선택 중인' 지역 표시용
        displayRegion() {
          if (!this.currentSido) return '미선택';
          const s = this.sidoList.find(x => x.code === this.currentSido)?.name || '';
          const g = this.sigunguList.find(x => x.code === this.currentSigungu)?.name || '';
          return s + (g ? ' ' + g : ' (전체)');
        },
        
        // --- 필터링 로직 (신규/수정) ---
        
        // 1. [신규] 지역 필터링
        regionFilteredList() {
          let list = this.fullPoiList;
          if (this.activeRegion === 'all') {
            return list; // '전체' 선택 시 모든 POI 반환
          }
          
          const selected = this.selectedRegions[this.activeRegion];
          if (!selected) {
            return []; // 선택된 지역이 없으면 빈 목록 반환
          }

          list = list.filter(poi => {
            const poiArea = String(poi.areaCode);
            const poiSigungu = String(poi.sigunguCode); 
            const selectedArea = String(selected.sidoCode);
            const selectedSigungu = String(selected.sigunguCode); 
            
            if (selected.sigunguCode === null || selected.sigunguCode === 'null') { 
              return poiArea === selectedArea; // "서울 (전체)"
            }
            return poiArea === selectedArea && poiSigungu === selectedSigungu; // "서울 강남구"
          });
          
          return list;
        },

        // 2. [수정] 카테고리 필터링
        filteredPoiList() {
          // 1차로 거른 'regionFilteredList'에서 카테고리(activeTab)로 2차 필터링
          return this.regionFilteredList.filter(poi => poi.typeId === this.activeTab);
        },
        
        // --- 일정 플래너 Computed ---

        dateTabs() {
          if (!this.startDate || !this.endDate) return [];
          
          let tabs = [];
          let currentDate = new Date(this.startDate); 
          let stopDate = new Date(this.endDate);
          let dayCount = 1;
          
          while (currentDate <= stopDate) {
            const dateStr = currentDate.toISOString().split('T')[0];
            const month = currentDate.getMonth() + 1;
            const day = currentDate.getDate();
            
            tabs.push({
              date: dateStr, 
              label: `${month}월 ${day}일 (${dayCount}일차)`
            });
            
            currentDate.setDate(currentDate.getDate() + 1);
            dayCount++;
          }
          return tabs;
        },
        
        activeDateLabel() {
            if (!this.activeDate || !this.dateTabs.length) return "";
            const activeTab = this.dateTabs.find(d => d.date === this.activeDate);
            return activeTab ? activeTab.label : "";
        },
        
        activeItinerary() {
          return this.itinerary[this.activeDate] || [];
        }
      },

      watch: {
        // [수정] filteredPoiList (최종 필터링된 목록)이 바뀌면 마커를 다시 그림
        filteredPoiList(newList, oldList) {
          this.drawMarkers();
        },
        
        // [수정] "월 일" 버그 수정을 위해 dateTabs를 감시
        dateTabs(newTabs, oldTabs) {
          if (newTabs.length > 0 && (oldTabs.length === 0 || this.activeDate === null)) {
            // 날짜 탭이 처음 생성되거나, 리셋되었다가 다시 생성될 때
            this.activeDate = newTabs[0].date;
            this.itinerary = {}; 
            this.selectedPoi = null; 
          } else if (newTabs.length === 0 && oldTabs.length > 0) {
            // 날짜 선택이 리셋될 때
            this.activeDate = null;
            this.itinerary = {};
            this.selectedPoi = null;
          }
        }
      },

      methods: {
        // --- 기본 UI 메소드 (테마, 지역, 모달) ---
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
            if (!self.currentSido) return; // [수정] currentSido 사용
            const data = await $.get(ctx + '/api/areas/sigungu', { areaCode: self.currentSido });
            self.sigunguList = Array.isArray(data) ? data : [];
          } catch (e) { console.error('시/군/구 조회 실패', e); }
          finally { self.loadingSigungu = false; }
        },
        onChangeSido() {
          this.currentSigungu = ''; // [수정] currentSigungu 사용
          this.sigunguList = [];
          this.loadSigungu();
        },
        toggleTheme(code) {
          const i = this.selectedThemes.indexOf(code);
          if (i === -1) this.selectedThemes.push(code);
          else this.selectedThemes.splice(i, 1);
        },
        labelOf(code) { return this.themeOptions.find(t => t.code === code)?.label || code; },
        openBoardModal() { this.showBoardModal = true; },
        closeBoardModal() { this.showBoardModal = false; },

        // --- [신규] 지역 (멀티) 관련 메소드 ---
        addRegion() {
          if (!this.currentSido) return; 
          
          const sidoName = this.sidoList.find(s => s.code === this.currentSido)?.name || '';
          const sigunguName = this.sigunguList.find(g => g.code === this.currentSigungu)?.name || '';
          
          const regionName = sidoName + (sigunguName ? ' ' + sigunguName : ' (전체)');
          const sigunguCodeVal = this.currentSigungu || null; // 빈 문자열은 null로
          
          const isDuplicate = this.selectedRegions.some(r => 
              r.sidoCode === this.currentSido && r.sigunguCode === sigunguCodeVal
          );

          if (!isDuplicate) {
             this.selectedRegions.push({
                sidoCode: this.currentSido,
                sigunguCode: sigunguCodeVal,
                name: regionName
             });
          } else {
            alert("이미 추가된 지역입니다.");
          }

          // 선택 드롭다운 초기화
          this.currentSido = '';
          this.currentSigungu = '';
          this.sigunguList = [];
        },
        removeRegion(index) {
          this.selectedRegions.splice(index, 1);
          // 만약 지운 지역이 현재 필터였다면 '전체'로 복귀
          if (this.activeRegion == index) { 
              this.activeRegion = 'all';
          }
        },

        // --- 플래너/지도 관련 메소드 ---

        // [신규] 지역 필터 드롭다운 변경 시
        onRegionChange() {
            this.selectedPoi = null;
            if (this.infowindow) {
                this.infowindow.close();
            }
            // (watch가 filteredPoiList를 감지하여 drawMarkers를 자동 호출)
        },

        // 카테고리 탭(관광지/숙박/식당) 클릭
        setActiveTab(typeId) {
          this.activeTab = typeId;
          this.selectedPoi = null; 
          if (this.infowindow) {
            this.infowindow.close(); 
          }
        },
        // [수정] 카테고리별 POI 개수 카운트
        countForTab(typeId) {
          // 1차 필터링된 'regionFilteredList' 기준으로 카운트
          return this.regionFilteredList.filter(p => p.typeId === typeId).length;
        },

        // "코스 생성하기" 버튼 (백엔드 API 호출)
        async fnCreate() {
          // [수정] 멀티 지역 선택 검증
          if (this.selectedRegions.length === 0) {
              if (this.currentSido) {
                  alert("지역을 선택한 후 '+' 버튼을 눌러 목록에 추가해주세요.");
              } else {
                  alert("방문할 지역을 1개 이상 선택해주세요.");
              }
              return;
          }

          const el = document.getElementById('debugOut');
          const param = {
            themes: this.selectedThemes,
            regions: this.selectedRegions, // [수정] 백엔드로 지역 '배열' 전송
            headCount: this.headCount,
            budget: this.budget,
            startDate: this.startDate, 
            endDate: this.endDate, 
            budgetWeights: {
              etc: this.weights[0], accom: this.weights[1],
              food: this.weights[2], act: this.weights[3]
            }
          };

          if (el) el.textContent = '===== POI 조회 중... =====';
          console.log('전송 파라미터:', param);
          this.fullPoiList = [];
          this.clearMarkers();
          this.activeRegion = 'all'; // API 호출 시 지역 필터는 '전체'로 초기화

          try {
            const response = await $.ajax({
              url: ctx + '/api/recommend/generate',
              type: 'POST',
              contentType: 'application/json',
              data: JSON.stringify(param)
            });
            this.fullPoiList = response; 
            console.log('백엔드 응답 (POI 목록):', response);
            if (el) el.textContent = 'POI 로드 완료. (총 ' + response.length + '개)';

            if (response.length > 0) {
              this.panToFirstPoi(response);
            }
            // [수정] 결과 없을 시 panToSelectedRegion() 호출 제거 (다중 지역이므로)
          } catch (e) {
            console.error('코스 생성 실패', e);
            if (el) el.textContent = 'API 호출 실패: ' + (e.responseJSON?.message || e.responseText || e.statusText);
          }
        },

        // --- 지도 관련 함수들 ---

        // 지도 초기화 (최초 1회 실행)
        initMap() {
          if (!window.kakao || !window.kakao.maps) {
            console.error("카카오맵 SDK가 로드되지 않았습니다.");
            const mapEl = document.getElementById('map-recommend');
            if (mapEl) mapEl.innerHTML = "<h4 style='text-align:center; padding-top: 20px;'>카카오맵 SDK 로딩 실패. API 키(appkey)를 확인하세요.</h4>";
            return;
          }
          const mapContainer = document.getElementById('map-recommend');
          if (!mapContainer) {
            console.error("#map-recommend 요소를 찾을 수 없습니다.");
            return;
          }
          const mapOption = {
            center: new kakao.maps.LatLng(36.2, 127.6),
            level: 12
          };
          this.mapInstance = new kakao.maps.Map(mapContainer, mapOption);
          this.geocoder = new kakao.maps.services.Geocoder();
          this.infowindow = new kakao.maps.InfoWindow({
            content: '',
            removable: true
          });
        },

        // 지도 위 마커/인포윈도우/선택패널 모두 제거
        clearMarkers() {
          if (this.infowindow) {
            this.infowindow.close();
          }
          for (let marker of this.markers) {
            marker.setMap(null);
          }
          this.markers = [];
          this.selectedPoi = null; // POI 선택 패널 닫기
        },


        // POI 목록으로 마커 그리기
        drawMarkers() {
          if (!this.mapInstance) return;
          this.clearMarkers();
          
          // [수정] 최종 필터링된 'filteredPoiList' 사용
          if (!this.filteredPoiList || this.filteredPoiList.length === 0) {
            return;
          }

          for (const poi of this.filteredPoiList) {
            const score = (typeof poi.score === 'number') ? poi.score : 0;
            const mapy_num = parseFloat(poi.mapy);
            const mapx_num = parseFloat(poi.mapx);
            if (isNaN(mapy_num) || isNaN(mapx_num)) {
              console.warn("좌표값이 잘못된 POI가 있어 건너뜁니다:", poi);
              continue;
            }

            const scale = 0.7 + (score * 0.6);
            const imgSize = Math.round(32 * scale);
            const markerImage = new kakao.maps.MarkerImage(
              'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png',
              new kakao.maps.Size(imgSize, imgSize),
              { offset: new kakao.maps.Point(imgSize / 2, imgSize / 2) }
            );

            const marker = new kakao.maps.Marker({
              map: this.mapInstance,
              position: new kakao.maps.LatLng(mapy_num, mapx_num),
              // [수정] JSP 500 에러 방지를 위해 `${}` 대신 문자열 연결
              title: poi.title + ' (점수: ' + score.toFixed(2) + ')',
              image: markerImage
            });

            // 마커 클릭 이벤트
            kakao.maps.event.addListener(marker, 'click', () => {
              this.selectedPoi = poi; // "일정 추가" 패널용

              // 인포윈도우 띄우기 (이미지 "false" 문자열, http 체크)
              const title = poi.title || "이름 없음";
              let imageUrl = poi.firstimage2 || poi.firstimage; 
              let content = '';
              let isValidImage = false;
              if (imageUrl && imageUrl !== "false" && imageUrl.trim() !== "") {
                  isValidImage = true;
                  if (imageUrl.startsWith('http://')) {
                      imageUrl = imageUrl.replace('http://', 'https://');
                  }
              }

              if (isValidImage) {
                content = `
                  <div style="padding:7px; width: 200px; text-align: center; box-sizing: border-box;">
                      <img src="${imageUrl}" 
                           width="180" height="120" 
                           style="object-fit: cover; border: 1px solid #ccc; border-radius: 4px; max-width: 100%;">
                      <div style="font-weight: bold; margin-top: 5px; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                          ${title}
                      </div>
                  </div>
                `;
              } else {
                content = `
                  <div style="padding:7px; width: 200px; text-align: center; box-sizing: border-box;">
                      <div style="width: 180px; height: 120px; background: #f0f0f0; border: 1px solid #ccc; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #888; font-size: 12px;">
                          (이미지 없음)
                      </div>
                      <div style="font-weight: bold; margin-top: 5px; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                          ${title}
                      </div>
                  </div>
                `;
              }
              
              this.infowindow.setContent(content);
              this.infowindow.open(this.mapInstance, marker);
            });

            this.markers.push(marker);
          }
        },
        
        // 추천 목록 중 첫번째 POI로 지도 이동
        panToFirstPoi(poiList) {
          if (!this.mapInstance || !poiList || poiList.length === 0) return;
          const firstPoi = poiList[0]; 
          const firstMapy = parseFloat(firstPoi.mapy);
          const firstMapx = parseFloat(firstPoi.mapx);
          if (isNaN(firstMapy) || isNaN(firstMapx)) return;
          const coords = new kakao.maps.LatLng(firstMapy, firstMapx);
          this.mapInstance.panTo(coords);
          this.mapInstance.setLevel(7); 
        },

        // [수정] panToSelectedRegion (다중 지역이라 사용 보류)
        panToSelectedRegion() {
          console.log("panToSelectedRegion: 다중 지역 선택 모드에서는 사용하지 않음.");
        },

        // --- 일정 플래너 메소드 ---

        // 날짜 탭 클릭
        setActiveDate(date) {
          this.activeDate = date;
          this.selectedPoi = null; 
          if (this.infowindow) {
            this.infowindow.close(); 
          }
        },

        // "일정에 추가하기" 버튼 클릭
        addPoiToItinerary() {
          if (!this.activeDate || !this.selectedPoi) return;
          if (!this.itinerary[this.activeDate]) {
            this.itinerary[this.activeDate] = [];
          }
          this.itinerary[this.activeDate].push({ ...this.selectedPoi });
          this.selectedPoi = null;
          if (this.infowindow) {
            this.infowindow.close();
          }
        },

        // 일정 목록에서 "삭제" 버튼 클릭
        removePoiFromItinerary(index) {
           if (this.itinerary[this.activeDate] && this.itinerary[this.activeDate].length > index) {
             this.itinerary[this.activeDate].splice(index, 1);
           }
        }
        
      },
      
      // Vue 인스턴스가 마운트될 때 실행
      async mounted() {
        await this.loadSido();
        this.initMap();
        // 믹스인(pie.js, calendar.js)은 app.mixin()을 통해 자동으로 mounted 됨
      }
    });

    // 믹스인 주입
    app.mixin(window.ReservationPieMixin);
    app.mixin(window.ReservationCalendarMixin);

    app.mount('#app'); // Vue 앱 시작
  </script>
</body>

</html>