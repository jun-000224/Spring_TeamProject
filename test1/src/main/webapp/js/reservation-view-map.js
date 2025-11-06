/**
 * reservation-view-map.js
 * 예약 상세 페이지(reservation-view.jsp)의 지도 로직을 위한 Vue Mixin
 */
window.ReservationViewMapMixin = {
    methods: {
        initMapAndDrawMarkers() {
            const container = document.getElementById('map-display');
            if (!container) return console.error("Map container not found.");

            const kakao = this.kakao;
            if (!kakao) return console.error("Kakao Map SDK not loaded. Check JSP load order."); 

            // 유효한 좌표를 가진 아이템 필터링 (mapY와 mapX가 null이 아니며 숫자로 변환 가능해야 함)
            const validItems = this.poiItems.filter(item => item.mapY && item.mapX && !isNaN(parseFloat(item.mapY)) && !isNaN(parseFloat(item.mapX)));

            if (validItems.length === 0) {
                return console.warn("유효한 좌표를 가진 POI 데이터가 없어 지도를 초기화할 수 없습니다.");
            }

            const firstItem = validItems[0];
            const center = new kakao.maps.LatLng(parseFloat(firstItem.mapY), parseFloat(firstItem.mapX));

            const options = { center: center, level: 7 };
            
            this.mapInstance = new kakao.maps.Map(container, options);

            // 🚨 [핵심 해결] 렌더링 후 relayout 강제 실행
            setTimeout(() => {
                this.mapInstance.relayout(); 
                
                validItems.forEach((item, index) => { 
                    this.drawMarker(item, index + 1);
                });
                
                this.setBoundToMarkers(validItems); 
            }, 0);
        },

        drawMarker(item, number) {
            const kakao = this.kakao;
            const position = new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX));
            const markerContent = `<div style="background: #2563eb; color: #fff; border-radius: 50%; width: 24px; height: 24px; line-height: 24px; text-align: center; font-weight: bold; font-size: 12px; border: 2px solid #fff;">${number}</div>`;
            
            const customOverlay = new kakao.maps.CustomOverlay({
                position: position, content: markerContent, yAnchor: 1
            });
            customOverlay.setMap(this.mapInstance);
        },

        setBoundToMarkers(validItems) {
            const kakao = this.kakao;
            const bounds = new kakao.maps.LatLngBounds();
            validItems.forEach(item => {
                bounds.extend(new kakao.maps.LatLng(parseFloat(item.mapY), parseFloat(item.mapX)));
            });
            this.mapInstance.setBounds(bounds);
        }
    }
};