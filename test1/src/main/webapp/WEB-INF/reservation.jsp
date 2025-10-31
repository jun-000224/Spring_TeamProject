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
    <script>const ctx = '${pageContext.request.contextPath}';</script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservation.css" />
    <style>
    </style>
  </head>

  <body>
    <div id="app" class="wrap">
      <h1 class="page-title">예약하기</h1>

      <div class="grid two-col">
        <section class="panel">
          <h3>테마 선택 <span class="desc">복수 선택 가능</span>
          </h3>
          <div class="desc">선택된 테마는 아래에 간단히 표시됩니다.</div>

          <div class="theme-grid">
            <button v-for="item in themeOptions" :key="item.code" type="button"
              :class="['theme-btn', { active: selectedThemes.includes(item.code) }]" @click="toggleTheme(item.code)">
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
            입력값: 인원 <strong>{{ headCount || 0 }}</strong>명 / 예산 <strong>{{ (budget ?? 0).toLocaleString() }}</strong>원
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
                <input type="range" min="5" max="90" :value="weights[idx]" @input="onSlider(idx, $event.target.value)"
                  :disabled="locks[idx]">
              </div>
            </div>
            <div class="inline" style="margin-top:4px">
              합계: <strong>{{ weights.reduce((a,b)=>a+Number(b),0) }}</strong>%
            </div>
          </div>
        </div>
      </section>

      <section class="panel" style="margin-top:10px">
        <h3>넘어가는 파라미터 체크용 콘솔</h3>
        <div id="debugOut"></div>
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

    <script src="${pageContext.request.contextPath}/js/reservation-pie.js"></script>

    <script src="${pageContext.request.contextPath}/js/reservation-calendar.js"></script>

    <script>
      const app = Vue.createApp({
        data() {
          return {
            // Theme
            themeOptions: [
              { code: 'FAMILY', label: '가족' },
              { code: 'FRIEND', label: '친구' },
              { code: 'COUPLE', label: '연인' },
              { code: 'LUXURY', label: '호화스러운' },
              { code: 'BUDGET', label: '가성비' },
              { code: 'HEALING', label: '힐링' },
              { code: 'UNIQUE', label: '이색적인' },
              { code: 'ADVENTURE', label: '모험' },
              { code: 'QUIET', label: '조용한' }
            ],
            selectedThemes: [],

            // Region
            sidoList: [],
            sigunguList: [],
            selectedSido: '',
            selectedSigungu: '',
            loadingSido: false,
            loadingSigungu: false,

            // Budget
            budget: null,
            headCount: null,

            // [ ⭐ 2. ] 달력 선택 값
            startDate: null,
            endDate: null,
            selectionState: 'start', // 'start' 또는 'end' (mixin이 사용)

            // 커뮤니티 연결 모달
            showBoardModal: false,
            boardUrl: ctx + '/board-view.do'
          }
        },
        computed: {
          isFormValid() {
            return this.selectedThemes.length > 0
              && this.headCount > 0
              && this.budget >= 0;
          },
          displayRegion() {
            if (!this.selectedSido) return '미선택';
            const s = this.sidoList.find(x => x.code === this.selectedSido)?.name || '';
            const g = this.sigunguList.find(x => x.code === this.selectedSigungu)?.name || '';
            return s + (g ? ' ' + g : ' (전체)');
          }
        },
        methods: {
          // (지역 API)
          async loadSido() {
            const self = this;
            self.loadingSido = true;
            self.sidoList = [];
            try {
              const data = await $.get(ctx + '/api/areas/sido');
              self.sidoList = Array.isArray(data) ? data : [];
            } catch (e) {
              console.error('시/도 조회 실패', e);
              alert('시/도 목록을 불러오지 못했습니다.');
            } finally {
              self.loadingSido = false;
            }
          },
          async loadSigungu() {
            const self = this;
            self.loadingSigungu = true;
            self.sigunguList = [];
            try {
              if (!self.selectedSido) return;
              const data = await $.get(ctx + '/api/areas/sigungu', { areaCode: self.selectedSido });
              self.sigunguList = Array.isArray(data) ? data : [];
            } catch (e) {
              console.error('시/군/구 조회 실패', e);
              alert('시/군/구 목록을 불러오지 못했습니다.');
            } finally {
              self.loadingSigungu = false;
            }
          },
          onChangeSido() { this.selectedSigungu = ''; this.sigunguList = []; this.loadSigungu(); },

          toggleTheme(code) {
            const i = this.selectedThemes.indexOf(code);
            if (i === -1) this.selectedThemes.push(code);
            else this.selectedThemes.splice(i, 1);
          },
          labelOf(code) { return this.themeOptions.find(t => t.code === code)?.label || code; },


          // [ ⭐ 3. ] 코스 생성하기 (파라미터 + POI 결과 함께 출력)
          async fnCreate() {
            const self = this;
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
                etc: this.weights[0],
                accom: this.weights[1],
                food: this.weights[2],
                act: this.weights[3]
              }
            };

            // 파라미터 목록 생성
            const lines = [
              ['themes', (param.themes && param.themes.length) ? param.themes.join(', ') : '(없음)'],
              ['areaCode', String(param.areaCode)],
              ['sigunguCode', String(param.sigunguCode)],
              ['headCount', String(param.headCount ?? '')],
              ['budget', ((param.budget ?? 0).toLocaleString()) + '원'],
              ['--- (날짜) ---', ''],
              ['startDate', String(param.startDate || '미선택')],
              ['endDate', String(param.endDate || '미선택')],
              ['--- (항목별 예산) ---', ''],
              ['etcAmount', (this.amountFor(0)).toLocaleString() + '원 (' + param.budgetWeights.etc + '%)'],
              ['accomAmount', (this.amountFor(1)).toLocaleString() + '원 (' + param.budgetWeights.accom + '%)'],
              ['foodAmount', (this.amountFor(2)).toLocaleString() + '원 (' + param.budgetWeights.food + '%)'],
              ['actAmount', (this.amountFor(3)).toLocaleString() + '원 (' + param.budgetWeights.act + '%)']
            ];

            // 파라미터 목록을 debugOut에 먼저 출력
            if (el) {
              el.textContent = '===== 전송 파라미터 =====\n';
              el.textContent += lines.map(function (p) { return p[0] + ' : ' + p[1]; }).join('\n');
              el.textContent += '\n\n===== POI 조회 중... (API 호출) =====';
            }
            console.log('전송 파라미터:', param);

            // API 호출
            try {
              const response = await $.ajax({
                url: ctx + '/api/recommend/generate',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(param)
              });

              // 성공 시, POI 결과를 기존 내용에 *추가*
              console.log('백엔드 응답:', response);
              if (el) {
                el.textContent = el.textContent.replace(
                  '===== POI 조회 중... (API 호출) =====',
                  '===== 생성/조회된 POI 및 속성값 (ATTR 테이블) ====='
                );
                el.textContent += '\n' + JSON.stringify(response, null, 2);
              }

            } catch (e) {
              // 실패 시, 오류 메시지를 *추가*
              console.error('코스 생성 실패', e);
              if (el) {
                el.textContent = el.textContent.replace(
                  '===== POI 조회 중... (API 호출) =====',
                  '===== API 호출 실패 ====='
                );
                el.textContent += '\n오류: ' + (e.responseJSON?.message || e.responseText || e.statusText);
              }
            }
          },

          // 모달 열기/닫기
          openBoardModal() {
            this.showBoardModal = true;
            document.documentElement.style.overflow = 'hidden';
            document.body.style.overflow = 'hidden';
          },
          closeBoardModal() {
            this.showBoardModal = false;
            document.documentElement.style.overflow = '';
            document.body.style.overflow = '';
          }
        },
        async mounted() {
          await this.loadSido();
          // 캔버스/리사이즈는 mixin에서 처리됨
        }
      });

      // 파이 차트 믹스인 주입
      app.mixin(window.ReservationPieMixin);

      // [ ⭐ 4. ] 달력 믹스인 주입
      app.mixin(window.ReservationCalendarMixin);

      app.mount('#app');
    </script>
  </body>

  </html>