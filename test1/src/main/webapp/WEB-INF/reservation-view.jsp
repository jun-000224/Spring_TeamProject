<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>예약 상세 확인</title>

  <!-- ✅ jQuery: SRI 제거하여 로드 실패 방지 -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

  <!-- ✅ Vue: prod 빌드 -->
  <script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>

  <script type="text/javascript"
          src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services"></script>

  <!-- Iamport (중복 삽입 금지) -->
  <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

  <!-- Global CSS -->
  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/reservation.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    :root { --brand:#3498db; --brand-600:#2980b9; --danger:#e74c3c; --danger-600:#c0392b; --text:#333; --muted:#555; --border:#e0e0e0; --bg:#f4f7f6; }
    body{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;background:var(--bg);color:var(--text);}
    .wrap{max-width:1100px;margin:24px auto 60px;padding:0 16px;}
    .page-title{font-size:2.25rem;font-weight:700;color:#2c3e50;border-bottom:3px solid var(--brand);padding-bottom:10px;margin-bottom:20px;}
    .panel{background:#fff;border:1px solid var(--border);border-radius:12px;padding:24px;margin-bottom:25px;box-shadow:0 4px 12px rgba(0,0,0,.05);}
    .panel h2,.panel h3{margin:0 0 14px;border-bottom:1px solid #eee;padding-bottom:10px;}
    .info-list{list-style:none;margin:0;padding:0;}
    .info-list li{font-size:1.05rem;line-height:2;color:var(--muted);display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
    .info-list li strong{color:#222;width:120px;flex-shrink:0;}
    .title-input{font-size:1rem;padding:8px 10px;border:1px solid #ccc;border-radius:8px;flex:0 0 260px;max-width:260px;}
    .btn{padding:10px 14px;border:none;background:#f0f0f0;cursor:pointer;border-radius:8px;font-size:.95rem;color:#555;}
    .btn.primary{background:var(--brand);color:#fff;}.btn.primary:hover{background:var(--brand-600);}
    .btn.ghost{background:#f0f0f0;color:#555;}
    .btn.danger{background:var(--danger);color:#fff;}.btn.danger:hover{background:var(--danger-600);}
    .budget-total{font-size:1.1rem;font-weight:700;color:#333;margin-bottom:14px;}
    .budget-status-wrap{display:grid;grid-template-columns:repeat(4,1fr);gap:15px;padding:15px;background:#f9f9f9;border-radius:10px;}
    .budget-status-item{background:#fff;border:1px solid var(--border);border-radius:10px;padding:12px 10px;text-align:center;box-shadow:0 2px 4px rgba(0,0,0,.03);min-height:72px;}
    .budget-status-item .label{font-size:.85rem;color:#666;display:block;margin-bottom:6px;}
    .budget-status-item .amount{font-size:1.15rem;font-weight:700;color:var(--brand);display:block;}
    #map-container{width:100%;height:440px;border:1px solid #ddd;border-radius:10px;margin-top:10px;overflow:hidden;}
    .date-tabs{display:flex;gap:6px;margin-bottom:15px;border-bottom:2px solid #ddd;flex-wrap:wrap;}
    .tab-btn{padding:10px 14px;border:none;background:#f0f0f0;cursor:pointer;border-radius:8px 8px 0 0;font-size:.95rem;color:#555;position:relative;bottom:-2px;}
    .tab-btn.active{background:#fff;border:2px solid #ddd;border-bottom:2px solid #fff;font-weight:700;color:var(--brand);}
    .route-toolbar{display:flex;gap:8px;align-items:center;margin-bottom:10px;flex-wrap:wrap;}
    .route-summary{font-size:.9rem;color:#444;padding:6px 10px;background:#f5f7fa;border:1px solid #e5e7eb;border-radius:8px;}
    .poi-item{background:#fff;border:1px solid var(--border);border-radius:10px;padding:14px;margin-bottom:10px;}
    .poi-item p{margin:0;line-height:1.6;}
    .poi-item p:first-child strong{font-size:1.05rem;color:#2c3e50;}
    .save-button-wrap{display:flex;justify-content:center;gap:8px;margin-top:26px;flex-wrap:wrap;}
    .save-button-wrap .btn{min-width:140px;}
    .memo-card{width:100%;margin-top:16px;padding:16px 18px;border:1px solid var(--border);border-radius:10px;background:#fff;box-shadow:0 2px 6px rgba(0,0,0,.03);}
    .memo-title{font-weight:700;color:#2c3e50;margin-bottom:10px;display:flex;align-items:center;font-size:1rem;}
    .memo-field{width:100%;min-width:200px;max-width:100%;min-height:160px;padding:12px 14px;border:1px solid var(--border);border-radius:10px;background:#fff;font-size:.95rem;line-height:1.6;color:var(--text);resize:both;box-sizing:border-box;outline:none;transition:border-color .12s,box-shadow .12s;}
    .memo-field::placeholder{color:#98a2b3;}
    .memo-field:focus{border-color:var(--brand);box-shadow:0 0 0 3px rgba(52,152,219,.14);}
    .memo-hint{margin-top:8px;font-size:.85rem;color:#6b7280;}
    @media (max-width:860px){.budget-status-wrap{grid-template-columns:repeat(2,1fr);}}
    @media (max-width:520px){.budget-status-wrap{grid-template-columns:1fr;}.info-list li strong{width:100%;}}
  </style>
</head>
<body>
<%@ include file="components/header.jsp" %>

<div class="wrap">
  <div id="app">
    <h1 class="page-title">예약 상세 확인</h1>

    <div class="panel">
      <h3>기본 예약 정보 확인</h3>
      <ul class="info-list">
        <li>
          <strong>여행 코스 이름</strong>
          <input type="text" class="title-input" v-model="reservation.packname" placeholder="코스 별칭을 입력하세요" />
        </li>
        <li><strong>여행 기간</strong><span>{{ formatDate(reservation.startDate) }} ~ {{ formatDate(reservation.endDate) }}</span></li>
        <li><strong>방문 예정 장소</strong><span>총 {{ poiList ? poiList.length : 0 }}지점</span></li>
        <li><strong>테마</strong><span>{{ displayThemes }}</span></li>
      </ul>
    </div>

    <div class="panel">
      <h3>예산 현황</h3>
      <div class="budget-total"><strong>총 예산:</strong> {{ formatPrice(reservation.price) }}원</div>
      <div> 
        사용 가능 포인트 : {{info.totalPoint}}
      </div>
      <div>
        포인트 사용량 : 
        <input type="number" v-model="usingPoint" :max="info.totalPoint" min="0" @input="limitPoint" style="width: 80px; text-align: right; height: 20px;">
        <br>
        <br>
      </div>
      <div class="budget-status-wrap">
        <div class="budget-status-item"><span class="label">기타 예산</span><span class="amount">{{ formatPrice(reservation.etcBudget) }}원</span></div>
        <div class="budget-status-item"><span class="label">관광 및 활동 예산</span><span class="amount">{{ formatPrice(reservation.actBudget) }}원</span></div>
        <div class="budget-status-item"><span class="label">숙박 예산</span><span class="amount">{{ formatPrice(reservation.accomBudget) }}원</span></div>
        <div class="budget-status-item"><span class="label">식비 예산</span><span class="amount">{{ formatPrice(reservation.foodBudget) }}원</span></div>
      </div>

      <div class="memo-card" aria-label="메모 영역">
        <div class="memo-title"><i class="fa-regular fa-note-sticky" style="margin-right:6px;"></i> 메모</div>
        <textarea class="memo-field" rows="5" v-model="memo" placeholder="여행 메모를 입력하세요."></textarea>
        <div class="memo-hint">결제 성공 시 <code>RESERVATION.DESCRIPT</code>에 저장됩니다.</div>
      </div>
    </div>

    <div class="panel">
      <h2>🗺️ 여행 경로 지도</h2>
      <div class="route-toolbar">
        <button id="btnBuildRoute" @click="buildCarRoute" class="btn ghost">차량 경로 보기</button>
        <button v-if="routePolyline" @click="clearRoute" class="btn ghost">경로 지우기</button>
        <div v-if="routeSummary" class="route-summary">
          총 거리: {{ (routeSummary.distance/1000).toFixed(1) }} km ·
          예상 소요: {{ Math.round(routeSummary.duration/60) }} 분
          <span v-if="routeSummary.toll">· 톨비: {{ routeSummary.toll.toLocaleString() }}원</span>
        </div>
      </div>
      <div id="map-container">지도 로딩 중...</div>
    </div>

    <div class="panel">
      <h2>📋 상세 일정 목록</h2>
      <div class="date-tabs" v-if="Object.keys(itineraryByDate).length > 0">
        <button type="button" v-for="(pois, date, index) in itineraryByDate" :key="date"
                :class="['tab-btn', { active: activeDate === date }]" @click="setActiveDate(date)">
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

    <div class="save-button-wrap">
      <button class="btn primary" @click="fnSave">결제 후 저장하기</button>
      <button class="btn danger" @click="fnCancelReservation">여행 포기하기</button>
    </div>
  </div>
</div>

<%@ include file="components/footer.jsp" %>

<script>
  // Iamport 초기화(중복방지)
  (function initIMPOnce(){
    if (window.IMP && typeof window.IMP.init === 'function') {
      if (!window.__IMP_INIT__) {
        window.IMP.init("imp06808578");
        window.__IMP_INIT__ = true;
      }
    }
  })();

  const app = Vue.createApp({
    data() {
      return {
        userId: "${sessionId}",
        memo: "",
        reservation: {
          resNum: 0, packName: "사용자 지정 코스 이름", price: 0,
          startDate: "", endDate: "", pois: [], themNum: "", packname: "",
          etcBudget: 0, accomBudget: 0, foodBudget: 0, actBudget: 0
        },
        poiList: [],
        kakaoAppKey: '${kakaoAppKey}',
        map: null, itineraryByDate: {}, activeDate: null,
        themeOptions: [
          { code: 'FAMILY', label: '가족' }, { code: 'FRIEND', label: '친구' },
          { code: 'COUPLE', label: '연인' }, { code: 'LUXURY', label: '호화스러운' },
          { code: 'BUDGET', label: '가성비' }, { code: 'HEALING', label: '힐링' },
          { code: 'UNIQUE', label: '이색적인' }, { code: 'ADVENTURE', label: '모험' },
          { code: 'QUIET', label: '조용한' }
        ],
        routePolyline: null, routeSummary: null, markers: [],
        info:{},
        usingPoint: 0
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
      formatPrice(v){ const n=Number(v); return isFinite(n)? n.toLocaleString() : '0'; },
      formatDate(d){ if(!d) return "날짜 없음"; try{ return String(d).split(' ')[0]; }catch(e){ return d; } },

      initializeMap(data){
        if (!window.kakao || !kakao.maps) { document.getElementById('map-container').innerText='Kakao Map API 로드 실패.'; return; }
        const container=document.getElementById('map-container');
        const options={ center:new kakao.maps.LatLng(data[0].mapY,data[0].mapX), level:7 };
        this.map=new kakao.maps.Map(container,options);
        const bounds=new kakao.maps.LatLngBounds(); this.clearMarkers();
        data.forEach(p=>{
          const pos=new kakao.maps.LatLng(p.mapY,p.mapX);
          const marker=new kakao.maps.Marker({ position:pos }); marker.setMap(this.map); this.markers.push(marker);
          const info=new kakao.maps.InfoWindow({ content:'<div style="padding:5px;">'+(p.placeName||p.contentId)+'</div>' });
          kakao.maps.event.addListener(marker,'mouseover',()=>info.open(this.map,marker));
          kakao.maps.event.addListener(marker,'mouseout',()=>info.close());
          bounds.extend(pos);
        });
        this.map.setBounds(bounds);
      },
      clearMarkers(){ if(!this.markers) return; this.markers.forEach(m=>m.setMap(null)); this.markers=[]; },

      drawPolyline(points){
        if(!this.map) return;
        if(this.routePolyline){ this.routePolyline.setMap(null); this.routePolyline=null; }
        if(!points||points.length===0) return;
        const path=points.map(pt=>new kakao.maps.LatLng(pt.y,pt.x));
        this.routePolyline=new kakao.maps.Polyline({ path, strokeWeight:5, strokeOpacity:0.9 });
        this.routePolyline.setMap(this.map);
        const bounds=new kakao.maps.LatLngBounds(); path.forEach(latlng=>bounds.extend(latlng)); this.map.setBounds(bounds);
      },
      clearRoute(){ if(this.routePolyline){ this.routePolyline.setMap(null); this.routePolyline=null; } this.routeSummary=null; },

      async buildCarRoute(){
        const pois=this.itineraryByDate[this.activeDate]||[];
        const valid=pois.filter(p=>p.mapX!=null&&p.mapY!=null&&!isNaN(p.mapX)&&!isNaN(p.mapY));
        if(valid.length<2){ alert('경로를 그릴 최소 2개 지점(출발/도착)이 필요합니다.'); return; }
        try{
          const payload={ resNum:this.reservation.resNum, day:this.activeDate,
            pois: valid.map(p=>({ contentId:p.contentId, name:p.placeName||'', x:Number(p.mapX), y:Number(p.mapY) })) };
          const resp=await $.ajax({ url:'/api/route/build', type:'POST', contentType:'application/json', data:JSON.stringify(payload) });
          this.drawPolyline(resp.points); this.routeSummary=resp.summary||null;
        }catch(e){ console.error(e); alert('경로 계산에 실패했습니다.'); }
      },

      // 결제금액 조회 → 결제 → 성공 시 코스명/메모 저장
      async fnSave(){
        try{
          const name=(this.reservation.packname||'').trim();
          if(name.length===0){ if(!confirm('코스 이름이 비어 있습니다. 그대로 진행할까요?')) return; }

          // 1) 금액 조회
          const amtResp=await $.ajax({ url:'/api/reservation/pay/amount', type:'GET', data:{ resNum:this.reservation.resNum } });
          const payAmount=Number(amtResp.amount||0);
          if(!isFinite(payAmount)||payAmount<=0){ alert('결제 금액이 유효하지 않습니다. (금액: '+payAmount+')'); return; }

          // 2) 결제
          if(!(window.IMP && typeof window.IMP.request_pay==='function')){ alert('결제 모듈 초기화에 실패했습니다.'); return; }
          const self=this;
          window.IMP.request_pay({
            pg:"html5_inicis", 
            pay_method:"card",
            merchant_uid:"merchant_"+new Date().getTime(),
            name:"여행 결제 (숙박+식비)", 
            // amount:payAmount - this.usingPoint, 
            amount:1,
            buyer_tel:"010-0000-0000"
          }, async function(rsp){
            if(rsp.success){
              try{
                // 3) 저장
                const payload={ resNum:self.reservation.resNum, packName:name, userId:self.userId, descript:self.memo };
                await $.ajax({ url:'/api/reservation/update/packname', type:'POST', contentType:'application/json', data:JSON.stringify(payload) });
                alert("결제 및 저장에 성공했습니다. 나의 예약 페이지로 이동합니다.");
                window.location.href='/myReservation.do?resNum='+self.reservation.resNum;
              }catch(e){ console.error(e); alert('결제는 성공했지만 저장에 실패했습니다.'); }
            }else{
              alert('결제가 취소되었거나 실패했습니다.');
            }
          });
        }catch(err){ console.error(err); alert('처리 중 오류가 발생했습니다.'); }
      },

      fnCancelReservation(){
        if(!confirm('정말로 이 예약을 삭제하시겠습니까?')) return;
        $.ajax({
          url:'/api/reservation/delete', type:'POST', contentType:'application/json',
          data:JSON.stringify({ resNum:this.reservation.resNum }),
          success:()=>{ alert('예약이 삭제되었습니다.'); window.location.href='/main-list.do'; },
          error:(jqXHR)=>{ alert('삭제 실패 ('+jqXHR.status+')'); }
        });
      },

      groupPoisByDate(list){
        const sorted=[].concat(list).sort((a,b)=>new Date(a.reservDate)-new Date(b.reservDate));
        const grouped={}; sorted.forEach(p=>{ const d=this.formatDate(p.reservDate); if(!grouped[d]) grouped[d]=[]; grouped[d].push(p); });
        this.itineraryByDate=grouped; if(Object.keys(grouped).length>0) this.activeDate=Object.keys(grouped)[0];
      },
      setActiveDate(d){ this.activeDate=d; this.clearRoute(); },

      fnMemberPoint(){
        let self = this;
          let param = {
            userId : self.userId
          };
          $.ajax({
              url: "/point/recent.dox",
              dataType: "json",
              type: "POST",
              data: param,
              success: function (data) {
                // console.log(data);
                self.info = data.info;
              }
          });
      },

      limitPoint(){
        let self = this;
        self.usingPoint = Math.floor(self.usingPoint);

        if(self.usingPoint > self.info.totalPoint){
          self.usingPoint = self.info.totalPoint;
        }
        
        if(self.usingPoint < 0 || isNaN(self.usingPoint)){
          self.usingPoint = 0;
        }
      }
    },
    mounted(){
      this.reservation=JSON.parse('<c:out value="${reservationJson}" escapeXml="false" />');
      this.reservation.packname=this.reservation.packName;
      if(this.reservation.descript) this.memo=this.reservation.descript;

      const rawPoiList=JSON.parse('<c:out value="${poiListJson}" escapeXml="false" />');
      this.poiList=rawPoiList.filter(p=>p.contentId && !isNaN(p.contentId) && Number(p.contentId)>0);

      this.groupPoisByDate(this.poiList);

      const validMapPois=this.poiList.filter(p=>p.mapY!=null && p.mapX!=null && !isNaN(p.mapY) && !isNaN(p.mapX));
      if(validMapPois.length>0) this.initializeMap(validMapPois);
      else document.getElementById('map-container').innerText='DB에 저장된 좌표 정보가 없습니다.';

      this.fnMemberPoint();
    }
  });

  app.mount('#app');
</script>
</body>
</html>
