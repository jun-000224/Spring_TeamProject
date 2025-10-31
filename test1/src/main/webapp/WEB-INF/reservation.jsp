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

    <script>const ctx = '${pageContext.request.contextPath}';</script>

    <!-- 분리된 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservation.css" />
    <style>
    </style>
  </head>

  <body>
    <div id="app" class="wrap">
      <h1 class="page-title">예약하기</h1>

      <div class="grid two-col">
        <!-- Left: Theme & Region -->
        <section class="panel">
          <h3>테마 선택 <span class="desc">복수 선택 가능</span></h3>
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

          <!-- 지역 API는 보류하지만 UI는 유지 (값은 전송 시 null로 처리) -->
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
        </section>

        <!-- Right: People & Budget -->
        <section class="panel">
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

          <div class="actions">
            <!-- 지역 미선택이어도 테스트 가능하도록 유효성에서 제외 -->
            <button class="btn-primary" @click="fnCreate">코스 생성하기</button>
            <!-- 다 고쳐지면 버튼에다가 다시 :disabled="!isFormValid" 추가 -->
          </div>
        </section>
      </div>

      <!-- Budget Pie -->
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

          <!-- Legend with Lock -->
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

      <!-- 테스트 출력 영역 -->
      <section class="panel" style="margin-top:10px">
        <h3>넘어가는 파라미터 체크용 콘솔</h3>
        <div id="debugOut"></div>
      </section>

      <!-- 플로팅 버튼 + 모달 마크업 추가 -->
      <button class="fab" @click="openBoardModal" aria-label="커뮤니티 열기" title="커뮤니티">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
          stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
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

    <!-- 파이 모듈(믹스인) 임포트: 잠금 로직 포함 버전 -->
    <script src="${pageContext.request.contextPath}/js/reservation-pie.js"></script>

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

            // Region (API 보류)
            sidoList: [],
            sigunguList: [],
            selectedSido: '',
            selectedSigungu: '',
            loadingSido: false,
            loadingSigungu: false,

            // Budget (값만, 나머지는 mixin이 관리)
            budget: null,
            headCount: null,

            // 커뮤니티 연결 모달/ 일단 연결 URL은 임시로, 추후에는 QNA로 할듯?
            showBoardModal: false,
            boardUrl: ctx + '/board-view.do'
          }
        },
        computed: {
          // 지역은 테스트 단계에서는 유효성에서 제외
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
          // (지역 API 자리만 유지)
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

          // 코스 생성하기, 지역은 현재 api이슈로 패스하고 나머지는 키벨류 형태로 출력
          fnCreate() {
            const param = {
              themes: this.selectedThemes,
              areaCode: this.selectedSido || null,
              sigunguCode: this.selectedSigungu || null,
              headCount: this.headCount,
              budget: this.budget,
              budgetWeights: {
                etc: this.weights[0],
                accom: this.weights[1],
                food: this.weights[2],
                act: this.weights[3]
              }
            };

            const lines = [
              ['themes', (param.themes && param.themes.length) ? param.themes.join(', ') : '(없음)'],
              ['areaCode', String(param.areaCode)],
              ['sigunguCode', String(param.sigunguCode)],
              ['headCount', String(param.headCount ?? '')],
              ['budget', ((param.budget ?? 0).toLocaleString()) + '원'],
              ['etcAmount', (this.amountFor(0)).toLocaleString() + '원'],
              ['accomAmount', (this.amountFor(1)).toLocaleString() + '원'],
              ['foodAmount', (this.amountFor(2)).toLocaleString() + '원'],
              ['actAmount', (this.amountFor(3)).toLocaleString() + '원']
            ];

            const el = document.getElementById('debugOut');
            if (el) {
              el.textContent = lines.map(function (p) { return p[0] + ' : ' + p[1]; }).join('\n');
            }

            console.log('전송 파라미터(테스트):', param);
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
          await this.loadSido(); // 현재는 비어있음
          // 캔버스/리사이즈는 mixin에서 처리됨
        }
      });

      // 파이 차트 믹스인 주입
      app.mixin(window.ReservationPieMixin);
      app.mount('#app');
    </script>
  </body>

  </html>
