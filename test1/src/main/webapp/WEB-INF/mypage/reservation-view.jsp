<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8" />
                <title>예약 확인</title>
                <meta name="viewport" content="width=device-width,initial-scale=1" />
                <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
                <script type="text/javascript"
                    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services,drawing"></script>

                <link rel="stylesheet" href="<%= request.getContextPath() %>/css/common-style.css">
                <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header-style.css">

                <style>
                    .container-view {
                        display: flex;
                        max-width: 1200px;
                        margin: 20px auto;
                        padding: 0 15px;
                        gap: 20px;
                    }

                    .list-panel {
                        flex: 1;
                        padding: 20px;
                        border: 1px solid #ddd;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                    }

                    .map-panel {
                        flex: 2;
                        height: 700px;
                        border: 1px solid #ddd;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                    }

                    .itinerary-day {
                        margin-bottom: 25px;
                        padding: 15px;
                        border-bottom: 2px solid #eee;
                    }

                    .itinerary-day h4 {
                        color: #1e40af;
                        margin-top: 0;
                        border-left: 4px solid #3b82f6;
                        padding-left: 10px;
                    }

                    .itinerary-item {
                        padding: 8px 0;
                        border-bottom: 1px dotted #eee;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .item-info {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        font-size: 1.1em;
                    }

                    .item-price {
                        color: #d9480f;
                        font-weight: bold;
                    }

                    .map-icon {
                        width: 24px;
                        height: 24px;
                        text-align: center;
                        line-height: 24px;
                        background: #3b82f6;
                        color: white;
                        border-radius: 50%;
                        font-size: 0.9em;
                        font-weight: bold;
                    }
                </style>
            </head>

            <body>
                <%@ include file="components/header.jsp" %>
                    <div class="wrap">
                        <h1 class="page-title">여행 코스 (${tripId}번) 확인</h1>

                        <div class="container-view">

                            <div class="list-panel">
                                <c:forEach items="${itinerary}" var="entry">
                                    <div class="itinerary-day" data-day="${entry.key}">
                                        <h4>${entry.key}일차 일정</h4>

                                        <c:forEach items="${entry.value}" var="item">
                                            <div class="itinerary-item" data-mapx="${item.mapX}"
                                                data-mapy="${item.mapY}" data-name="${item.placeName}">
                                                <div class="item-info">
                                                    <span class="map-icon">${item.orderNumber}</span>
                                                    <span>${item.placeName}</span>
                                                </div>
                                                <span class="item-price">${item.price.toLocaleString()}원</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                            </div>

                            <div id="map-route-view" class="map-panel"></div>
                        </div>
                    </div>

                    <script>
                        const ROUTE_COORDS = ${ routeCoordinates != null ? routeCoordinates : '[]'};
                        let map;
                        let markers = [];
                        let polyline;

                        function initMap() {
                            if (!window.kakao || !window.kakao.maps) {
                                console.error("카카오맵 SDK 로딩 실패.");
                                return;
                            }

                            // 지도 초기 설정 (경로의 중심점으로 설정하는 것이 좋으나, 여기서는 서울로 임시 설정)
                            const mapContainer = document.getElementById('map-route-view');
                            const mapOption = {
                                center: new kakao.maps.LatLng(37.566826, 126.9786567),
                                level: 8
                            };
                            map = new kakao.maps.Map(mapContainer, mapOption);

                            if (ROUTE_COORDS.length > 0) {
                                drawRoute();
                                // 맵 중심을 첫 POI로 이동
                                const firstCoord = ROUTE_COORDS[0].split(',');
                                map.setCenter(new kakao.maps.LatLng(firstCoord[0], firstCoord[1]));
                                map.setLevel(7);
                            }
                        }

                        // 경로와 마커를 그리는 함수
                        function drawRoute() {
                            let path = [];

                            // 1. 마커 표시 및 경로 좌표 추출
                            $('.itinerary-day[data-day="1"] .itinerary-item').each(function (index) {
                                const mapy = $(this).data('mapy');
                                const mapx = $(this).data('mapx');
                                const name = $(this).data('name');
                                const position = new kakao.maps.LatLng(mapy, mapx);
                                path.push(position);

                                // 마커 이미지 설정
                                const imageSize = new kakao.maps.Size(30, 30);
                                const markerImage = new kakao.maps.MarkerImage(
                                    'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_shape.png',
                                    imageSize,
                                    { offset: new kakao.maps.Point(15, 15), spriteOrigin: new kakao.maps.Point(0, (index) * 46), spriteSize: new kakao.maps.Size(36, 986) }
                                );

                                const marker = new kakao.maps.Marker({
                                    map: map,
                                    position: position,
                                    image: markerImage,
                                    title: name
                                });
                                markers.push(marker);
                            });

                            // 2. 경로 선 그리기
                            if (path.length > 1) {
                                // 이 부분에서 실제 경로 API (T맵, 네이버 등)를 호출하여 받은 복잡한 경로 데이터를 그려야 하지만, 
                                // 지금은 경유지 간의 단순 직선 경로만 그립니다.
                                polyline = new kakao.maps.Polyline({
                                    path: path,
                                    strokeWeight: 5,
                                    strokeColor: '#3b82f6',
                                    strokeOpacity: 0.7,
                                    strokeStyle: 'solid'
                                });
                                polyline.setMap(map);
                            }
                        }

                        kakao.maps.event.addDomListener(window, 'load', initMap);

                    </script>

                    <%@ include file="components/footer.jsp" %>
            </body>

            </html>