<%-- /WEB-INF/reservation-view.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${reservation.packName} - 예약 상세</title>
    
    <%-- 카카오맵 SDK 로딩 --%>
    <script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=a777d1f63779cfdaa66c4a1d36cc578d&libraries=services"></script>
        
    <%-- Vue 및 jQuery 로딩 --%>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    
    <style>
        body { font-family: 'Malgun Gothic', sans-serif; padding: 20px; }
        .container { max-width: 1200px; margin: auto; }
        #map-display { width: 100%; height: 500px; margin-top: 20px; border: 1px solid #ccc; }
        .data-check { background: #f8f9fa; border: 1px solid #e9ecef; padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .poi-item { border-bottom: 1px dashed #dee2e6; padding: 10px 0; font-size: 0.95em; }
        .poi-item:last-child { border-bottom: none; }
    </style>
</head>
<body>

<div id="app" class="container">
    <h1>✅ 예약 상세 확인 (${reservation.packName})</h1>
    
    <div class="data-check">
        <h3>기본 예약 정보 확인</h3>
        <ul>
            <li>**예약 번호 (RES_NUM):** ${reservation.resNum}</li>
            <li>**패키지 명:** ${reservation.packName}</li>
            <li>**여행 기간:** ${reservation.startDate} ~ ${reservation.endDate}</li>
            <%-- fn:length 함수를 사용하여 안전하게 리스트 크기 확인 --%>
            <li>**총 POI 개수:** ${fn:length(reservation.pois)}개</li>
        </ul>
    </div>

    <h2>🗺️ 여행 경로 지도</h2>
    <div id="map-display"></div>
    
    <h2>📋 상세 일정 목록</h2>
    <div class="itinerary-list-view">
        <c:choose>
            <c:when test="${reservation.pois != null and not empty reservation.pois}">
                <c:forEach var="poi" items="${reservation.pois}" varStatus="status">
                    <div class="poi-item">
                        **[# ${status.count}]** ${poi.placeName} (Content ID: ${poi.contentId})
                        <br>
                        <span style="color: #6c757d;">
                            날짜: ${poi.reservDate} | 좌표 (Y/X): ${poi.mapY} / ${poi.mapX}
                        </span>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>일정 목록이 비어있습니다. POI 저장 로직을 확인해주세요.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- 1. JSTL을 사용하여 POI 목록을 JSON 문자열로 변환하여 변수에 저장 --%>
<c:set var="poiJsonString" value="${reservation.pois}" scope="request"/>

<%-- [필수] reservation-view-map.js 파일은 반드시 이 위치에 로드되어야 합니다. --%>
<script src="js/reservation-view-map.js"></script>

<script>
    // 2. JSP 변수를 JavaScript 변수로 안전하게 가져옵니다.
    // NOTE: Spring MVC가 객체를 자동으로 JSON으로 변환하여 문자열로 출력합니다.
    const poiItems = ${poiJsonString};
    
    // 3. Vue 인스턴스 생성 및 마운트
    const app = Vue.createApp({
        data() {
            return {
                poiItems: poiItems || [], // POI 목록을 Vue 데이터로 저장
                mapInstance: null,
                kakao: window.kakao 
            }
        },
        mounted() {
            if (this.poiItems.length > 0) {
                // 4. 지도 초기화 및 마커 표시 (reservation-view-map.js의 믹스인 함수 호출)
                this.initMapAndDrawMarkers();
            } else {
                console.warn("지도에 표시할 POI 데이터가 없습니다.");
            }
        }
    });

    // 맵 믹스인 주입 (reservation-view-map.js에서 정의된 믹스인 객체)
    app.mixin(window.ReservationViewMapMixin); 

    app.mount('#app');
</script>

</body>
</html>