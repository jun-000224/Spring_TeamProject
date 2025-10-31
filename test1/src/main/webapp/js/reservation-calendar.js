/**
 * reservation-calendar.js
 * 예약 페이지 달력 UI/UX를 위한 Vue Mixin
 */
window.ReservationCalendarMixin = {
  // 메인 Vue 앱의 data()와 병합됩니다.
  data() {
    return {
      currentMonthDate: new Date(), // 달력이 현재 표시중인 월
    };
  },

  // 메인 Vue 앱의 computed:와 병합됩니다.
  computed: {
    /** 현재 달력의 년도 (e.g., 2025) */
    currentYear() {
      return this.currentMonthDate.getFullYear();
    },
    /** 현재 달력의 월 (0=1월, 11=12월) */
    currentMonth() {
      return this.currentMonthDate.getMonth();
    },
    /** 현재 달력의 월 이름 (e.g., '10월') */
    monthName() {
      // 'ko-KR' 로케일을 사용해 월 이름 반환
      return this.currentMonthDate.toLocaleString('ko-KR', { month: 'long' });
    },

    /**
     * 달력 UI를 그리기 위한 6x7 (42칸) 배열을 생성합니다.
     * 각 요소: { date: 'YYYY-MM-DD', dayNum: '일', isCurrentMonth: true }
     */
    calendarGrid() {
      const grid = [];
      const year = this.currentYear;
      const month = this.currentMonth;

      // 1. 이번 달의 1일
      const firstDayOfMonth = new Date(year, month, 1);
      // 2. 이번 달의 마지막 날
      const lastDayOfMonth = new Date(year, month + 1, 0);

      // 3. 1일이 시작하는 요일 (0=일, 1=월, ... 6=토)
      const startDayOfWeek = firstDayOfMonth.getDay();
      // 4. 이번 달의 총 일수
      const daysInMonth = lastDayOfMonth.getDate();

      // 5. 지난 달의 마지막 날
      const lastDayOfPrevMonth = new Date(year, month, 0);
      const daysInPrevMonth = lastDayOfPrevMonth.getDate();
      
      // 6. 달력 앞부분의 빈 칸(지난 달 날짜) 채우기
      for (let i = startDayOfWeek - 1; i >= 0; i--) {
        const dayNum = daysInPrevMonth - i;
        const date = new Date(year, month - 1, dayNum);
        grid.push({
          date: this.formatDateISO(date), // 'YYYY-MM-DD'
          dayNum: dayNum,
          isCurrentMonth: false,
        });
      }

      // 7. 이번 달 날짜 채우기
      for (let i = 1; i <= daysInMonth; i++) {
        const date = new Date(year, month, i);
        grid.push({
          date: this.formatDateISO(date),
          dayNum: i,
          isCurrentMonth: true,
        });
      }

      // 8. 달력 뒷부분의 빈 칸(다음 달 날짜) 채우기
      const gridCount = grid.length;
      const nextMonthDayCount = 42 - gridCount; // 6*7=42
      for (let i = 1; i <= nextMonthDayCount; i++) {
        const date = new Date(year, month + 1, i);
        grid.push({
          date: this.formatDateISO(date),
          dayNum: i,
          isCurrentMonth: false,
        });
      }
      return grid;
    },
    
    /** 선택된 일정 표시용 (e.g., '10월 31일 ~ 11월 2일') */
    displayDateRange() {
        if (!this.startDate) return '날짜를 선택하세요.';
        let s = this.formatDateKorean(this.startDate);
        if (!this.endDate) return `${s} ~`;
        let e = this.formatDateKorean(this.endDate);
        return `${s} ~ ${e}`;
    }
  },

  // 메인 Vue 앱의 methods:와 병합됩니다.
  methods: {
    /** YYYY-MM-DD 형식으로 변환 */
    formatDateISO(date) {
      const y = date.getFullYear();
      const m = String(date.getMonth() + 1).padStart(2, '0');
      const d = String(date.getDate()).padStart(2, '0');
      return `${y}-${m}-${d}`;
    },
    
    /** 'M월 d일' 형식으로 변환 */
    formatDateKorean(dateStr) {
        const date = new Date(dateStr);
        return date.toLocaleString('ko-KR', { month: 'long', day: 'numeric' });
    },

    /** 오늘 날짜 (YYYY-MM-DD) 반환 */
    getToday() {
      return this.formatDateISO(new Date());
    },

    /** 이전 달로 이동 */
    prevMonth() {
      this.currentMonthDate = new Date(this.currentYear, this.currentMonth - 1, 1);
    },

    /** 다음 달로 이동 */
    nextMonth() {
      this.currentMonthDate = new Date(this.currentYear, this.currentMonth + 1, 1);
    },

    /** 날짜 클릭 시 (범위 선택 로직) */
    selectDate(day) {
      // 빈 칸(지난달/다음달) 클릭 시 무시
      if (!day.isCurrentMonth) return;

      const clickedDate = day.date;

      // 1. '시작일'을 선택할 차례인 경우
      if (this.selectionState === 'start') {
        this.startDate = clickedDate;
        this.endDate = null;
        this.selectionState = 'end'; // 다음은 '종료일' 선택 차례
      } 
      // 2. '종료일'을 선택할 차례인 경우
      else {
        // 만약 시작일보다 이전 날짜를 클릭했다면,
        // 클릭한 날짜를 '시작일'로, 기존 시작일을 '종료일'로 변경
        if (clickedDate < this.startDate) {
          this.endDate = this.startDate;
          this.startDate = clickedDate;
        } else {
          this.endDate = clickedDate;
        }
        this.selectionState = 'start'; // 다음은 다시 '시작일' 선택 차례
      }
    },
    
    /** 날짜 칸의 CSS 클래스 반환 */
    getDayClasses(day) {
      const classes = [];
      if (!day.isCurrentMonth) {
        classes.push('not-current-month');
      }
      if (day.date === this.getToday()) {
        classes.push('today');
      }

      // 범위 선택 관련
      if (day.date === this.startDate) {
        classes.push('selected-start');
        if (!this.endDate) classes.push('selected-end'); // 단일 날짜 선택 시
      }
      if (day.date === this.endDate) {
        classes.push('selected-end');
      }
      if (this.startDate && this.endDate && day.date > this.startDate && day.date < this.endDate) {
        classes.push('in-range');
      }
      
      return classes;
    },
  },
};