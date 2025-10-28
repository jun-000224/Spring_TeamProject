<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=82a2d2e3883834b8a2b2cf1015b17f3e"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
            
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <div id="map" style="width:500px;height:400px;"></div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                positions : [
                    {
                        title: '경포해수욕장', 
                        latlng: new kakao.maps.LatLng(37.8058292968, 128.9074668585)
                    },
                    {
                        title: '안목해변', 
                        latlng: new kakao.maps.LatLng(37.7726505813, 128.9473504054)
                    },
                    {
                        title: '강릉 중앙시장', 
                        latlng: new kakao.maps.LatLng(37.7540517822, 128.8986609221)
                    }
                ],
                linePath : [
                    new kakao.maps.LatLng(37.8058292968, 128.9074668585),
                    new kakao.maps.LatLng(37.7726505813, 128.9473504054),
                    new kakao.maps.LatLng(37.7540517822, 128.8986609221) 
                ]
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
            var options = { //지도를 생성할 때 필요한 기본 옵션
	            center: new kakao.maps.LatLng(37.8058292968, 128.9074668585), //지도의 중심좌표.
	            level: 3 //지도의 레벨(확대, 축소 정도)
            };

            var map = new kakao.maps.Map(container, options);
            var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 

            for (var i = 0; i < self.positions.length; i ++) {
    
                // 마커 이미지의 이미지 크기 입니다
                var imageSize = new kakao.maps.Size(24, 35); 
                
                // 마커 이미지를 생성합니다    
                var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
                
                // 마커를 생성합니다
                var marker = new kakao.maps.Marker({
                    map: map, // 마커를 표시할 지도
                    position: self.positions[i].latlng, // 마커를 표시할 위치
                    title : self.positions[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
                    image : markerImage // 마커 이미지 
                });

            }

            var polyline = new kakao.maps.Polyline({
                path: self.linePath, // 선을 구성하는 좌표배열 입니다
                strokeWeight: 3, // 선의 두께 입니다
                strokeColor: 'black', // 선의 색깔입니다
                strokeOpacity: 1, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                strokeStyle: 'dashed' // 선의 스타일입니다
            });
            polyline.setMap(map);  
       }
    });


    app.mount('#app');
</script>