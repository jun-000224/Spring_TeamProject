// 예약 페이지 - 파이 차트 로직 (Vue 3 mixin) + 잠금(LOCK) 지원
(function () {
  const mixin = {
    data() {
      return {
        // Pie categories & state
        categories: [
          { key: 'etc',   label: '기타',         color: '#d1d5db' },
          { key: 'accom', label: '숙박',         color: '#a3bffa' },
          { key: 'food',  label: '식당',         color: '#f9a8d4' },
          { key: 'act',   label: '체험 및 관광', color: '#86efac' }
        ],
        weights: [25, 25, 25, 25],
        // ✅ 잠금 상태 (체크박스용)
        locks:   [false, false, false, false],

        minPct: 0,
        dragging: false,
        dragBoundaryIndex: -1,
        center: { x: 320, y: 240 },
        radiusOuter: 180,
        radiusInner: 110,

        _dpr: (window.devicePixelRatio || 1),
        _rafId: null
      };
    },
    methods: {
      // ---------- 유틸 ----------
      _unlockedIdxs() {
        const out = [];
        for (let i = 0; i < this.weights.length; i++) if (!this.locks[i]) out.push(i);
        return out;
      },
      _indexOfMax(idxs) {
        if (!idxs.length) return -1;
        let bi = idxs[0];
        for (const i of idxs) if (this.weights[i] > this.weights[bi]) bi = i;
        return bi;
      },
      _indexOfMin(idxs) {
        if (!idxs.length) return -1;
        let bi = idxs[0];
        for (const i of idxs) if (this.weights[i] < this.weights[bi]) bi = i;
        return bi;
      },
      toggleLock(i) {
        this.locks[i] = !this.locks[i];
        // 전부 잠기는 상황 방지
        if (this._unlockedIdxs().length === 0) this.locks[i] = false;
        this.normalizeWeights();
        this.drawPie();
      },

      onBudgetChange() { this.drawPie(); },
      amountFor(idx) {
        const b = Number(this.budget || 0);
        return Math.round(b * (Number(this.weights[idx]) / 100));
      },

      // ---------- 정규화(잠금 고려) ----------
      normalizeWeights() {
        const lockedSum = this.weights.reduce((s, w, i) => s + (this.locks[i] ? Number(w) : 0), 0);
        const freeIdxs = this._unlockedIdxs();
        let freeBudget = Math.max(0, 100 - lockedSum);

        // free 비율 재스케일
        const freeCurrent = freeIdxs.reduce((s, i) => s + Number(this.weights[i]), 0);
        if (freeIdxs.length > 0) {
          if (freeCurrent <= 0) {
            const base = Math.max(this.minPct, Math.floor(freeBudget / freeIdxs.length));
            freeIdxs.forEach(i => this.weights[i] = base);
          } else {
            freeIdxs.forEach(i => {
              const raw = Number(this.weights[i]) * (freeBudget / freeCurrent);
              this.weights[i] = Math.max(this.minPct, Math.round(raw));
            });
          }
        }

        // 총합 보정(±1) — 보정은 free에서만
        let diff = 100 - this.weights.reduce((a, b) => a + Number(b), 0);
        while (diff !== 0) {
          const target = (diff > 0) ? this._indexOfMax(freeIdxs) : this._indexOfMin(freeIdxs);
          if (target === -1) break;
          const i = target;
          const nv = this.weights[i] + (diff > 0 ? 1 : -1);
          if (nv < this.minPct) break;
          this.weights[i] = nv;
          diff = 100 - this.weights.reduce((a, b) => a + Number(b), 0);
        }
      },

      // ---------- 슬라이더 입력(잠금 고려) ----------
      onSlider(idx, val) {
        val = Math.max(this.minPct, Math.min(90, Number(val)));
        if (this.locks[idx]) { this.drawPie(); return; }

        const lockedSum = this.weights.reduce((s, w, i) => s + (this.locks[i] ? Number(w) : 0), 0);
        const remain = Math.max(0, 100 - lockedSum - val);
        const others = this._unlockedIdxs().filter(i => i !== idx);
        const oldSum = others.reduce((s, i) => s + Number(this.weights[i]), 0);

        this.weights[idx] = val;

        if (others.length > 0) {
          if (oldSum <= 0) {
            const base = Math.max(this.minPct, Math.floor(remain / others.length));
            others.forEach(i => this.weights[i] = base);
          } else {
            others.forEach(i => {
              const ratio = this.weights[i] / oldSum;
              this.weights[i] = Math.max(this.minPct, Math.round(remain * ratio));
            });
          }
        }

        this.normalizeWeights();
        this.drawPie();
      },

      // ---------- Canvas ----------
      setupCanvas() {
        const canvas = document.getElementById('budgetPie');
        if (!canvas) return;

        const rect = canvas.getBoundingClientRect();
        const cssW = Math.max(320, Math.floor(rect.width));
        const cssH = Math.floor(cssW * 0.75);
        const dpr = (window.devicePixelRatio || 1);
        this._dpr = dpr;

        canvas.style.width = cssW + 'px';
        canvas.style.height = cssH + 'px';
        canvas.width = Math.floor(cssW * dpr);
        canvas.height = Math.floor(cssH * dpr);

        const ctx2d = canvas.getContext('2d');
        ctx2d.setTransform(dpr, 0, 0, dpr, 0, 0);

        this.center = { x: cssW / 2, y: cssH / 2 };
        this.radiusOuter = Math.min(cssW, cssH) * 0.38;
        this.radiusInner = this.radiusOuter * 0.62;

        this.drawPie();
      },
      drawPie() {
        if (this._rafId) cancelAnimationFrame(this._rafId);
        this._rafId = requestAnimationFrame(() => {
          const canvas = document.getElementById('budgetPie');
          if (!canvas) return;
          const ctx2d = canvas.getContext('2d');
          const cx = this.center.x, cy = this.center.y;
          const rO = this.radiusOuter, rI = this.radiusInner;

          ctx2d.clearRect(0, 0, canvas.width / this._dpr, canvas.height / this._dpr);

          const total = 100;
          let start = -Math.PI / 2;
          const angles = [];
          for (let i = 0; i < this.weights.length; i++) {
            const ang = (this.weights[i] / total) * Math.PI * 2;
            const end = start + ang;
            angles.push({ start, end });

            ctx2d.beginPath();
            ctx2d.moveTo(cx, cy);
            ctx2d.arc(cx, cy, rO, start, end, false);
            ctx2d.lineTo(cx + rI * Math.cos(end), cy + rI * Math.sin(end));
            ctx2d.arc(cx, cy, rI, end, start, true);
            ctx2d.closePath();
            ctx2d.fillStyle = this.categories[i].color;
            ctx2d.fill();

            // 🔒 잠금 조각 점선 표시
            if (this.locks[i]) {
              ctx2d.save();
              ctx2d.setLineDash([4, 3]);
              ctx2d.lineWidth = 2;
              ctx2d.strokeStyle = '#111827';
              ctx2d.stroke();
              ctx2d.restore();
            }
            start = end;
          }

          // boundaries
          ctx2d.save();
          ctx2d.lineWidth = 2;
          ctx2d.strokeStyle = '#ffffff';
          start = -Math.PI / 2;
          for (let i = 0; i < this.weights.length; i++) {
            ctx2d.beginPath();
            ctx2d.moveTo(cx + rI * Math.cos(start), cy + rI * Math.sin(start));
            ctx2d.lineTo(cx + rO * Math.cos(start), cy + rO * Math.sin(start));
            ctx2d.stroke();
            start += (this.weights[i] / total) * Math.PI * 2;
          }
          ctx2d.restore();

          // middle labels
          ctx2d.save();
          ctx2d.fillStyle = '#111827';
          ctx2d.font = 'bold 13px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';
          for (let i = 0; i < this.weights.length; i++) {
            const mid = (angles[i].start + angles[i].end) / 2;
            const rr = (rO + rI) / 2;
            const tx = cx + rr * Math.cos(mid);
            const ty = cy + rr * Math.sin(mid);
            ctx2d.textAlign = 'center';
            ctx2d.textBaseline = 'middle';
            ctx2d.fillText(this.weights[i] + '%', tx, ty);
          }
          ctx2d.restore();
        });
      },

      // ---------- Drag interactions ----------
      pointToAngle(x, y) {
        const dx = x - this.center.x;
        const dy = y - this.center.y;
        let ang = Math.atan2(dy, dx);
        if (ang < -Math.PI / 2) ang += Math.PI * 2;
        return ang;
      },
      hitInRing(x, y) {
        const dx = x - this.center.x;
        const dy = y - this.center.y;
        const d = Math.sqrt(dx * dx + dy * dy);
        return (d >= this.radiusInner && d <= this.radiusOuter);
      },
      getBoundaries() {
        const B = [];
        let a = -Math.PI / 2;
        for (let i = 0; i < this.weights.length; i++) {
          B.push(a);
          a += (this.weights[i] / 100) * Math.PI * 2;
        }
        return B;
      },
      closestBoundary(angle) {
        const B = this.getBoundaries();
        let minIdx = 0, minDist = 1e9;
        for (let i = 0; i < B.length; i++) {
          let d = Math.abs(angle - B[i]);
          d = Math.min(d, Math.PI * 2 - d);
          if (d < minDist) { minDist = d; minIdx = i; }
        }
        return minIdx;
      },
      onPieDown(evt) {
        const rect = evt.target.getBoundingClientRect();
        const x = evt.clientX - rect.left;
        const y = evt.clientY - rect.top;
        if (!this.hitInRing(x, y)) return;
        const ang = this.pointToAngle(x, y);
        this.dragBoundaryIndex = this.closestBoundary(ang);
        this.dragging = true;
      },
      onPieMove(evt) {
        if (!this.dragging) return;
        const rect = evt.target.getBoundingClientRect();
        const x = evt.clientX - rect.left;
        const y = evt.clientY - rect.top;
        this.dragTo(x, y);
      },
      onPieDownTouch(evt) {
        const canvas = evt.target;
        const rect = canvas.getBoundingClientRect();
        const t = evt.touches[0];
        const x = t.clientX - rect.left, y = t.clientY - rect.top;
        if (!this.hitInRing(x, y)) return;
        const ang = this.pointToAngle(x, y);
        this.dragBoundaryIndex = this.closestBoundary(ang);
        this.dragging = true;
      },
      onPieMoveTouch(evt) {
        if (!this.dragging) return;
        const canvas = evt.target;
        const rect = canvas.getBoundingClientRect();
        const t = evt.touches[0];
        const x = t.clientX - rect.left, y = t.clientY - rect.top;
        this.dragTo(x, y);
      },
      onPieUp() { this.dragging = false; this.dragBoundaryIndex = -1; },

      // ✅ 경계 드래그 시 잠금 고려
      dragTo(x, y) {
        const angNow = this.pointToAngle(x, y);
        const B = this.getBoundaries();
        const i = this.dragBoundaryIndex;
        const left = (i - 1 + this.weights.length) % this.weights.length;
        const right = i % this.weights.length;

        // 양쪽 모두 잠금이면 이동 불가
        if (this.locks[left] && this.locks[right]) return;

        let angOld = B[i];
        let delta = angNow - angOld;
        if (delta > Math.PI) delta -= Math.PI * 2;
        if (delta < -Math.PI) delta += Math.PI * 2;

        const deltaPct = Math.round((delta / (Math.PI * 2)) * 100);
        let wL = this.weights[left];
        let wR = this.weights[right];

        if (this.locks[left] && !this.locks[right]) {
          wR = wR - deltaPct;
        } else if (!this.locks[left] && this.locks[right]) {
          wL = wL + deltaPct;
        } else {
          wL = wL + deltaPct;
          wR = wR - deltaPct;
        }

        if (wL < this.minPct) { wR -= (this.minPct - wL); wL = this.minPct; }
        if (wR < this.minPct) { wL -= (this.minPct - wR); wR = this.minPct; }
        if (wL < this.minPct || wR < this.minPct) return;

        this.weights[left]  = Math.round(wL);
        this.weights[right] = Math.round(wR);

        this.normalizeWeights();
        this.drawPie();
      }
    },
    mounted() {
      this.setupCanvas();
      this._onResize = () => this.setupCanvas();
      window.addEventListener('resize', this._onResize, { passive: true });
    },
    unmounted() {
      window.removeEventListener('resize', this._onResize);
      if (this._rafId) cancelAnimationFrame(this._rafId);
    }
  };

  window.ReservationPieMixin = mixin;
})();
