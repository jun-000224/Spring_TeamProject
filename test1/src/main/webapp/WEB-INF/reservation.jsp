<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %> <% String resNum =
String.valueOf(request.getAttribute("resNum")); %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>Reservation</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />

    <script
      src="https://code.jquery.com/jquery-3.7.1.js"
      integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
      crossorigin="anonymous"
    ></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"></script>

    <script>
      const ctx = "<%= request.getContextPath() %>";
    </script>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation.css" />
    <link rel="stylesheet" href="/css/main-style.css" />
    <link rel="stylesheet" href="/css/common-style.css" />
    <link rel="stylesheet" href="/css/header-style.css" />
    <link rel="stylesheet" href="/css/main-images.css" />

    <style>
      /* CSS는 분리된 .css 파일을 사용 */
      /* 하단 고정 버튼 스타일 */
      .page-title2 {
        font-size: 2.25rem;
        font-weight: 700;
        color: #2c3e50;
        border-bottom: 3px solid var(--brand);
        padding-bottom: 10px;
        margin-bottom: 20px;
      }
      .fixed-bottom-bar {
        position: fixed;
        bottom: 0;
        left: 0;
        width: 100%;
        background: #fff;
        border-top: 1px solid #ddd;
        padding: 15px;
        text-align: center;
        box-shadow: 0 -2px 5px rgba(0, 0, 0, 0.05);
        z-index: 1000;
      }

      .fixed-bottom-bar button {
        padding: 12px 30px;
        font-size: 1.1em;
      }
    </style>
  </head>

  <body>
    <%@ include file="components/header.jsp" %>
    <div id="app">
      <div class="wrap" style="padding-bottom: 80px">
        <h1 class="page-title2">예약하기</h1>
        <div class="grid two-col">
          <section class="panel">
            <h3>테마 선택 <span class="desc">복수 선택 가능</span></h3>
            <div class="desc">선택된 테마는 아래에 간단히 표시됩니다.</div>
            <div class="theme-grid">
              <button
                v-for="item in themeOptions"
                :key="item.code"
                type="button"
                :class="['theme-btn', { active: selectedThemes.includes(item.code) }]"
                @click="toggleTheme(item.code)"
              >
                {{ item.label }}
              </button>
            </div>
            <div class="chips" v-if="selectedThemes.length">
              <span class="chip" v-for="t in selectedThemes" :key="t">{{ labelOf(t) }}</span>
            </div>
            <div class="desc" v-else>선택: 없음</div>

            <h3 style="margin-top: 14px">지역 선택</h3>
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
            <div class="desc" v-else>방문할 지역을 선택한 후 '+' 버튼을 눌러 목록에 추가해주세요. (복수 선택 가능)</div>
          </section>

          <section class="panel">
            <h3 style="margin-top: 14px">일정 선택</h3>
            <div class="field-row">
              <div class="field">
                <label>시작일</label>
                <input type="text" :value="startDate || ''" readonly placeholder="달력에서 선택" />
              </div>
              <div class="field">
                <label>종료일</label>
                <input type="text" :value="endDate || ''" readonly placeholder="달력에서 선택" />
              </div>
            </div>
            <div class="inline" style="margin-top: 2px; margin-bottom: 8px">
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
                <div v-for="(day, i) in calendarGrid" :key="i" :class="['cal-day', getDayClasses(day)]" @click="selectDate(day)">
                  {{ day.dayNum }}
                </div>
              </div>
            </div>

            <br />
            <h3>인원 / 예산</h3>
            <div class="field">
              <label>총원</label>
              <input type="number" min="1" v-model.number="headCount" placeholder="총 인원수를 입력하세요." />
            </div>
            <div class="field">
              <label>예산(원)</label>
              <input type="number" min="0" step="1000" v-model.number="budget" @input="onBudgetChange" placeholder="예산을 입력하세요." />
            </div>
            <div class="inline" style="margin-top: 2px">
              입력값: 인원 <strong>{{ headCount || 0 }}</strong
              >명 / 예산 <strong>{{ (budget || 0).toLocaleString() }}</strong
              >원
            </div>
          </section>
        </div>

        <section class="panel" style="margin-top: 10px">
          <h3>예산 배분</h3>
          <div class="desc">
            원형 차트의 분기점을 <b>드래그</b>하거나, 오른쪽 슬라이더로 가중치를 조정하세요. (총합 100%) 체크박스를 켜면 해당 항목이
            <b>잠금</b>됩니다.
          </div>
          <div class="pie-wrap">
            <div>
              <canvas
                id="budgetPie"
                width="640"
                height="480"
                @mousedown="onPieDown"
                @mousemove="onPieMove"
                @mouseup="onPieUp"
                @mouseleave="onPieUp"
                @touchstart.prevent="onPieDownTouch"
                @touchmove.prevent="onPieMoveTouch"
                @touchend.prevent="onPieUp"
              ></canvas>
              <div class="help">*도넛 두께 영역을 잡고 <strong>분기점</strong>을 회전시키세요. (잠금된 항목은 비율 고정)</div>
              <br />
              <div class="actions">
                <button class="btn-primary" @click="fnCreate">추천 목록 생성</button>
              </div>
            </div>
            <div class="legend">
              <div class="legend-row" v-for="(c,idx) in categories" :key="c.key">
                <label style="display: flex; align-items: center; gap: 6px; min-width: 22px">
                  <input type="checkbox" v-model="locks[idx]" @change="normalizeWeights(); drawPie()" />
                </label>
                <span class="swatch" :style="{ background:c.color }"></span>
                <div style="flex: 1">
                  <div style="display: flex; justify-content: space-between; align-items: center; gap: 10px; margin-bottom: 4px">
                    <strong>
                      {{ c.label }}
                      <span v-if="locks[idx]" style="font-weight: 600; color: #2563eb; margin-left: 6px">🔒</span>
                    </strong>
                    <span class="pct">{{ weights[idx] }}%</span>
                    <span class="amount">{{ amountFor(idx).toLocaleString() }}원</span>
                  </div>
                  <input type="range" min="5" max="90" :value="weights[idx]" @input="onSlider(idx, $event.target.value)" :disabled="locks[idx]" />
                </div>
              </div>
              <div class="inline" style="margin-top: 4px">
                합계: <strong>{{ weights.reduce((a,b)=>a+Number(b),0) }}</strong
                >%
              </div>
            </div>
          </div>
        </section>

        <section class="panel" style="margin-top: 10px">
          <h3>추천 코스 (지도)</h3>
          <div class="desc">*연관도가 높을수록 마커가 <strong>크게</strong> 표시됩니다.</div>

          <div class="tabs date-tabs" v-if="dateTabs.length > 0">
            <button
              type="button"
              v-for="tab in dateTabs"
              :key="tab.date"
              :class="['tab-btn', { active: activeDate === tab.date }]"
              @click="setActiveDate(tab.date)"
            >
              {{ tab.label }}
            </button>
          </div>
          <div class="desc" v-else>먼저 캘린더에서 여행 <strong>시작일</strong>과 <strong>종료일</strong>을 선택해주세요.</div>

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
            <%-- [삭제] 카페 탭 제거 (typeId 40) --%> <%--
            <button type="button" :class="['tab-btn', { active: activeTab === 40 }]" @click="setActiveTab(40)">
              <i class="fa-solid fa-mug-hot"></i> 카페 ({{ countForTab(40) }})
            </button>
            --%>
          </div>

          <div id="map-recommend" class="map-recommend-area"></div>
          <div id="debugOut" style="display: none"></div>

          <div class="poi-add-panel" v-if="selectedPoi && activeDate">
            <strong>{{ selectedPoi.title || "이름 없음" }}</strong>
            <button class="btn-primary" @click="addPoiToItinerary">[ {{ activeDateLabel }} ] 일정에 추가하기</button>
            <button class="btn-secondary" @click="selectedPoi = null; infowindow.close();">취소</button>
          </div>
        </section>

        <section class="panel" style="margin-top: 10px">
          <h3>나의 최종 일정 (순서 변경 가능)</h3>

          <div class="budget-status-wrap" v-if="budget > 0">
            <div class="budget-status-item">
              <span class="label">숙박 예산</span>
              <span :class="['amount', { over: spentAccom > accomBudgetLimit }]">
                <span class="current">{{ spentAccom.toLocaleString() }}원</span> /
                <span class="total">{{ accomBudgetLimit.toLocaleString() }}원</span>
              </span>
            </div>
            <div class="budget-status-item">
              <%-- 식당/카페 예산을 식당 예산으로 변경 --%>
              <span class="label">식당 예산</span>
              <span :class="['amount', { over: spentFood > foodBudgetLimit }]">
                <span class="current">{{ spentFood.toLocaleString() }}원</span> /
                <span class="total">{{ foodBudgetLimit.toLocaleString() }}원</span>
              </span>
            </div>
            <div class="budget-status-item">
              <span class="label">체험/관광 예산</span>
              <span :class="['amount', { over: spentActivity > activityBudgetLimit }]">
                <span class="current">{{ spentActivity.toLocaleString() }}원</span> /
                <span class="total">{{ activityBudgetLimit.toLocaleString() }}원</span>
              </span>
            </div>
          </div>

          <div class="desc" v-if="dateTabs.length > 0">일정 항목을 마우스로 잡고 위아래로 끌어서 순서를 변경할 수 있습니다.</div>

          <div v-if="dateTabs.length > 0">
            <div v-for="tab in dateTabs" :key="tab.date" class="itinerary-day-block">
              <h4>[ {{ tab.label }} ] 일정 목록</h4>

              <div class="itinerary-list" v-if="itinerary[tab.date] && itinerary[tab.date].length > 0">
                <ul>
                  <li
                    v-for="(poi, index) in itinerary[tab.date]"
                    :key="poi.contentId + '-' + index"
                    :draggable="true"
                    :class="{ 
                        dragging: isDragging(tab.date, index),
                        'drag-over': isDragOver(tab.date, index) 
                      }"
                    @dragstart="onDragStart(tab.date, index)"
                    @dragover.prevent="onDragOver(tab.date, index)"
                    @dragleave="onDragLeave"
                    @drop="onDrop(tab.date, index)"
                    @dragend="onDragEnd"
                  >
                    <span>
                      {{ poi.title || "이름 없음" }}
                      <%-- [수정] 카페 표시 로직 제거 (typeId 40) --%> ({{ poi.typeId === 12 ? "관광" : poi.typeId === 32 ? "숙박" : "식당" }})
                      <span v-if="poi.price > 0" style="color: #64748b; font-size: 0.9em; margin-left: 5px">
                        - {{ poi.price.toLocaleString() }}원
                      </span>
                    </span>
                    <button @click.stop="removePoiFromItinerary(tab.date, index)">삭제</button>
                  </li>
                </ul>
              </div>
              <div class="desc" v-else>- 일정이 비어있습니다 -</div>
            </div>
          </div>
          <div class="desc" v-else>먼저 캘린더에서 여행 <strong>시작일</strong>과 <strong>종료일</strong>을 선택해주세요.</div>
        </section>

        <div class="fixed-bottom-bar">
          <button class="btn-primary" @click="fnSaveTrip" :disabled="Object.values(itinerary).flat().length === 0">
            코스 생성 완료 및 예약 내역 확인하기
          </button>
        </div>

        <button class="fab" @click="openBoardModal" aria-label="커뮤니티 열기" title="커뮤니티">
          <svg
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            aria-hidden="true"
          >
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
            themeOptions: [
              { code: "FAMILY", label: "가족" },
              { code: "FRIEND", label: "친구" },
              { code: "COUPLE", label: "연인" },
              { code: "LUXURY", label: "호화스러운" },
              { code: "BUDGET", label: "가성비" },
              { code: "HEALING", label: "힐링" },
              { code: "UNIQUE", label: "이색적인" },
              { code: "ADVENTURE", label: "모험" },
              { code: "QUIET", label: "조용한" },
            ],
            selectedThemes: [],
            sidoList: [],
            sigunguList: [],
            loadingSido: false,
            loadingSigungu: false,
            currentSido: "",
            currentSigungu: "",
            selectedRegions: [],
            budget: null,
            headCount: null,
            spentAccom: 0,
            spentFood: 0,
            spentActivity: 0,
            startDate: null,
            endDate: null,
            selectionState: "start",
            showBoardModal: false,
            boardUrl: ctx + "/modalBoardList.do",
            mapInstance: null,
            geocoder: null,
            markers: [],
            fullPoiList: [],
            activeTab: 12,
            infowindow: null,
            baseMarkerImageSrc: null,
            itinerary: {}, //여행 일정 담음
            activeDate: null,
            selectedPoi: null,
            activeRegion: "all",
            draggedDate: null,
            draggedIndex: null,
            dragOverDate: null,
            dragOverIndex: null,

            //활용하기
            resNum: "<%= resNum %>",
            list: {},
            detail: {},
            positionsByDay: {},
            selectedDay: 1,
            themes: "",
            sessionId: "<%= userId %>",
          };
        },

        computed: {
          isFormValid() {
            return this.selectedThemes.length > 0 && this.headCount > 0 && this.budget >= 0;
          },
          displayRegion() {
            if (!this.currentSido) return "미선택";
            const s = this.sidoList.find((x) => x.code === this.currentSido)?.name || "";
            const g = this.sigunguList.find((x) => x.code === this.currentSigungu)?.name || "";
            return s + (g ? " " + g : " (전체)");
          },
          regionFilteredList() {
            let list = this.fullPoiList;
            if (this.activeRegion === "all") {
              return list;
            }
            const selected = this.selectedRegions[this.activeRegion];
            if (!selected) {
              return [];
            }
            list = list.filter((poi) => {
              const poiArea = String(poi.areaCode);
              const poiSigungu = String(poi.sigunguCode);
              const selectedArea = String(selected.sidoCode);
              const selectedSigungu = String(selected.sigunguCode);
              if (selected.sigunguCode === null || selected.sigunguCode === "null") {
                return poiArea === selectedArea;
              }
              return poiArea === selectedArea && poiSigungu === selectedSigungu;
            });
            return list;
          },
          filteredPoiList() {
            return this.regionFilteredList.filter((poi) => poi.typeId === this.activeTab);
          },
          dateTabs() {
            if (!this.startDate || !this.endDate) return [];
            let tabs = [];
            let currentDate = new Date(this.startDate);
            let stopDate = new Date(this.endDate);
            let dayCount = 1;
            while (currentDate <= stopDate) {
              const dateStr = currentDate.toISOString().split("T")[0];
              const month = currentDate.getMonth() + 1;
              const day = currentDate.getDate();
              tabs.push({
                date: dateStr,
                label: `${month}월 ${day}일 (${dayCount}일차)`,
              });
              currentDate.setDate(currentDate.getDate() + 1);
              dayCount++;
            }

            return tabs;
          },
          activeDateLabel() {
            if (!this.activeDate || !this.dateTabs.length) return "";
            const activeTab = this.dateTabs.find((d) => d.date === this.activeDate);
            return activeTab ? activeTab.label : "";
          },
          activeItinerary() {
            return this.itinerary[this.activeDate] || [];
          },
          accomBudgetLimit() {
            return Math.floor((this.budget || 0) * (this.weights[1] / 100.0));
          },
          foodBudgetLimit() {
            return Math.floor((this.budget || 0) * (this.weights[2] / 100.0));
          },
          activityBudgetLimit() {
            return Math.floor((this.budget || 0) * (this.weights[3] / 100.0));
          },
        },

        watch: {
          filteredPoiList: function (newList, oldList) {
            this.drawMarkers();
          },
          dateTabs: function (newTabs, oldTabs) {
            if (newTabs.length > 0 && newTabs.length !== oldTabs.length) {
              this.activeDate = newTabs[0].date;
              this.itinerary = {};
              this.selectedPoi = null;
            } else if (newTabs.length === 0 && oldTabs.length > 0) {
              this.activeDate = null;
              this.itinerary = {};
              this.selectedPoi = null;
            }
          },
        },

        methods: {
          // ******* 모든 메소드는 정규 함수로 복구됩니다 *******

          async loadSido() {
            const self = this; // Vue 인스턴스 바인딩
            self.loadingSido = true;
            self.sidoList = [];
            try {
              const data = await $.get(ctx + "/api/areas/sido");
              self.sidoList = Array.isArray(data) ? data : [];
            } catch (e) {
              //console.error("시/도 조회 실패", e);
            } finally {
              self.loadingSido = false;
            }
          },

          async loadSigungu() {
            const self = this; // Vue 인스턴스 바인딩
            self.loadingSigungu = true;
            self.sigunguList = [];
            try {
              if (!self.currentSido) return;
              const data = await $.get(ctx + "/api/areas/sigungu", { areaCode: self.currentSido });
              self.sigunguList = Array.isArray(data) ? data : [];
            } catch (e) {
              //console.error("시/군/구 조회 실패", e);
            } finally {
              self.loadingSigungu = false;
            }
          },

          onChangeSido() {
            this.currentSigungu = "";
            this.sigunguList = [];
            this.loadSigungu();
          },

          toggleTheme(code) {
            const i = this.selectedThemes.indexOf(code);
            if (i === -1) this.selectedThemes.push(code);
            else this.selectedThemes.splice(i, 1);
          },

          labelOf(code) {
            return this.themeOptions.find((t) => t.code === code)?.label || code;
          },
          openBoardModal() {
            this.showBoardModal = true;
          },
          closeBoardModal() {
            this.showBoardModal = false;
          },

          addRegion() {
            if (!this.currentSido) return;
            const sidoName = this.sidoList.find((s) => s.code == this.currentSido)?.name || "";
            //console.log(typeof this.currentSido, this.currentSido);
            //console.log(this.sidoList.map((s) => s.code));

            const sigunguName = this.sigunguList.find((g) => g.code === this.currentSigungu)?.name || "";
            const regionName = sidoName + (sigunguName ? " " + sigunguName : " (전체)");
            const sigunguCodeVal = this.currentSigungu || null;
            const isDuplicate = this.selectedRegions.some((r) => r.sidoCode === this.currentSido && r.sigunguCode === sigunguCodeVal);

            if (!isDuplicate) {
              this.selectedRegions.push({
                sidoCode: this.currentSido,
                sigunguCode: sigunguCodeVal,
                name: regionName,
              });
            } else {
              alert("이미 추가된 지역입니다.");
            }

            this.currentSido = "";
            this.currentSigungu = "";
            this.sigunguList = [];
          },

          removeRegion(index) {
            this.selectedRegions.splice(index, 1);
            if (this.activeRegion == index) {
              this.activeRegion = "all";
            }
          },

          onRegionChange() {
            this.selectedPoi = null;
            if (this.infowindow) {
              this.infowindow.close();
            }
            if (this.activeRegion === "all") {
              if (this.fullPoiList.length > 0) {
                this.panToFirstPoi(this.fullPoiList);
              }
            } else {
              const region = this.selectedRegions[this.activeRegion];
              if (region && this.geocoder && this.mapInstance) {
                const address = region.name;
                this.geocoder.addressSearch(address, (result, status) => {
                  if (status === kakao.maps.services.Status.OK) {
                    const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    this.mapInstance.panTo(coords);
                    const level = region.sigunguCode ? 7 : 9;
                    this.mapInstance.setLevel(level);
                  }
                });
              }
            }
          },

          setActiveTab(typeId) {
            this.activeTab = typeId;
            this.selectedPoi = null;
            if (this.infowindow) {
              this.infowindow.close();
            }
          },

          countForTab(typeId) {
            return this.regionFilteredList.filter((p) => p.typeId === typeId).length;
          },

          // fnCreate: POI 목록 생성 (this 바인딩 문제 해결을 위해 const self=this 사용)
          async fnCreate() {
            const self = this; // Vue 인스턴스 바인딩

            if (self.selectedRegions.length === 0) {
              if (self.currentSido) {
                alert("지역을 선택한 후 '+' 버튼을 눌러 목록에 추가해주세요.");
              } else {
                alert("방문할 지역을 1개 이상 선택해주세요.");
              }
              return;
            }

            const el = document.getElementById("debugOut");
            const generateParam = {
              themes: self.selectedThemes,
              regions: self.selectedRegions,
              headCount: self.headCount,
              budget: self.budget,
              startDate: self.startDate,
              endDate: self.endDate,
              budgetWeights: {
                etc: self.weights[0],
                accom: self.weights[1],
                food: self.weights[2],
                act: self.weights[3],
              },
            };

            if (el) el.textContent = "===== POI 조회 중... =====";
            //console.log('POI 생성 요청 파라미터:', generateParam);
            self.fullPoiList = [];
            self.clearMarkers(); // self 사용
            self.activeRegion = "all";

            try {
              const response = await $.ajax({
                url: ctx + "/api/recommend/generate",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(generateParam),
              });
              self.fullPoiList = response;
              //console.log('백엔드 응답 (POI 목록):', response);
              if (el) el.textContent = "POI 로드 완료. (총 " + response.length + "개)";

              if (response.length > 0) {
                self.panToFirstPoi(response); // self 사용
              }
            } catch (e) {
              //console.error("코스 생성 실패", e);
              if (el) el.textContent = "API 호출 실패: " + (e.responseJSON?.message || e.responseText || e.statusText);
              return;
            }
          },

          // fnSaveTrip: 최종 일정 저장 및 페이지 이동
          async fnSaveTrip() {
            const self = this; // Vue 인스턴스 바인딩

            const totalItems = Object.values(self.itinerary).flat().length;
            if (totalItems === 0) {
              alert("일정에 추가된 항목이 없습니다. 코스를 먼저 지도에서 선택해주세요.");
              return;
            }

            if (self.selectedRegions.length === 0 || !self.startDate || !self.endDate || self.headCount <= 0) {
              alert("여행 정보 (지역, 일정, 인원)를 먼저 입력해주세요.");
              return;
            }

            if (!confirm("현재 작성된 일정으로 최종 코스를 확정하고 예약 내역을 보시겠습니까?")) {
              return;
            }

            // ReservationRequest 포맷에 맞춰 데이터 준비 (생략)
            const saveParam = {
              themes: self.selectedThemes,
              regions: self.selectedRegions,
              headCount: self.headCount,
              budget: self.budget,
              startDate: self.startDate,
              endDate: self.endDate,
              budgetWeights: {
                etc: self.weights[0],
                accom: self.weights[1],
                food: self.weights[2],
                act: self.weights[3],
              },
              itinerary: self.itinerary,
            };

            try {
              const saveResponse = await $.ajax({
                url: ctx + "/api/reservation/save", // ResController의 저장 API 호출
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(saveParam),
              });

              //"resNum"으로 반환하므로 키를 resNum으로 변경합니다.
              const resNum = saveResponse.resNum;

              if (resNum) {
                alert("코스가 성공적으로 저장되었습니다. 예약 내역 페이지로 이동합니다.");
                // URL 파라미터도 resNum으로 변경하거나, 기존 tripId를 사용하되 resNum 값을 전달합니다.
                // 여기서는 기존 URL 구조를 유지하고 resNum 값을 tripId로 전달합니다.
                window.location.href = ctx + "/reservation-view.do?resNum=" + resNum;
              } else {
                alert("코스 저장에 실패했습니다. (여행 ID 누락 - 서버 응답 확인 필요)");
              }
            } catch (e) {
              //console.error("최종 일정 저장 실패", e);
              alert("최종 일정 저장 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            }
          },

          // 지도 관련 함수
          initMap() {
            if (!window.kakao || !window.kakao.maps) {
              // console.error("카카오맵 SDK가 로드되지 않았습니다.");
              const mapEl = document.getElementById("map-recommend");
              if (mapEl)
                mapEl.innerHTML = "<h4 style='text-align:center; padding-top: 20px;'>카카오맵 SDK 로딩 실패. API 키(appkey)를 확인하세요.</h4>";
              return;
            }
            const mapContainer = document.getElementById("map-recommend");
            if (!mapContainer) {
              // console.error("#map-recommend 요소를 찾을 수 없습니다.");
              return;
            }
            const mapOption = {
              center: new kakao.maps.LatLng(36.2, 127.6),
              level: 12,
            };
            this.mapInstance = new kakao.maps.Map(mapContainer, mapOption);
            this.geocoder = new kakao.maps.services.Geocoder();
            this.infowindow = new kakao.maps.InfoWindow({
              content: "",
              removable: true,
            });

            const cacheBuster = "?v=" + new Date().getTime();
            this.baseMarkerImageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png" + cacheBuster;
          },

          clearMarkers() {
            if (this.infowindow) {
              this.infowindow.close();
            }
            for (let marker of this.markers) {
              marker.setMap(null);
            }
            this.markers = [];
            this.selectedPoi = null;
          },

          drawMarkers() {
            if (!this.mapInstance) return;
            this.clearMarkers();

            const listToDraw = [...this.filteredPoiList].sort((a, b) => {
              const scoreA = a.score || 0;
              const scoreB = b.score || 0;
              return scoreB - scoreA;
            });

            if (listToDraw.length === 0) return;

            const totalCount = listToDraw.length;
            const top10Cutoff = Math.floor(totalCount * 0.1);
            const top30Cutoff = Math.floor(totalCount * 0.3);
            const top50Cutoff = Math.floor(totalCount * 0.5);

            for (const [index, poi] of listToDraw.entries()) {
              const mapy_num = parseFloat(poi.mapy);
              const mapx_num = parseFloat(poi.mapx);
              if (isNaN(mapy_num) || isNaN(mapx_num)) {
                // console.warn("좌표값이 잘못된 POI가 있어 건너뜁니다:", poi);
                continue;
              }

              let imgSize;
              if (index < top10Cutoff) {
                imgSize = 45;
              } else if (index < top30Cutoff) {
                imgSize = 30;
              } else if (index < top50Cutoff) {
                imgSize = 20;
              } else {
                imgSize = 10;
              }

              const markerImage = new kakao.maps.MarkerImage(this.baseMarkerImageSrc, new kakao.maps.Size(imgSize, imgSize), {
                offset: new kakao.maps.Point(imgSize / 2, imgSize / 2),
              });

              const marker = new kakao.maps.Marker({
                map: this.mapInstance,
                position: new kakao.maps.LatLng(mapy_num, mapx_num),
                title: poi.title + " (점수: " + (poi.score || 0).toFixed(2) + ")",
                image: markerImage,
              });

              kakao.maps.event.addListener(marker, "click", () => {
                this.selectedPoi = poi;
                if (poi.price === undefined) {
                  this.fetchPoiPrice(poi);
                } else {
                  this.updateInfowindowContent(poi, poi.price);
                }
              });

              this.markers.push(marker);
            }
          },

          async fetchPoiPrice(poi) {
            this.updateInfowindowContent(poi, null);
            try {
              const response = await $.get(ctx + "/api/recommend/getPrice", {
                contentId: poi.contentId,
                typeId: poi.typeId,
                startDate: this.startDate,
              });
              poi.price = response.price;
              if (this.selectedPoi && this.selectedPoi.contentId === poi.contentId) {
                this.selectedPoi.price = response.price;
              }
              this.updateInfowindowContent(poi, response.price);
            } catch (e) {
              // console.error("가격 조회 API 호출 실패", e);
              poi.price = 0;
              if (this.selectedPoi && this.selectedPoi.contentId === poi.contentId) {
                this.selectedPoi.price = 0;
              }
              this.updateInfowindowContent(poi, 0);
            }
          },

          updateInfowindowContent(poi, price) {
            const title = poi.title || "이름 없음";
            let imageUrl = poi.firstimage2 || poi.firstimage;
            let isValidImage = imageUrl && imageUrl !== "false" && imageUrl.trim() !== "";
            if (isValidImage && imageUrl.startsWith("http://")) imageUrl = imageUrl.replace("http://", "https://");

            const searchUrl = `https://search.naver.com/search.naver?query=${encodeURIComponent(title)}`;
            let priceText = "";

            if (price === null) {
              priceText = `<span style="font-size: 12px; color: #888;">(가격 조회 중...)</span>`;
            } else if (price > 0) {
              priceText = `<span style="font-size: 13px; color: #d9480f; font-weight: bold;">${price.toLocaleString()}원~</span>`;
            } else {
              priceText = `<span style="font-size: 12px; color: #888;">(가격 미제공/문의)</span>`;
            }

            if (poi.typeId === 12) priceText = "";

            const imageHtml = isValidImage
              ? `<img src="${imageUrl}" width="180" height="120" style="object-fit: cover; border: 1px solid #ccc; border-radius: 4px; max-width: 100%;">`
              : `<div style="width: 180px; height: 120px; background: #f0f0f0; border: 1px solid #ccc; border-radius: 4px; display: flex; align-items: center; justify-content: center; color: #888; font-size: 12px;">(이미지 없음)</div>`;

            const content = `
                  <div style="padding:7px; width: 200px; text-align: center; box-sizing: border-box;">
                    ${imageHtml}
                    <div style="font-weight: bold; margin-top: 5px; font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                        <a href="${searchUrl}" target="_blank" title="네이버 검색" style="color: inherit; text-decoration: none;">
                          ${title} <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 11px; color: #888;"></i>
                        </a>
                    </div>
                    <div style="margin-top: 4px;">${priceText}</div>
                  </div>
                `;

            this.infowindow.setContent(content);
            const position = new kakao.maps.LatLng(parseFloat(poi.mapy), parseFloat(poi.mapx));
            this.infowindow.open(this.mapInstance, new kakao.maps.Marker({ position: position }));
          },

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

          addPoiToItinerary() {
            if (!this.activeDate || !this.selectedPoi) return;
            // console.log("일정에 추가 시도:", this.selectedPoi);

            // 가격 체크 제거
            const poiPrice = this.selectedPoi.price || 0;
            const poiType = this.selectedPoi.typeId;

            // 예산 체크 제거 (임시)
            if (!this.itinerary[this.activeDate]) {
              this.itinerary[this.activeDate] = [];
            }
            this.itinerary[this.activeDate].push({ ...this.selectedPoi, price: poiPrice });
            //console.log("일정에 추가됨:", this.itinerary[this.activeDate]);
            // console.log("일정에 추가됨:", this.activeDate, this.itinerary);

            this.selectedPoi = null;
            if (this.infowindow) this.infowindow.close();
          },

          removePoiFromItinerary(date, index) {
            if (this.itinerary[date] && this.itinerary[date].length > index) {
              const removedPoi = this.itinerary[date].splice(index, 1)[0];
              const poiPrice = removedPoi.price || 0;
              if (poiPrice > 0) {
                if (removedPoi.typeId === 32) this.spentAccom -= poiPrice;
                else if (removedPoi.typeId === 39) this.spentFood -= poiPrice;
                else if (removedPoi.typeId === 12) this.spentActivity -= poiPrice;
              }
            }
          },

          onDragStart(date, index) {
            this.draggedDate = date;
            this.draggedIndex = index;
            this.selectedPoi = null;
            if (this.infowindow) {
              this.infowindow.close();
            }
          },
          onDragOver(date, index) {
            if (date !== this.draggedDate) {
              this.dragOverDate = null;
              this.dragOverIndex = null;
              return;
            }
            if (index !== this.draggedIndex && index !== this.dragOverIndex) {
              this.dragOverDate = date;
              this.dragOverIndex = index;
            }
          },
          onDragLeave() {
            this.dragOverDate = null;
            this.dragOverIndex = null;
          },
          onDrop(date, droppedIndex) {
            if (date !== this.draggedDate || this.draggedIndex === null || this.draggedIndex === droppedIndex) {
              this.onDragEnd();
              return;
            }
            const list = this.itinerary[date];
            const draggedItem = list.splice(this.draggedIndex, 1)[0];
            list.splice(droppedIndex, 0, draggedItem);
            this.onDragEnd();
          },
          onDragEnd() {
            this.draggedDate = null;
            this.draggedIndex = null;
            this.dragOverDate = null;
            this.dragOverIndex = null;
          },

          isDragging(date, index) {
            return this.draggedDate === date && this.draggedIndex === index;
          },
          isDragOver(date, index) {
            return this.dragOverDate === date && this.dragOverIndex === index;
          },
          //활용하기
          fninfo() {
            let self = this;
            $.ajax({
              url: "/active.dox",
              type: "GET",
              data: { resNum: self.resNum },
              success(data) {
                //console.log("서버 데이터:", data);

                // 기본 정보 세팅
                self.list = data.list[0];
                self.detail = data.detail;

                self.themes = data.list[0].themnum || "";
                self.selectedThemes = self.themes.split(/[,/]/);
                self.currentSido = data.list[0].areaNum;
                self.onChangeSido();
                self.startDate = data.list[0].sdate;
                self.endDate = data.list[0].edate;
                self.budget = data.list[0].price;

                // itinerary 초기화
                self.itinerary = {};
                self.spentAccom = 0;
                self.spentFood = 0;
                self.spentActivity = 0;

                // 서버에서 불러온 POI를 일정에 추가
                self.$nextTick(() => {
                  for (let dayKey in self.detail) {
                    self.detail[dayKey].forEach((item) => {
                      // selectedPoi 세팅
                      self.selectedPoi = {
                        title: item.title,
                        mapy: parseFloat(item.mapy),
                        mapx: parseFloat(item.mapx),
                        dayNum: item.dayNum,
                        reserv_date: item.reserv_date,
                        addr1: item.addr1,
                        contentId: item.contentid,
                        day: item.day, // 여기 중요!
                        overview: item.overview,
                        firstimage: item.firstimage || null,
                        price: item.price || 0,
                        typeId: item.typeId || 12,
                      };

                      // activeDate를 POI의 day로 세팅
                      self.activeDate = item.day;

                      // 일정에 추가
                      self.addPoiToItinerary();
                    });
                  }

                  // fullPoiList를 itinerary 전체로 설정 (모든 날 POI 포함)
                  self.fullPoiList = Object.values(self.itinerary).flat();

                  // 첫날 선택
                  if (self.dateTabs && self.dateTabs.length > 0) {
                    self.selectedDay = self.dateTabs[0].date;
                  }

                  // console.log("Selected Day:", self.selectedDay);
                  // console.log("Itinerary:", self.itinerary);
                  // console.log("Full POI List:", self.fullPoiList);

                  // 지도에 모든 날 POI 표시
                  self.drawMarkers();
                });
              },
              error(err) {
                // console.error("데이터 로드 실패:", err);
              },
            });
          },
        },

        async mounted() {
          let self = this;
          if (self.sessionId == "" || self.sessionId == "null") {
            alert("로그인 후 이용해주세요.");
            location.href = "/member/login.do";
            return;
          }

          // alert(window.sessionData.id);
          await this.loadSido();
          this.initMap();
          if (self.resNum && self.resNum !== "null" && self.resNum !== "") {
            self.fninfo();
          }
        },
      });

      // 믹스인 주입
      app.mixin(window.ReservationPieMixin);
      app.mixin(window.ReservationCalendarMixin);

      app.mount("#app"); // Vue 앱 시작
    </script>
  </body>
</html>
