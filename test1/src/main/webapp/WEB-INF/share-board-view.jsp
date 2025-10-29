<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kakao Map 거리 표시</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=82a2d2e3883834b8a2b2cf1015b17f3e"></script>
<style>
    #map { width: 600px; height: 400px; }
    ul{
        padding: 0px;
        margin: 0px;
    }
    ul li{
        list-style: none;
    }
</style>
</head>
<body>
<div id="app">
    <div style="display: flex;">
        <div>
            <div>
                <span>1일차</span>
            </div>
            <div>
                <span>10월28일</span>
            </div>
            <div>
                <span>선택한 카테고리</span>
            </div>
            <ul v-for="item in positions">
                <li> 
                    <a href="javascript:;" @click="fnMove(item)">
                        {{item.title}}
                    </a> 
                </li>
            </ul>
        </div>
        <div id="map"></div>
    </div>
    <div>
        <div>
            <button>1일차</button>
        </div>
        <div>
            <ul v-for="item in positions">
                <!-- <li><img :src="info.firstimage" alt="" style="width: 200px;"></li> -->
                <li>{{item.title}}</li>
                <!-- <li>{{info.addr1}}</li>
                <li>{{info.overview}}</li> -->
            </ul>
        </div>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            positions: [
                { title: '경포해수욕장', lat: 37.8058292968, lng: 128.9074668585 ,contentid:128758},
                { title: '안목해변', lat: 37.7726505813, lng: 128.9473504054 ,contentid:128758},
                { title: '강릉 중앙시장', lat: 37.7540517822, lng: 128.8986609221 ,contentid:128758}
            ],
            container : "",
            options : {
            center: new kakao.maps.LatLng(37.785, 128.92),
            level: 8
            },
            map :"",
            info:{}
        };
    },
    methods: {
        deg2rad(deg) {
            return deg * (Math.PI / 180);
        },
        getDistance(lat1, lng1, lat2, lng2) {
            const R = 6371; // km
            const dLat = this.deg2rad(lat2 - lat1);
            const dLng = this.deg2rad(lng2 - lng1);
            const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                      Math.cos(this.deg2rad(lat1)) * Math.cos(this.deg2rad(lat2)) *
                      Math.sin(dLng/2) * Math.sin(dLng/2);
            const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
            return R * c;
        },
        fnMove(item){
            let self = this;
            var moveLatLon = new kakao.maps.LatLng(item.lat, item.lng);
            self.map.setCenter(moveLatLon);    
            let param = {};
            $.ajax({
                url: '/share.dox',
                type: 'GET',
                // data: { keyword: item.contentid },
                 data: { param },
                success: function(data){
                    console.log(data);
                    self.info = data[0];
                    console.log(self.info);
                    
                }
            });
            
        },
        
    },
    mounted() {
        const self = this;

        // 지도 생성
        self.container = document.getElementById('map');
        self.map = new kakao.maps.Map(self.container, self.options);
        // 마커 생성
        const imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";
        for (let i = 0; i < self.positions.length; i++) {
            const imageSize = new kakao.maps.Size(24, 35);
            const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
            new kakao.maps.Marker({
                map: self.map,
                position: new kakao.maps.LatLng(self.positions[i].lat, self.positions[i].lng),
                title: self.positions[i].title,
                image: markerImage
            });
        }

        // Polyline 생성
        const linePath = self.positions.map(p => new kakao.maps.LatLng(p.lat, p.lng));
        const polyline = new kakao.maps.Polyline({
            path: linePath,
            strokeWeight: 3,
            strokeColor: 'black',
            strokeOpacity: 1,
            strokeStyle: 'dashed'
        });
        polyline.setMap(self.map);

        // 각 선의 중간에 거리 표시
        for (let i = 0; i < self.positions.length - 1; i++) {
            const p1 = self.positions[i];
            const p2 = self.positions[i + 1];

            // 중간 좌표 계산
            const midLat = (p1.lat + p2.lat) / 2;
            const midLng = (p1.lng + p2.lng) / 2;
            
            const distance = self.getDistance(p1.lat, p1.lng, p2.lat, p2.lng);
            const distanceStr = distance.toFixed(2);
            const overlay = new kakao.maps.CustomOverlay({
                map: self.map,
                position: new kakao.maps.LatLng(midLat, midLng),
                content: '<div style="padding:2px 5px; background:yellow; border:1px solid black; font-size:12px;">' + distanceStr + ' km</div>'
            });
        }
    }
});

app.mount('#app');
</script>
</body>
</html>
