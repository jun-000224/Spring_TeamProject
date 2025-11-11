<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Team Project</title>

    <!-- Vendor -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script
      type="text/javascript"
      src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"
    ></script>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
      crossorigin="anonymous"
      referrerpolicy="no-referrer"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/swiper@8.4.7/swiper-bundle.min.js"></script>

    <!-- Global CSS -->
    <link rel="stylesheet" href="/css/main-style.css" />
    <link rel="stylesheet" href="/css/common-style.css" />
    <link rel="stylesheet" href="/css/header-style.css" />
    <link rel="stylesheet" href="/css/main-images.css" />
    <script src="/js/page-change.js"></script>

    <!-- ================================
         ✅ 통째 교체용 스타일
    ================================= -->
    <style>
      /* ================================
         ✅ 기본 설정 (페이지 공통)
      ================================ */
      :root{
        --sky-500:#0ea5e9;
        --sky-600:#0284c7;
        --red-500:#ef4444;
        --red-600:#dc2626;
        --text:#222;
        --muted:#666;
        --bg:#f8f8f8;
        --card:#ffffff;
        --ring:rgba(2,132,199,.25);
        --shadow:0 8px 28px rgba(0,0,0,.08);
      }
      *{box-sizing:border-box}
      body{
        margin:0;
        background:var(--bg);
        font-family:"Noto Sans KR",system-ui,-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;
        color:var(--text);
      }
      .content-wrapper{
        width:100%;
        max-width:1200px;
        margin:0 auto;
        padding:40px 20px;
      }

      /* ================================
         ✅ 지도 영역 (실서비스 톤)
      ================================ */
      .map_wrap{
        position:relative;
        width:100%;
        min-height:420px;
        border-radius:16px;
        overflow:hidden;
        background:linear-gradient(180deg,#eaf4ff 0%, #f6f9ff 100%);
        box-shadow:var(--shadow);
      }
      #map{width:100%;height:100%}

      /* 카테고리 패널 (좌상단 칩 UI) */
      #category{
        position:absolute;
        top:16px; left:16px;
        display:flex;
        gap:8px;
        padding:8px;
        max-width:calc(100% - 32px);
        overflow-x:auto;
        border-radius:14px;
        backdrop-filter:blur(8px);
        -webkit-backdrop-filter:blur(8px);
        background:rgba(255,255,255,.72);
        border:1px solid rgba(0,0,0,.06);
        box-shadow:0 6px 18px rgba(0,0,0,.06);
        z-index:10;
        scrollbar-width:thin;
      }
      #category li{
        flex:0 0 auto;
        list-style:none;
        display:flex; align-items:center; gap:8px;
        padding:10px 12px;
        border:1px solid rgba(0,0,0,.06);
        border-radius:999px;
        cursor:pointer;
        font-size:.92rem;
        color:#1f2937;
        background:#fff;
        transition:transform .15s ease, box-shadow .15s ease, background .15s ease, color .15s ease, border-color .15s ease;
        user-select:none;
        will-change:transform;
      }
      #category li:hover{
        transform:translateY(-1px);
        box-shadow:0 8px 20px rgba(2,132,199,.12);
        border-color:var(--ring);
      }
      #category li.on{
        background:linear-gradient(180deg,var(--sky-500) 0%, var(--sky-600) 100%);
        color:#fff;
        border-color:transparent;
        box-shadow:0 8px 22px rgba(2,132,199,.25);
      }

      /* 카테고리 아이콘 스프라이트 */
      #category li span{
        display:block; width:24px; height:24px;
        background:url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png) no-repeat;
        background-size:auto;
        filter:saturate(.9) contrast(1.05);
      }
      #category li .bank{ background-position:-10px 0; }
      #category li .mart{ background-position:-10px -36px; }
      #category li .pharmacy{ background-position:-10px -72px; }
      #category li .oil{ background-position:-10px -108px; }
      #category li .cafe{ background-position:-10px -144px; }
      #category li .store{ background-position:-10px -180px; }
      /* 숙소 아이콘 임시 매핑(스프라이트 대체) */
      #category li .home{ background-position:-10px -144px; }
      #category li.on span{ filter:brightness(10); }

      /* 로드뷰 컨트롤 (우상단 버튼) */
      #roadviewBtn, #exitRoadviewBtn{
        position:absolute;
        top:16px; right:16px;
        z-index:10;
        appearance:none; border:none;
        height:40px; padding:0 14px;
        border-radius:10px;
        font-weight:700; letter-spacing:.2px;
        cursor:pointer;
        color:#fff;
        box-shadow:0 8px 20px rgba(0,0,0,.12);
        transition:transform .12s ease, box-shadow .12s ease, background .12s ease, opacity .12s ease;
        will-change:transform;
      }
      #roadviewBtn{
        background:linear-gradient(180deg,var(--sky-500) 0%, var(--sky-600) 100%) !important;
      }
      #exitRoadviewBtn{
        right:130px;
        background:linear-gradient(180deg,var(--red-500) 0%, var(--red-600) 100%) !important;
      }
      #roadviewBtn:hover, #exitRoadviewBtn:hover{
        transform:translateY(-1px);
        box-shadow:0 10px 24px rgba(0,0,0,.16);
      }
      #roadviewBtn:active, #exitRoadviewBtn:active{
        transform:translateY(0);
        box-shadow:0 6px 16px rgba(0,0,0,.14);
      }

      /* 로드뷰 전환 감 */
      #roadview{
        width:100%; height:420px; background:#000;
        transition:opacity .2s ease;
      }

      /* 지도 하단 페이드 */
      .map_wrap::after{
        content:"";
        position:absolute; inset:auto 0 0 0; height:18px;
        background:linear-gradient(180deg, rgba(255,255,255,0) 0%, rgba(248,248,248,1) 90%);
        pointer-events:none;
      }

      /* ================================
         ✅ 내 위치 인포윈도우 / 펄스 마커
      ================================ */
      .my-location-badge{
        position: relative;
        min-width: 220px;
        max-width: 280px;
        padding: 12px 14px;
        border-radius: 12px;
        background: #ffffff;
        box-shadow: 0 12px 28px rgba(2,132,199,.18);
        border: 1px solid rgba(2,132,199,.18);
        font-family:"Noto Sans KR", system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
      }
      .my-location-badge:after{
        content:"";
        position:absolute;
        left:24px; bottom:-10px;
        width:18px; height:18px;
        background:#fff;
        border-left:1px solid rgba(2,132,199,.18);
        border-bottom:1px solid rgba(2,132,199,.18);
        transform: rotate(45deg);
        box-shadow: 4px 4px 12px rgba(2,132,199,.08);
      }
      .my-location-badge .title{
        font-weight: 700;
        color:#0ea5e9; /* sky-500 */
        margin-bottom: 6px;
        display:flex; align-items:center; gap:6px;
      }
      .my-location-badge .title::before{
        content:"location_on";
        font-family: "Material Symbols Outlined";
        font-variation-settings: "FILL" 1, "wght" 600, "GRAD" 0, "opsz" 24;
        font-size: 18px;
      }
      .my-location-badge .addr{
        font-size: 0.95rem;
        color:#374151;
        line-height:1.45;
        margin-bottom: 10px;
      }
      .my-location-badge .hint{
        font-size: 0.82rem;
        color:#6b7280;
        margin-bottom: 10px;
        width: 230px;
      }
      .my-location-badge .actions{ display:flex; gap:8px; }
      .my-location-badge .btn-mini{
        flex:0 0 auto;
        height:32px;
        padding:0 10px;
        border-radius:8px;
        border: none;
        background: linear-gradient(180deg,#0ea5e9 0%, #0284c7 100%);
        color:#fff; font-weight:600; cursor:pointer;
        box-shadow: 0 6px 16px rgba(2,132,199,.25);
        transition: transform .12s ease, box-shadow .12s ease, opacity .12s ease;
      }
      .my-location-badge .btn-mini:hover{ transform: translateY(-1px); }
      .my-location-badge .btn-mini:active{ transform: translateY(0); box-shadow: 0 4px 12px rgba(2,132,199,.22); }
      .my-location-badge .btn-mini.outline{
        background:#fff; color:#0284c7;
        border:1px solid rgba(2,132,199,.45);
        box-shadow:none;
      }

      /* 내 위치 펄스 오버레이 */
      .pulse-dot{
        position: relative;
        width: 14px; height: 14px;
        background: #0ea5e9;
        border: 2px solid #fff;
        border-radius: 50%;
        box-shadow: 0 0 0 4px rgba(14,165,233,.25);
        transform: translate(-50%, -50%);
      }
      .pulse-dot:after{
        content:"";
        position:absolute; inset:-2px;
        border-radius:50%;
        border:2px solid rgba(14,165,233,.65);
        animation: pulse 1.8s infinite ease-out;
      }
      @keyframes pulse{
        0%   { transform: scale(1); opacity: .9; }
        70%  { transform: scale(2.4); opacity: 0; }
        100% { transform: scale(2.4); opacity: 0; }
      }
      .my-location-marker-shadow{ filter: drop-shadow(0 6px 12px rgba(2,132,199,.25)); }

      /* 반응형 최적화 (지도) */
      @media (max-width:1024px){
        #category{ gap:6px; padding:6px; }
        #category li{ padding:9px 11px; font-size:.9rem; }
        #exitRoadviewBtn{ right:120px; }
      }
      @media (max-width:640px){
        .map_wrap{ min-height:360px; border-radius:14px; }
        #category{ top:12px; left:12px; }
        #category li{ padding:8px 10px; }
        #roadviewBtn, #exitRoadviewBtn{ top:12px; right:12px; height:38px; border-radius:9px; }
        #exitRoadviewBtn{ right:114px; }
      }

      /* ================================
         ✅ 슬라이더 (Swiper)
      ================================ */
      .swiper-container{
        width:100%;
        height:330px;
        margin:40px 0;
        border-radius:10px;
        overflow:hidden;
        box-shadow:0 4px 10px rgba(0,0,0,.1);
        position:relative;
        background:#fff;
      }
      .swiper-slide{ display:flex; justify-content:center; align-items:center; }
      .swiper-button-next, .swiper-button-prev{
        color:#0078ff;
        transition:opacity .2s ease;
      }
      .swiper-button-next:hover, .swiper-button-prev:hover{ opacity:.8; }
      .swiper-slide .card{ width:335px; }

      /* ================================
         ✅ 카드 레이아웃 (후기)
      ================================ */
      .card-container{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(300px,1fr));
        gap:25px;
        max-width:1200px; margin:0 auto;
      }
      .card{
        position:relative;
        height:320px;
        perspective:1000px;
        border-radius:15px;
      }
      .card-inner{
        position:relative; width:335px; height:100%;
        transition:transform .8s; transform-style:preserve-3d;
      }
      .card:hover .card-inner{ transform:rotateY(180deg); }
      .card-front, .card-back{
        position:absolute; width:100%; height:100%;
        border-radius:15px; overflow:hidden;
        backface-visibility:hidden;
        box-shadow:0 4px 15px rgba(0,0,0,.08);
        background:#fff;
      }
      .card-front img{
        width:100%; height:100%; display:block; object-fit:cover; background:#ddd;
      }
      .card-back{
        transform:rotateY(180deg);
        display:flex; flex-direction:column; justify-content:space-between;
      }
      .card-body{
        display:flex; flex-direction:column; justify-content:space-between;
        height:100%; padding:18px 20px;
      }
      .card-box{ display:flex; justify-content:space-between; align-items:flex-start; }
      .card-theme{
        display:inline-block; background:#e3f2fd; color:#1976d2;
        padding:4px 12px; border-radius:12px; font-size:.8em; font-weight:500; margin:0 6px 6px 0;
      }
      .material-symbols-outlined{
        font-variation-settings:"FILL" 0,"wght" 400,"GRAD" 0,"opsz" 48;
        color:#777; font-size:24px; cursor:pointer; transition:all .2s ease;
      }
      .material-symbols-outlined.liked{ font-variation-settings:"FILL" 1; color:#e53935; }
      .card-cnt{ display:flex; align-items:center; gap:4px; font-size:.85em; color:#666; }
      .card-title{ font-size:1.2em; font-weight:600; color:#222; margin-bottom:6px; line-height:1.4; }
      .card-desc{ font-size:.95em; color:#555; line-height:1.5; flex:1; margin-bottom:10px; }
      .card-info{ font-size:.9em; color:#777; margin-bottom:12px; }
      .card-footer button{
        width:100%; padding:8px 0;
        background:#0078ff; border:none; color:#fff;
        border-radius:8px; font-weight:600; cursor:pointer; transition:background .2s;
      }
      .card-footer button:hover{ background:#005fcc; }

      /* ================================
         ✅ 추천 게시글 카드 (best)
      ================================ */
      .bestCard-container{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(280px,1fr));
        gap:30px; max-width:1200px; margin:0 auto 40px;
      }
      .bestCard-container .card{
        background:var(--card); border-radius:15px; overflow:hidden;
        box-shadow:0 4px 12px rgba(0,0,0,.08);
        cursor:pointer; transition:transform .3s ease, box-shadow .3s ease;
        display:flex; flex-direction:column; height:auto; perspective:none;
      }
      .bestCard-container .card:hover{ transform:translateY(-5px); box-shadow:0 8px 20px rgba(0,0,0,.12); }
      .bestCard-container .card-body{ padding:15px; display:flex; flex-direction:column; flex:1; }
      .bestCard-container .card-title{ font-size:1.15em; font-weight:600; margin-bottom:8px; color:#222; }
      .bestCard-container .card-desc{
        font-size:.95em; color:#555; flex:1; margin-bottom:10px;
        overflow:hidden; text-overflow:ellipsis; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical;
      }
      .bestCard-container .card-info{ font-size:.9em; color:#777; margin-bottom:10px; }
      .bestCard-container .card-cnt{ display:flex; justify-content:space-between; align-items:center; gap:5px; font-size:.85em; color:#666; }
      .bestCard-container .material-symbols-outlined{
        font-variation-settings:"FILL" 0,"wght" 400,"GRAD" 0,"opsz" 48;
        color:#777; font-size:20px; cursor:pointer; transition:all .2s ease;
      }
      .bestCard-container .material-symbols-outlined.liked{ font-variation-settings:"FILL" 1; color:#e53935; }

      /* ================================
         ✅ 섹션 타이틀
      ================================ */
      h2{
        font-size:22px; margin:0 0 20px; text-align:center; color:#333;
      }
    </style>
  </head>

  <body>
    <%@ include file="components/header.jsp" %>

    <div id="app">
      <div class="content-wrapper">
        <div class="hero-section">
          <!-- 지도 -->
          <div class="map_wrap">
            <div id="map" style="width: 100%; height: 100%; position: relative; overflow: hidden"></div>

            <button id="roadviewBtn" style="display:none">로드뷰 보기</button>
            <button id="exitRoadviewBtn" style="display:none">나가기</button>

            <div id="roadview" style="display:none"></div>

            <ul id="category">
              <li id="BK9"><span class="category_bg bank"></span>은행</li>
              <li id="MT1"><span class="category_bg mart"></span>마트</li>
              <li id="PM9"><span class="category_bg pharmacy"></span>약국</li>
              <li id="OL7"><span class="category_bg oil"></span>주유소</li>
              <li id="CE7"><span class="category_bg cafe"></span>카페</li>
              <li id="CS2"><span class="category_bg store"></span>편의점</li>
              <li id="AD5"><span class="category_bg home"></span>숙소</li>
            </ul>
          </div>

          <!-- 후기 슬라이더 -->
          <div class="swiper review-slider" style="margin-top:40px">
            <h2>추천 후기글</h2>
            <div class="swiper-wrapper">
              <div
                class="swiper-slide card"
                v-for="item in list"
                :key="item.resNum"
                @click="fnDetail(item.resNum)"
              >
                <div class="card-inner">
                  <div class="card-front">
                    <img
                      class="card-img"
                      :src="thumbnailMap[item.resNum]?.firstimage || getRandomImage()"
                      :alt="item.packname"
                    />
                  </div>
                  <div class="card-back">
                    <div class="card-body">
                      <div class="card-box">
                        <div>
                          <div class="card-theme" v-for="tag in item.themNum.split(',')" :key="tag">{{ tag }}</div>
                        </div>
                        <div style="display:flex">
                          <span
                            class="material-symbols-outlined"
                            :class="{ liked: item.liked }"
                            @click.stop="toggleLike(item)"
                          >favorite</span>
                          <div>{{ item.fav }}</div>
                        </div>
                      </div>

                      <div class="card-box">
                        <div class="card-title">{{ item.packname }}</div>
                        <div class="card-cnt">
                          <span class="material-symbols-outlined">visibility</span>
                          <div>{{ item.cnt }}</div>
                        </div>
                      </div>

                      <div class="card-desc">{{ item.descript }}</div>

                      <div class="card-info">
                        💰 {{ Number(item.price).toLocaleString() }}원 <br />
                        👤 {{ item.userId }}
                      </div>

                      <div class="card-footer">
                        <button @click.stop="fnDetail(item.resNum)">상세보기</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="swiper-button-next review-button-next"></div>
            <div class="swiper-button-prev review-button-prev"></div>
          </div>

          <!-- 추천 게시글 -->
          <div style="margin-top:24px">
            <h2>추천 게시글</h2>
            <div class="bestCard-container">
              <div
                class="card"
                v-for="item in bestList"
                :key="item.resNum"
                @click="fnboardDetail(item.boardNo)"
              >
                <div class="card-body">
                  <div class="card-title">{{ item.title }}</div>
                  <div class="card-cnt">
                    <div class="card-info">👤 {{ item.userId }}</div>
                    <div style="display:flex">
                      <div style="display:flex; margin-right:20px">
                        <span class="material-symbols-outlined">thumb_up</span>
                        <div>{{ item.fav }}</div>
                      </div>
                      <div style="display:flex">
                        <span class="material-symbols-outlined">visibility</span>
                        <div>{{ item.cnt }}</div>
                      </div>
                      <div style="display:flex; margin-left:20px">
                        <span class="material-symbols-outlined liked" @click.stop="toggleLike(item)">favorite</span>
                        <div>{{ item.fav }}</div>
                      </div>
                    </div>
                  </div>
                  <div class="card-desc">{{ item.contents }}</div>
                </div>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>

    <%@ include file="components/footer.jsp" %>

    <!-- ================================
         ✅ Vue / Kakao JS
    ================================= -->
    <script>
      const app = Vue.createApp({
        data(){
          return {
            map:null,
            ps:null,
            placeOverlay:null,
            contentNode:null,
            markers:[],
            currCategory:"",
            roadview:null,
            roadviewClient:null,
            lastClickedLatLng:null,
            // 리스트
            userId: "${sessionId}",
            list:[],
            bestList:[],
            liked:false,
            thumbnailMap:{},
            page:1,
            pageSize:6,
            randomImages:[
              "/img/defaultImg01.jpg",
              "/img/defaultImg02.jpg",
              "/img/defaultImg03.jpg",
              "/img/defaultImg04.jpg",
              "/img/defaultImg05.jpg",
              "/img/defaultImg06.jpg",
            ],
          }
        },
        methods:{
          // 초기화
          init(){
            let self = this;
            kakao.maps.load(()=>{
              self.initMap();
              self.initCategory();
              self.initRoadview();
            });
            self.$nextTick(()=> self.initSwiper());
          },

          // 지도 초기화
          initMap(){
            let self = this;
            const mapContainer = document.getElementById("map");
            const mapOption = {
              center: new kakao.maps.LatLng(37.566826, 126.9786567),
              level: 5,
            };
            self.map = new kakao.maps.Map(mapContainer, mapOption);
            self.ps = new kakao.maps.services.Places(self.map);
            self.placeOverlay = new kakao.maps.CustomOverlay({ zIndex: 1 });
            self.contentNode = document.createElement("div");
            self.placeOverlay.setContent(self.contentNode);
            kakao.maps.event.addListener(self.map, "idle", ()=> self.searchPlaces());

            // 주소 → 좌표 변환 후 "내 위치" 커스텀 마커 + 말풍선
            let geocoder = new kakao.maps.services.Geocoder();
            geocoder.addressSearch("인천광역시 부평구 부평1동 534-48", function (result, status) {
              if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                // 1) 커스텀 SVG 핀
                const svgPin = `
                  <svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 36 36">
                    <defs>
                      <linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stop-color="#0ea5e9"/>
                        <stop offset="100%" stop-color="#0284c7"/>
                      </linearGradient>
                    </defs>
                    <path class="my-location-marker-shadow"
                      d="M18 2c-6.1 0-11 4.86-11 10.86 0 7.67 9.47 18.6 10.16 19.39a1.15 1.15 0 0 0 1.68 0C19.53 31.46 29 20.53 29 12.86 29 6.86 24.1 2 18 2z"
                      fill="url(#g)"/>
                    <circle cx="18" cy="13" r="4.6" fill="#fff"/>
                  </svg>`;
                const markerImage = new kakao.maps.MarkerImage(
                  'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(svgPin),
                  new kakao.maps.Size(36,36),
                  { offset: new kakao.maps.Point(18,36) }
                );
                var marker = new kakao.maps.Marker({
                  map: self.map,
                  position: coords,
                  image: markerImage
                });

                // 2) 펄스 도트 오버레이
                const pulseEl = document.createElement('div');
                pulseEl.className = 'pulse-dot';
                var pulseOverlay = new kakao.maps.CustomOverlay({
                  position: coords,
                  content: pulseEl,
                  yAnchor: 1.05
                });
                pulseOverlay.setMap(self.map);

                // 3) 카드형 말풍선
                const roadAddr = (result[0].road_address && result[0].road_address.address_name) || "";
                const jibunAddr = (result[0].address && result[0].address.address_name) || "";
                const addrText = roadAddr || jibunAddr || "좌표 기반 위치";

                const iwHtml = `
                  <div class="my-location-badge">
                    <div class="title">내 위치</div>
                    <div class="addr">${addrText}</div>
                    <div class="hint">지도를 클릭하면 그 위치로 이동합니다.</div>
                    <div class="actions">
                    </div>
                  </div>
                `;
                var infowindow = new kakao.maps.InfoWindow({
                  content: iwHtml,
                  removable: true
                });
                infowindow.open(self.map, marker);

                // InfoWindow DOM 준비 후 버튼 이벤트
                kakao.maps.event.addListener(infowindow, 'domready', function(){
                  const btnRecenter = document.getElementById('btnRecenter');
                  const btnCloseIw = document.getElementById('btnCloseIw');
                  if(btnRecenter){
                    btnRecenter.onclick = function(){
                      self.map.panTo(coords);
                      setTimeout(()=> self.map.setLevel(4), 250);
                    }
                  }
                  if(btnCloseIw){
                    btnCloseIw.onclick = function(){ infowindow.close(); }
                  }
                });

                kakao.maps.event.addListener(marker, 'click', function(){
                  infowindow.open(self.map, marker);
                });

                self.map.setCenter(coords);
              }
            });
          },

          // 카테고리 기능
          initCategory(){
            let self = this;
            const items = document.querySelectorAll("#category li");
            items.forEach((item) => {
              item.addEventListener("click", () => {
                if (item.classList.contains("on")) {
                  item.classList.remove("on");
                  self.currCategory = "";
                  self.removeMarker();
                  return;
                }
                items.forEach((el) => el.classList.remove("on"));
                item.classList.add("on");
                self.currCategory = item.id;
                self.searchPlaces();
              });
            });
          },

          // 장소 검색
          searchPlaces(){
            let self = this;
            if (!self.currCategory || !self.ps) return;
            self.placeOverlay.setMap(null);
            self.removeMarker();
            self.ps.categorySearch(
              self.currCategory,
              (data, status) => {
                if (status !== kakao.maps.services.Status.OK) return;
                data.forEach((place) => self.displayMarker(place));
              },
              { useMapBounds: true }
            );
          },

          displayMarker(place){
            let self = this;
            const marker = new kakao.maps.Marker({
              map: self.map,
              position: new kakao.maps.LatLng(place.y, place.x),
            });
            self.markers.push(marker);
            kakao.maps.event.addListener(marker, "click", () => {
              const content = `<div style="padding:6px 8px;font-size:12px;white-space:nowrap;">${place.place_name}</div>`;
              self.contentNode.innerHTML = content;
              self.placeOverlay.setPosition(new kakao.maps.LatLng(place.y, place.x));
              self.placeOverlay.setMap(self.map);
            });
          },

          removeMarker(){
            let self = this;
            self.markers.forEach((m)=> m.setMap(null));
            self.markers = [];
          },

          // 로드뷰
          initRoadview(){
            let self = this;
            const mapContainer = document.getElementById("map");
            const roadviewContainer = document.getElementById("roadview");
            const roadviewBtn = document.getElementById("roadviewBtn");
            const exitRoadviewBtn = document.getElementById("exitRoadviewBtn");
            self.roadview = new kakao.maps.Roadview(roadviewContainer);
            self.roadviewClient = new kakao.maps.RoadviewClient();

            kakao.maps.event.addListener(self.map, "click", function (mouseEvent) {
              self.lastClickedLatLng = mouseEvent.latLng;
              self.map.panTo(self.lastClickedLatLng);
              self.removeMarker();
              const marker = new kakao.maps.Marker({ position: self.lastClickedLatLng, map: self.map });
              self.markers.push(marker);
              roadviewBtn.style.display = "block";
            });

            roadviewBtn.addEventListener("click", function () {
              if (!self.lastClickedLatLng) return;
              self.roadviewClient.getNearestPanoId(self.lastClickedLatLng, 50, function (panoId) {
                if (panoId) {
                  mapContainer.style.display = "none";
                  roadviewContainer.style.display = "block";
                  roadviewBtn.style.display = "none";
                  exitRoadviewBtn.style.display = "block";
                  self.roadview.setPanoId(panoId, self.lastClickedLatLng);
                }
              });
            });
            exitRoadviewBtn.addEventListener("click", function () {
              roadviewContainer.style.display = "none";
              mapContainer.style.display = "block";
              roadviewBtn.style.display = "none";
              exitRoadviewBtn.style.display = "none";
            });
          },

          // Swiper
          initSwiper(){
            let self = this;
            if (!self.reviewSwiper) {
              self.reviewSwiper = new Swiper(".review-slider", {
                loop: true,
                autoplay: { delay: 4000, disableOnInteraction: false },
                slidesPerView: 3,
                spaceBetween: 20,
                navigation: {
                  nextEl: ".swiper-button-next",
                  prevEl: ".swiper-button-prev",
                },
                breakpoints: {
                  640: { slidesPerView: 1 },
                  1024: { slidesPerView: 2 },
                  1440: { slidesPerView: 3 },
                },
              });
            }
          },

          // 데이터
          fnResList(){
            let self = this;
            $.ajax({
              url: "/review-list.dox",
              dataType: "json",
              type: "POST",
              data: { userId: self.userId, pageSize: self.pageSize, page: (self.page - 1) * self.pageSize },
              success: function (data) { self.list = data.list; },
            });
          },
          fnBestList(){
            let self = this;
            $.ajax({
              url: "/bestList.dox",
              dataType: "json",
              type: "POST",
              data: { userId: self.userId, pageSize: self.pageSize, page: (self.page - 1) * self.pageSize },
              success: function (data) { self.bestList = data.list; },
            });
          },
          fnThumnail(){
            let self = this;
            $.ajax({
              url: "/thumbnail.dox",
              dataType: "json",
              type: "GET",
              success: function (data) { self.thumbnailMap = data.list; },
            });
          },

          fnDetail(resNum){ pageChange("review-view.do", { resNum }); },
          fnboardDetail(boardNo){ pageChange("board-view.do", { boardNo }); },

          toggleLike(item){
            let self = this;
            const param = { userId: self.userId, boardNo: item.boardNo };
            $.ajax({
              url: "review-favorite.dox",
              dataType: "json",
              type: "POST",
              data: param,
              success: function (data) {
                item.liked = data.liked;
                self.fnResList();
              },
            });
          },

          getRandomImage(){
            if (!this.shuffled) this.shuffled = [...this.randomImages].sort(()=> Math.random() - 0.5);
            if (this.shuffled.length === 0) this.shuffled = [...this.randomImages].sort(()=> Math.random() - 0.5);
            return this.shuffled.pop();
          },
        },

        mounted(){
          let self = this;

          const queryParams = new URLSearchParams(window.location.search);
          window.code = queryParams.get('code') || '';
          if (window.code != null) { fnKakao && fnKakao(); }

          self.init();
          self.fnResList();
          self.fnThumnail();
          self.fnBestList();

          window.addEventListener("popstate", () => {
            self.fnResList(); self.fnThumnail(); self.fnBestList();
          });
          window.addEventListener("pageshow", (event) => {
            if (event.persisted) {
              self.fnResList(); self.fnThumnail(); self.fnBestList();
            }
          });
        },
      });
      app.mount("#app");
    </script>
  </body>
</html>
