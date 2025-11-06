<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 상세 확인</title>
    <style>
        .poi-item {
            border-bottom: 1px dashed #eee;
            padding: 5px 0;
        }
    </style>
</head>
<body>

    <h1>✅ 예약 상세 확인 (${reservation.resNum})</h1>
    
    <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 20px;">
        <h3>기본 예약 정보 확인</h3>
        <ul>
            <li>**예약 번호 (RES_NUM):** ${reservation.resNum}</li>
            <li>**패키지 명:** ${reservation.packName}</li>
            <li>**총 가격:** ${reservation.price}원</li>
            <li>**여행 기간:** ${reservation.startDate} ~ ${reservation.endDate}</li>
            <li>**총 POI 개수:** ${reservation.pois.size()}개</li>
            <li>**테마:** ${reservation.themNum}</li>
        </ul>
    </div>
    
    <hr>
    
    <h2>🗺️ 여행 경로 지도</h2>
    <div id="map-container" style="width:100%; height:400px; border: 1px solid #ddd;">지도 로딩 중...</div>

    <hr>

    <h2>📋 상세 일정 목록</h2>
    <div id="detail-schedule-list">
        <p>상세 일정 로딩 중...</p>
    </div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript" src="http://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoAppKey}&libraries=services"></script> 

<script>
$(document).ready(function() {
    const rawPoiList = JSON.parse('<c:out value="${poiListJson}" escapeXml="false"/>'); 
    
    const poiList = rawPoiList.filter(poi => 
        poi.contentId && !isNaN(poi.contentId) && poi.contentId > 0
    );

    const $detailList = $('#detail-schedule-list').empty(); 
    
    let map = null;
    const totalPois = poiList.length;

    if (totalPois === 0) {
        $detailList.append('<p>유효한 POI 일정이 없습니다.</p>');
        $('#map-container').text('좌표 정보가 없어 지도를 표시할 수 없습니다.');
        return;
    }

    // ----------------------------------------------------
    // 1. [즉시 실행] 지도 마커 생성 (DB에서 좌표를 가져옴)
    // ----------------------------------------------------
    
    const validMapPois = poiList.filter(poi => 
        poi.mapY != null && poi.mapX != null && 
        !isNaN(poi.mapY) && !isNaN(poi.mapX)
    );

    if (validMapPois.length > 0) {
        initializeMap(validMapPois); 
    } else {
        $('#map-container').text('DB에 저장된 좌표 정보가 없습니다. (새로운 일정으로 테스트 필요)');
    }

    // ----------------------------------------------------
    // 2. [비동기 실행] 장소 이름(placeName)만 API로 조회
    // ----------------------------------------------------
    
    poiList.forEach((poi, index) => {
        updatePoiElement(index + 1, poi.reservDate, `(ID: ${poi.contentId} 로딩 중...)`, poi.contentId, poi.mapY, poi.mapX);
    });

    poiList.forEach((poi) => {
        const contentIdStr = String(poi.contentId);
        
        $.get(`/api/reservation/poi-details?contentId=${contentIdStr}`, function(data) {
            const placeName = data.placeName || "이름 정보 없음";
            $(`#poi-name-${poi.contentId}`).text(placeName); 
            
        }).fail(function(jqXHR) {
            let errorMessage = (jqXHR.status === 404) ? 'POI 상세 정보 없음' : 'API 오류';
            $(`#poi-name-${poi.contentId}`).text(errorMessage);
        });
    });

    // ----------------------------------------------------
    // HTML 요소 업데이트 함수
    // ----------------------------------------------------
    function updatePoiElement(index, date, placeName, contentId, mapY, mapX) {
        const $element = $(`
            <div class="poi-item" style="margin-bottom: 10px;">
                <p>**[# ${index}]** <strong id="poi-name-${contentId}">${placeName}</strong> (Content ID: ${contentId})</p>
                <p>날짜: ${date} | 좌표 (Y/X): ${mapY || '없음'} / ${mapX || '없음'}</p>
            </div>
        `);
        $detailList.append($element);
    }
    
    // ----------------------------------------------------
    // 지도 초기화 및 마커 표시 함수
    // ----------------------------------------------------
    function initializeMap(markerData) {
        if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
            console.error("Kakao Map API 로드 실패.");
            $('#map-container').text('Kakao Map API 로드 실패.');
            return;
        }

        const container = document.getElementById('map-container'); 
        const options = {
            center: new kakao.maps.LatLng(markerData[0].mapY, markerData[0].mapX), 
            level: 7
        };
        
        map = new kakao.maps.Map(container, options);
        
        markerData.forEach(function(poi) {
            const markerPosition = new kakao.maps.LatLng(poi.mapY, poi.mapX); 
            const marker = new kakao.maps.Marker({
                position: markerPosition
            });
            marker.setMap(map);

            const infowindow = new kakao.maps.InfoWindow({
                content: `<div style="padding:5px;">${poi.placeName || poi.contentId}</div>` 
            });
            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });
        });
        
        const bounds = new kakao.maps.LatLngBounds();
        markerData.forEach(m => bounds.extend(new kakao.maps.LatLng(m.mapY, m.mapX)));
        map.setBounds(bounds);
        
    }
});
</script>

</body>
</html>