<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>강릉 여행 일정</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link
    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
    rel="stylesheet"
/>
<script type="text/javascript"
          src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services"></script>
 <link rel="stylesheet" href="/css/main-style.css">
<link rel="stylesheet" href="/css/common-style.css">
<link rel="stylesheet" href="/css/header-style.css">
<link rel="stylesheet" href="/css/main-images.css">


<style>
body {
  background: #f3f7ff;
  font-family: "Pretendard", sans-serif;
  margin: 0;
}
.create-btn {
  background-color: #1565c0;
  color: white;
  border: none;
  border-radius: 10px;
  padding: 10px 18px;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  transition: 0.3s;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

/* 뒤로가기 버튼 */
.back {
    background: none;
    border: none;
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 16px;
    cursor: pointer;
    transition: 0.3s;
}
.material-symbols-outlined {
    font-size: 32px;
    vertical-align: middle;
}
.create-btn:hover {
  background-color: #0d47a1;
  transform: translateY(-2px);
}
.main-con{
  width: 80%;
  margin: 0 auto;
}
.day-num {
  font-size: 20px;
  font-weight: 700;
  color: #0d47a1;
  margin-bottom: 15px;
  border-left: 4px solid #1565c0;
  padding-left: 8px;
}

.day-item-con {
  display: flex;
  border-radius: 16px;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  overflow: hidden;
  transition: 0.3s;
  margin-bottom: 20px;
  cursor: pointer;
}
.day-item-con:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(0,0,0,0.2);
}

.day-item-con img {
  width: 280px;
  height: 200px;
  padding: 20px;
  object-fit: cover;
}

.item-md {
  flex: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.item-title {
  font-size: 20px;
  font-weight: 600;
  color: #222;
}

.item-addr {
  font-size: 14px;
  color: #666;
  margin-bottom: 12px;
}

.item-overview {
  font-size: 15px;
  color: #444;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  display: -webkit-box;
  margin-bottom: 15px;
}

.review-btn {
  align-self: flex-start;
  background-color: #1976d2;
  color: white;
  border: none;
  border-radius: 8px;
  padding: 8px 16px;
  font-weight: 600;
  transition: 0.3s;
}
.review-btn:hover {
  background-color: #0d47a1;
}

/* === 모달 === */
.modal-overlay {
  position: fixed;
  top: 0; left: 0;
  width:100%; height:100%;
  background: rgba(0,0,0,0.6);
  display:flex; align-items:center; justify-content:center;
  z-index:999;
}
.modal {
  background:white;
  border-radius:15px;
  width:600px;
  max-height:90vh;
  overflow-y:auto;
  padding:25px;
  box-shadow:0 4px 20px rgba(0,0,0,0.3);
  animation:fadeIn 0.3s ease;
}
@keyframes fadeIn {
  from {opacity:0; transform:translateY(-10px);}
  to {opacity:1; transform:translateY(0);}
}

.modal img {
  width:100%;
  height:260px;
  border-radius:10px;
  object-fit:cover;
  margin-bottom:15px;
}

.star-rating {
  display:flex;
  align-items:center;
  gap:4px;
  font-size:30px;
  color:#ffca28;
  cursor:pointer;
  margin-bottom:8px;
}
.modal textarea {
  width:100%;
  height:100px;
  border-radius:8px;
  border:1px solid #ccc;
  padding:10px;
  resize:none;
}
.modal-footer {
  text-align:right;
  margin-top:10px;
}
.modal-footer button {
  border:none;
  border-radius:8px;
  padding:8px 16px;
  margin-left:8px;
}
.btn-cancel {
  background:#ccc;
}
.btn-submit {
  background:#1976d2;
  color:white;
}
.tab-btn {
  background: #e3f2fd;
  color: #1565c0;
  border: none;
  padding: 10px 20px;
  margin: 0 6px;
  border-radius: 20px;
  cursor: pointer;
  font-weight: 600;
  transition: 0.3s;
}
.tab-btn:hover {
  background: #bbdefb;
}
.tab-btn.active {
  background: #1565c0;
  color: white;
}

</style>
</head>
<body>
      <%@ include file="components/header.jsp" %>
<div id="app">
  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; width: 80%; margin: 0 auto;">
    <div class="back-btn">
        <button class="back" @click="fnbck">
            <span class="material-symbols-outlined">arrow_back</span>
            뒤로가기
        </button>
    </div>
    <h2 style="margin:0;">📅 여행 일정</h2>
    <button class="create-btn" @click="fnWrite">게시글 등록하기</button>
  </div>

  <p style="text-align:center; color:#555; margin-bottom:25px;">
    방문한 장소에 대한 소중한 후기를 남겨주세요
  </p>

  <!-- ✅ 탭 -->
  <div style="display:flex; justify-content:center; margin-bottom:20px;">
    <button 
      v-for="(list, day) in positionsByDay" 
      :key="day" 
      @click="selectedDay = day"
      :class="['tab-btn', { active: selectedDay == day }]">
      {{ day }}일차 ({{ list.length }}곳)
    </button>
  </div>


  <!-- ✅ 일차별 리스트 -->
  <div v-if="positionsByDay[selectedDay]" class="main-con">
    <div class="day-num">{{ selectedDay }}일차 - {{ positionsByDay[selectedDay][0].day }}</div>

    <div v-for="item in positionsByDay[selectedDay]" :key="item.title" class="day-item-con" @click="openModal(item)">
      <img :src="item.firstimage || getRandomImage()" alt="이미지">
      <div class="item-md">
        <div>
          <div class="item-title">{{ item.title }}</div>
          <div class="item-addr">📍 {{ item.addr1 }}</div>
          <div class="item-overview">{{ item.overview }}</div>
          <div class="star-rating">
            <span v-for="i in 5" :key="i" class="material-icons">
              {{ getStarIcon(i, item.rating) }}
            </span>
          </div>
        </div>
        <button class="review-btn">후기 작성하기</button>
      </div>
    </div>
  </div>

  <!-- ✅ 후기 모달 -->
  <div v-if="modalFlg" class="modal-overlay" @click.self="closeModal">
    <div class="modal">
      <img :src="selectedItem.firstimage || getRandomImage()">
      <h3>{{ selectedItem.title }}</h3>
      <p style="margin-bottom:15px;">{{ selectedItem.overview }}</p>
      <h4>평점을 선택해주세요</h4>

      <div class="star-rating">
        <span v-for="i in 5" :key="i" class="material-icons"
          @click="setRating(i)">
          {{ getStarIcon(i, rating) }}
        </span>
      </div>
      <p>선택된 평점: {{ rating }}점</p>

      <h4>후기를 작성해주세요</h4>
      <textarea v-model="reviewText" maxlength="500" placeholder="방문 경험을 공유해주세요..."></textarea>
      <input type="file" id="file1" name="file1" multiple>
      <div style="font-size:12px; color:gray;">{{ reviewText.length }}/500자</div>

      <div class="modal-footer">
        <button class="btn-cancel" @click="closeModal">취소</button>
        <button class="btn-submit" @click="submitReview">후기 등록</button>
      </div>
    </div>
  </div>
</div>

<%@ include file="components/footer.jsp" %>

<!-- ✅ JSON 데이터를 안전하게 주입 -->


<script>
const app = Vue.createApp({
  data() {
    return {
      userId: "${sessionId}",
      resNum: "${resNum}",
      info: [],
      positionsByDay: {},
      modalFlg: false,
      selectedItem: {},
      rating: 0,
      reviewText: "",
      selectedDay: 1,
      contentId: "",
      title: "",
      randomImages: [
        "/img/defaultImg01.jpg",
        "/img/defaultImg02.jpg",
        "/img/defaultImg03.jpg",
        "/img/defaultImg04.jpg",
        "/img/defaultImg05.jpg",
        "/img/defaultImg06.jpg"
      ],
      routePolyline: null,
      routeSummary: null,
      markers: [],
      poiList: [],
      kakaoAppKey: '${kakaoAppKey}'
    };
  },
  methods: {
    fninfo() {
      let self = this;
      $.ajax({
        url: '/share.dox',
        type: 'GET',
        data: { resNum: self.resNum },
        success: function(data) {
          self.info = data;
          const days = Object.keys(data).map(k => parseInt(k)).sort((a,b)=>a-b);
          for (let i = 0; i < days.length; i++) {
            const day = days[i];
            const dayList = data[day];
            self.positionsByDay[day] = [];
            for (let j = 0; j < dayList.length; j++) {
              const item = dayList[j];
              self.positionsByDay[day].push({
                title: item.title,
                lat: parseFloat(item.mapy),
                lng: parseFloat(item.mapx),
                overview: item.overview,
                dayNum: day,
                reserv_date: item.reserv_date,
                firstimage: item.firstimage,
                addr1: item.addr1,
                contentId: item.contentid,
                day: item.day,
                rating: item.rating,
              });
            }
          }
          self.selectedDay = days[0];
            const firstDayPois = self.positionsByDay[self.selectedDay];
            if (firstDayPois && firstDayPois.length > 0) {
                self.initializeMap(firstDayPois);
            }
        }
      });
    },
    upload(form) {
      $.ajax({
        url: "/review-fileUpload.dox",
        type: "POST",
        processData: false,
        contentType: false,
        data: form
      });
    },
    openModal(item) {
      this.selectedItem = item;
      this.modalFlg = true;
      this.contentId = item.contentId;
      this.rating = item.rating;
    },
    closeModal() {
      this.modalFlg = false;
      this.reviewText = "";
    },
    setRating(i) { this.rating = i; },
    getStarIcon(index, itemRating) {
      if (itemRating >= index) return "star";
      else if (itemRating >= index - 0.5) return "star_half";
      else return "star_border";
    },
    submitReview() {
      let self = this;
      let param = {
        rating: self.rating,
        content: self.reviewText,
        contentId: self.contentId,
        resNum: self.resNum
      };
      $.ajax({
        url: "/update-rating.dox",
        dataType: "json",
        type: "POST",
        data: param,
        success: function(data) {
          alert("후기작성완료되었습니다.");
          let form = new FormData();
          for (let i = 0; i < $("#file1")[0].files.length; i++) {
            form.append("file1", $("#file1")[0].files[i]);
          }
          form.append("contentId", data.contentId);
          form.append("userId", self.userId);
          form.append("title", self.selectedItem.title);
          self.upload(form);
          self.fninfo();
          if (self.selectedItem) self.selectedItem.rating = self.rating;
          self.closeModal();
        }
      });
    },
    fnWrite() {
      let self = this;
      if (!confirm("등록하시겠습니까?")) return;
      $.ajax({
        url: "/review-add.dox",
        dataType: "json",
        type: "POST",
        data: { resNum: self.resNum, userId: self.userId },
        success: function(data) {
          alert(data.msg);
          location.href = "review-list.do";
        }
      });
    },
    fnbck() { history.back(); },
    getRandomImage() {
      const index = Math.floor(Math.random() * this.randomImages.length);
      return this.randomImages[index];
    },
     initializeMap(pois) {
    if (!window.kakao || !kakao.maps) {
        document.getElementById('map-container').innerText = 'Kakao Map API 로드 실패.';
        return;
    }
    const container = document.getElementById('map-container');

    if (!pois || pois.length === 0) {
        container.innerText = "지도에 표시할 장소가 없습니다.";
        return;
    }

    const options = { 
        center: new kakao.maps.LatLng(pois[0].lat, pois[0].lng), 
        level: 7 
    };
    this.map = new kakao.maps.Map(container, options);

    const bounds = new kakao.maps.LatLngBounds();
    this.clearMarkers();

    pois.forEach(p => {
        const pos = new kakao.maps.LatLng(p.lat, p.lng);
        const marker = new kakao.maps.Marker({ position: pos });
        marker.setMap(this.map);
        this.markers.push(marker);
      console.log(p.title);
      
        const info = new kakao.maps.InfoWindow({ content: '<div style="padding:25px;">' + (p.title || p.contentId) + '</div>' });
        kakao.maps.event.addListener(marker, 'mouseover', () => info.open(this.map, marker));
        kakao.maps.event.addListener(marker, 'mouseout', () => info.close());

        bounds.extend(pos);
    });

    this.map.setBounds(bounds);

    // Vue 렌더링 후 지도 리사이즈
    setTimeout(() => {
        kakao.maps.event.trigger(this.map, 'resize');
        this.map.setBounds(bounds);
    }, 500);
},
         clearMarkers() { if (!this.markers) return; this.markers.forEach(m => m.setMap(null)); this.markers = []; },
    groupPoisByDate(pois) {
      this.positionsByDay = {};
      pois.forEach(p => {
        const day = p.day || 1;
        if (!this.positionsByDay[day]) this.positionsByDay[day] = [];
        this.positionsByDay[day].push(p);
      });
    },
    async buildCarRoute() {
      const pois = this.positionsByDay[this.selectedDay] || [];
      const valid = pois.filter(p => p.lat && p.lng);
      if (valid.length < 2) {
        alert('경로를 그릴 최소 2개 지점이 필요합니다.');
        return;
      }
      try {
        const payload = {
          resNum: this.resNum,
          day: this.selectedDay,
          pois: valid.map(p => ({
            contentId: p.contentId,
            name: p.title || '',
            x: Number(p.lng),
            y: Number(p.lat)
          }))
        };
        const resp = await $.ajax({
          url: '/api/route/build',
          type: 'POST',
          contentType: 'application/json',
          data: JSON.stringify(payload)
        });
        if (resp.points) this.drawPolyline(resp.points);
        this.routeSummary = resp.summary || null;
      } catch (e) {
        console.error(e);
        alert('경로 계산에 실패했습니다.');
      }
    },
    drawPolyline(points) {
      if (!this.map) return;
      if (this.routePolyline) { this.routePolyline.setMap(null); this.routePolyline = null; }
      if (!points || points.length === 0) return;
      const path = points.map(pt => new kakao.maps.LatLng(pt.y, pt.x));
      this.routePolyline = new kakao.maps.Polyline({ path, strokeWeight: 5, strokeOpacity: 0.9 });
      this.routePolyline.setMap(this.map);
      const bounds = new kakao.maps.LatLngBounds();
      path.forEach(latlng => bounds.extend(latlng));
      this.map.setBounds(bounds);
    },
    clearRoute() { if (this.routePolyline) { this.routePolyline.setMap(null); this.routePolyline = null; } this.routeSummary = null; },
  },
  mounted() {
    let self=this;

    self.fninfo();
     const waitForKakao = setInterval(() => {
    if (window.kakao && window.kakao.maps) {
      clearInterval(waitForKakao);
      // ✅ DOM 안정화 후 지도 생성
      setTimeout(() => {
        this.initializeMap([{ lat: 37.7519, lng: 128.8760 }]);
      }, 500);
    }
  }, 200);
}
});

app.mount('#app');
</script>
</body>
</html>