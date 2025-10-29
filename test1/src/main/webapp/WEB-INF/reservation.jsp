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
  <script>const ctx='${pageContext.request.contextPath}';</script>

  <!-- ===== Neutral, service-like CSS (no vivid colors) ===== -->
  <style>
    :root{
      /* 중성 그레이 팔레트 */
      --bg:#f6f7f8;
      --text:#1d232a;
      --muted:#6b7280;
      --card:#ffffff;
      --border:#e5e7eb;
      --border-strong:#d1d5db;
      --focus:#cbd5e1;
      --radius:14px;
      --shadow:0 6px 16px rgba(0,0,0,.06);
      --shadow-sm:0 3px 8px rgba(0,0,0,.05);
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0; background:var(--bg); color:var(--text);
      font:15px/1.5 system-ui, -apple-system, Segoe UI, Roboto, Apple SD Gothic Neo, Malgun Gothic, Arial, sans-serif;
    }
    .wrap{max-width:980px; margin:40px auto; padding:0 20px}
    .page-title{margin:0 0 18px; font-size:28px; font-weight:800; letter-spacing:-.2px}

    .grid{display:grid; gap:16px}
    .two-col{grid-template-columns:1.15fr .85fr}
    @media (max-width:900px){ .two-col{grid-template-columns:1fr} }

    .panel{
      background:var(--card); border:1px solid var(--border);
      border-radius:var(--radius); padding:18px; box-shadow:var(--shadow);
    }
    .panel h3{margin:0 0 10px; font-size:17px; font-weight:700}
    .desc{color:var(--muted); font-size:13px; margin-bottom:12px}

    /* Theme 3×3 grid */
    .theme-grid{
      display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:10px;
    }
    .theme-btn{
      width:100%; padding:12px 10px; border-radius:12px;
      border:1px solid var(--border); background:#fafafa;
      color:var(--text); font-weight:700; letter-spacing:-.2px;
      box-shadow:var(--shadow-sm);
      transition:background .12s ease, border-color .12s ease, transform .06s ease;
      cursor:pointer; user-select:none;
    }
    .theme-btn:hover{ background:#f0f2f4 }
    .theme-btn:active{ transform:translateY(1px) }

    /* selected: 과하지 않게 눌린 느낌 */
    .theme-btn.active{
      background:#eceff2; border-color:var(--border-strong);
    }

    /* chips */
    .chips{display:flex; flex-wrap:wrap; gap:8px; margin-top:10px}
    .chip{
      padding:6px 10px; font-size:12px; border-radius:999px;
      background:#f2f3f5; border:1px solid var(--border); color:#374151;
    }

    /* form */
    label{display:block; font-size:13px; color:#4b5563; margin-bottom:6px}
    .field{margin-bottom:12px}
    select, input[type="number"]{
      width:100%; padding:10px 12px; border-radius:10px;
      background:#fff; color:var(--text);
      border:1px solid var(--border); outline:none;
      transition:border-color .12s ease, box-shadow .12s ease, background .12s;
    }
    select:focus, input[type="number"]:focus{
      border-color:var(--border-strong); box-shadow:0 0 0 3px var(--focus);
      background:#fff;
    }

    .inline{color:#374151; font-size:14px}
    .inline strong{color:#111827}

    .actions{display:flex; justify-content:flex-end; margin-top:10px}
    .btn-primary{
      padding:10px 16px; border-radius:10px; border:1px solid var(--border-strong);
      background:#f1f5f9; color:#111827; font-weight:800; letter-spacing:.2px;
      transition:background .12s ease, transform .06s ease, box-shadow .12s ease;
      cursor:pointer;
    }
    .btn-primary:hover{ background:#e9edf2 }
    .btn-primary:active{ transform:translateY(1px) }
    .btn-primary:disabled{
      background:#f3f4f6; color:#9ca3af; border-color:var(--border);
      cursor:not-allowed; box-shadow:none;
    }
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

      <!-- 3×3 Theme Grid -->
      <div class="theme-grid">
        <button v-for="item in themeOptions" :key="item.code" type="button"
                :class="['theme-btn', { active: selectedThemes.includes(item.code) }]"
                @click="toggleTheme(item.code)">
          {{ item.label }}
        </button>
      </div>

      <!-- Selected chips -->
      <div class="chips" v-if="selectedThemes.length">
        <span class="chip" v-for="t in selectedThemes" :key="t">{{ labelOf(t) }}</span>
      </div>
      <div class="desc" v-else>선택: 없음</div>

      <h3 style="margin-top:14px">지역 선택</h3>
      <div class="grid" style="grid-template-columns:1fr 1fr; gap:10px">
        <div class="field">
          <label>시/도</label>
          <select v-model="selectedSido" @change="onChangeSido">
            <option value="">선택</option>
            <option v-for="s in sidoList" :key="s.code" :value="s.code">{{ s.name }}</option>
          </select>
        </div>
        <div class="field">
          <label>시/군/구</label>
          <select v-model="selectedSigungu" :disabled="!sigunguList.length">
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
        <input type="number" min="0" step="1000" v-model.number="budget" placeholder="예산을 입력하세요." />
      </div>

      <div class="inline" style="margin-top:2px">
        입력값: 인원 <strong>{{ headCount || 0 }}</strong>명 / 예산 <strong>{{ (budget ?? 0).toLocaleString() }}</strong>원
      </div>

      <div class="actions">
        <button class="btn-primary" :disabled="!isFormValid" @click="fnCreate">코스 생성하기</button>
      </div>
    </section>
  </div>
</div>

<script>
const app = Vue.createApp({
  data(){
    return {
      // 3×3 테마
      themeOptions: [
        { code: 'FAMILY',    label: '가족' },
        { code: 'FRIEND',    label: '친구' },
        { code: 'COUPLE',    label: '연인' },
        { code: 'LUXURY',    label: '호화스러운' },
        { code: 'BUDGET',    label: '가성비' },
        { code: 'HEALING',   label: '힐링' },
        { code: 'UNIQUE',    label: '이색적인' },
        { code: 'ADVENTURE', label: '모험' },
        { code: 'QUIET',     label: '조용한' }
      ],
      selectedThemes: [],

      // 임시 지역 더미 (API 붙이면 교체)
      sidoList: [
        { code: '11', name: '서울' },
        { code: '26', name: '부산' },
        { code: '41', name: '경기' }
      ],
      sigunguList: [],
      selectedSido: '',
      selectedSigungu: '',

      headCount: null,
      budget: null
    }
  },
  computed:{
    isFormValid(){
      return this.selectedThemes.length > 0
        && this.selectedSido !== ''
        && this.headCount > 0
        && this.budget >= 0;
    },
    displayRegion(){
      if(!this.selectedSido) return '미선택';
      const s = this.sidoList.find(x => x.code === this.selectedSido)?.name || '';
      const g = this.sigunguList.find(x => x.code === this.selectedSigungu)?.name || '';
      return s + (g ? ' ' + g : ' (전체)');
    }
  },
  methods:{
    labelOf(code){ return this.themeOptions.find(t => t.code === code)?.label || code; },
    toggleTheme(code){
      const i = this.selectedThemes.indexOf(code);
      if(i >= 0) this.selectedThemes.splice(i,1);
      else this.selectedThemes.push(code);
    },
    onChangeSido(){
      this.selectedSigungu = ''; this.sigunguList = [];
      if(!this.selectedSido) return;
      const map = {
        '11': [{code:'11110',name:'종로구'},{code:'11140',name:'중구'},{code:'11200',name:'도봉구'}],
        '26': [{code:'26110',name:'중구'},{code:'26290',name:'해운대구'}],
        '41': [{code:'41110',name:'수원시'},{code:'41130',name:'성남시'}]
      };
      this.sigunguList = map[this.selectedSido] || [];
    },
    fnCreate(){
      const param = {
        themes: this.selectedThemes,
        areaCode: this.selectedSido,
        sigunguCode: this.selectedSigungu,
        headCount: this.headCount,
        budget: this.budget
      };
      console.log('전송 파라미터(미전송):', param);
      alert('콘솔을 확인하세요.');
    }
  }
});
app.mount('#app');
</script>
</body>
</html>
