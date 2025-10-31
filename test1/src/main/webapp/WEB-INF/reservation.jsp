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
    /* .tabs, .tab-btn 스타일이 필요하면 여기에 추가하세요. */
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
          // (테마, 지역, 예산, 날짜, 모달 ...)
          themeOptions: [
            { code: 'FAMILY', label: '가족' }, { code: 'FRIEND', label: '친구' },
            { code: 'COUPLE', label: '연인' }, { code: 'LUXURY', label: '호화스러운' },
            { code: 'BUDGET', label: '가성비' }, { code: 'HEALING', label: '힐링' },
            { code: 'UNIQUE', label: '이색적인' }, { code: 'ADVENTURE', label: '모험' },
            { code: 'QUIET', label: '조용한' }
          ],
          selectedThemes: [],
          sidoList: [],
          sigunguList: [],
          selectedSido: '',
          selectedSigungu: '',
          loadingSido: false,
          loadingSigungu: false,
          budget: null,
          headCount: null,
          startDate: null,
          endDate: null,
          selectionState: 'start',
          showBoardModal: false,
          boardUrl: ctx + '/board-view.do',

          // --- 지도/추천 관련 데이터 ---
          mapInstance: null,      
          geocoder: null,       
          markers: [],          
          fullPoiList: [],      
          activeTab: 12,        
          infowindow: null // ⭐ 인포윈도우 객체 (하나만 생성해서 재사용)
        }
      },

      computed: {
        isFormValid() {
          return this.selectedThemes.length > 0 && this.headCount > 0 && this.budget >= 0;
        },
        displayRegion() {
          if (!this.selectedSido) return '미선택';
          const s = this.sidoList.find(x => x.code === this.selectedSido)?.name || '';
          const g = this.sigunguList.find(x => x.code === this.selectedSigungu)?.name || '';
          return s + (g ? ' ' + g : ' (전체)');
        },
        filteredPoiList() {
          return this.fullPoiList.filter(poi => poi.typeId === this.activeTab);
        }
      },

      watch: {
        filteredPoiList(newList, oldList) {
          this.drawMarkers();
        }
      },

      methods: {
        // (loadSido, loadSigungu, ... fnCreate는 수정사항 없음)
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
          this.fullPoiList = []; 
        },
        toggleTheme(code) {
          const i = this.selectedThemes.indexOf(code);
          if (i === -1) this.selectedThemes.push(code);
          else this.selectedThemes.splice(i, 1);
        },
        labelOf(code) { return this.themeOptions.find(t => t.code === code)?.label || code; },
        openBoardModal() { this.showBoardModal = true; /* ... */ },
        closeBoardModal() { this.showBoardModal = false; /* ... */ },
        setActiveTab(typeId) {
          this.activeTab = typeId;
        },
        countForTab(typeId) {
          return this.fullPoiList.filter(p => p.typeId === typeId).length;
        },
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
          const lines = [
            ['themes', (param.themes && param.themes.length) ? param.themes.join(', ') : '(없음)'],
            ['areaCode', String(param.areaCode)], ['sigunguCode', String(param.sigunguCode)],
            ['startDate', String(param.startDate || '미선택')], ['endDate', String(param.endDate || '미선택')]
          ];
          const paramText = lines.map(p => p[0] + ' : ' + p[1]).join('\n');

          if (el) el.textContent = '===== 전송 파라미터 =====\n' + paramText + '\n\n===== POI 조회 중... =====';
          console.log('전송 파라미터:', param);
          this.fullPoiList = []; 
          this.clearMarkers();   

          try {
            const response = await $.ajax({
              url: ctx + '/api/recommend/generate',
              type: 'POST',
              contentType: 'application/json',
              data: JSON.stringify(param)
            });
            this.fullPoiList = response;
            console.log('백엔드 응답 (POI 목록):', response);
            if (el) el.textContent = paramText + '\n\nPOI 로드 완료. (총 ' + response.length + '개)';
            if (response.length > 0) {
              this.panToFirstPoi(response); 
            } else {
              this.panToSelectedRegion();
            }
          } catch (e) {
            console.error('코스 생성 실패', e);
            if (el) el.textContent = paramText + '\n\nAPI 호출 실패: ' + (e.responseJSON?.message || e.responseText || e.statusText);
          }
        },

        // --- 지도 관련 함수들 ---

        /** 맨 처음에 지도 세팅 (⭐ 인포윈도우 생성 추가) */
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
            center: new kakao.maps.LatLng(36.2, 127.6), 
            level: 12
          };

          this.mapInstance = new kakao.maps.Map(mapContainer, mapOption);
          this.geocoder = new kakao.maps.services.Geocoder();

          // ⭐ [신규] 인포윈도우 객체 생성
          this.infowindow = new kakao.maps.InfoWindow({
              content: '', 
              removable: true // 닫기 버튼(X) 추가
          });
        },

        /** 지도에 표시된 마커들 지우기 (⭐ 인포윈도우 닫기 추가) */
        clearMarkers() {
          // ⭐ [신규] 열려있는 인포윈도우 닫기
          if (this.infowindow) {
            this.infowindow.close();
          }

          for (let marker of this.markers) {
            marker.setMap(null);
          }
          this.markers = [];
        },

        
        // ==========================================
        // ⭐ [수정] drawMarkers (디버깅 코드 포함)
        // ==========================================
        /** 필터링된 목록(filteredPoiList)으로 마커 새로 그리기 */
        drawMarkers() {
          if (!this.mapInstance) {
            console.error("지도 인스턴스가 없습니다. initMap()을 확인하세요.");
            return;
          }

          this.clearMarkers(); // 인포윈도우 닫기 포함

          if (!this.filteredPoiList || this.filteredPoiList.length === 0) {
            console.log("drawMarkers: 마커를 그릴 데이터가 없습니다. (filteredPoiList가 비어있음)");
            return;
          }

          for (const poi of this.filteredPoiList) {

            const score = (typeof poi.score === 'number') ? poi.score : 0;
            const mapy_num = parseFloat(poi.mapy);
            const mapx_num = parseFloat(poi.mapx);

            if (isNaN(mapy_num) || isNaN(mapx_num)) {
              console.warn("좌표값이 (숫자로 변환 불가능한) POI가 있어 건너뜁니다:", poi);
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
              title: poi.title + ` (점수: ${score.toFixed(2)})`,
              image: markerImage
            });

            // [⭐ 수정] 마커 클릭 이벤트 로직 (디버깅용)
            kakao.maps.event.addListener(marker, 'click', () => {
              const title = poi.title || "이름 없음";
              const imageUrl = poi.firstimage2 || poi.firstimage; 
              let content = '';

              // [⭐ 디버깅] URL 문자열을 빨간색으로 표시
              const debugUrlText = imageUrl ? `[URL: ${imageUrl}]` : "[URL: (null or empty)]";

              if (imageUrl) {
                // 이미지가 있는 경우: 이미지 + 제목 + 디버그 URL
                content = `
                  <div style="padding:7px; width: 200px; text-align: center; box-sizing: border-box;">
                      <img src="${imageUrl}" 
                           width="180" height="120" 
                           style="object-fit: cover; border: 1px solid #ccc; border-radius: 4px; max-width: 100%;">
                      <div style="font-weight: bold; margin-top: 5px; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                          ${title}
                      </div>
                      <div style="font-size: 10px; color: #f00; word-break: break-all; margin-top: 5px; text-align: left;">
                          ${debugUrlText}
                      </div>
                  </div>
                `;
              } else {
                // 이미지가 없는 경우: "이미지 없음" + 제목
                content = `
                  <div style="padding:7px; width: 200px; text-align: center; box-sizing: border-box;">
                      <div style="width: 180px; height: 120px; background: #f0f0f0; border: 1px solid #ccc; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #888; font-size: 12px;">
                          (이미지 없음)
                      </div>
                      <div style="font-weight: bold; margin-top: 5px; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                          ${title}
                      </div>
                      <div style="font-size: 10px; color: #f00; word-break: break-all; margin-top: 5px; text-align: left;">
                          ${debugUrlText}
                      </div>
                  </div>
                `;
              }

              // 2. 인포윈도우 내용 설정
              this.infowindow.setContent(content);
              
              // 3. 인포윈도우 열기
              this.infowindow.open(this.mapInstance, marker);
            });
            // [⭐ 수정] 이벤트 추가 끝

            this.markers.push(marker); // 나중에 한방에 지우려고 배열에 담아두기
          }
        },
        
        /** API 결과 오면 첫번째 장소로 지도 이동시키기 */
        panToFirstPoi(poiList) {
          if (!this.mapInstance || !poiList || poiList.length === 0) return;
          const firstPoi = poiList[0]; 
          
          const firstMapy = parseFloat(firstPoi.mapy);
          const firstMapx = parseFloat(firstPoi.mapx);

          if (isNaN(firstMapy) || isNaN(firstMapx)) {
            console.warn("첫번째 POI 좌표값이 잘못되어 지도를 이동할 수 없습니다.", firstPoi);
            return;
          }

          const coords = new kakao.maps.LatLng(firstMapy, firstMapx);
          this.mapInstance.panTo(coords);
          this.mapInstance.setLevel(7); 
        },

        /** 추천 장소가 없을 때, 사용자가 고른 지역으로 지도 이동 */
        panToSelectedRegion() {
          if (!this.geocoder || !this.mapInstance || !this.selectedSido) return;
          const address = this.displayRegion; 

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
        this.initMap(); // 페이지 열릴 때 딱 한 번 실행 (이때 인포윈도우도 생성됨)
      }
    });

    // 믹스인 주입
    app.mixin(window.ReservationPieMixin);
    app.mixin(window.ReservationCalendarMixin);

    app.mount('#app'); // Vue 앱 시작
  </script>
</body>

</html>