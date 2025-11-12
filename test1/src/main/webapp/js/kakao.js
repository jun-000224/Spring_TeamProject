window.code = "";
let tempProperties = {};

function fnKakao () {
    let self = this;

    // 1) 서버에 세션에 토큰이 있는지 확인
    $.getJSON('/api/session/kakao')
      .done(function(res) {
        if (res.hasKakaoSession) {
          //console.log('이미 세션에 kakaoAccessToken 존재 — fnKakao 중단');
          cleanUrlCodeParam();
          return;
        }

        // 2) 세션에 없으면 로그인 처리
        let param = { code: self.code };

        if (self._kakaoRequestInFlight) return;
        self._kakaoRequestInFlight = true;

        $.ajax({
            url: "/kakao.dox",
            dataType: "json",
            type: "POST",
            data: param,
            success: function (data) {
                //console.log(data);
                self.fnKakaoDisc(data.id);
                self.tempId = data.id;
                self.tempProperties = data.properties;
                cleanUrlCodeParam();
            },
            error: function(err) {
                console.error('kakao.dox 호출 실패', err);
                alert('카카오 로그인에 실패했습니다.');
            },
            complete: function() {
                self._kakaoRequestInFlight = false;
            }
        });

      })
      .fail(function() {
        console.error('세션 체크 실패 — 네트워크 문제 등');
        alert('세션 확인에 실패했습니다. 새로고침 후 다시 시도하세요.');
      });

    // helper: URL에서 ?code= 제거 (새로고침 시 중복 전송 방지)
    function cleanUrlCodeParam(){
      if(window.history && window.history.replaceState){
        const url = window.location.pathname + window.location.hash;
        window.history.replaceState({}, document.title, url);
      }
    }
}

function fnKakaoDisc (id){
    let self = this;
    let param = {
        userId : "kakao_"+id
    };
    $.ajax({
        url: "/member/kakaoDisc.dox",
        dataType: "json",
        type: "POST",
        data: param,
        success: function (data) {
            // console.log(data);
            if(data.result == 'success'){
                self.fnKakaoLogin(id);
            } else {
                self.fnKakaoJoin(id);
            }
        }
    });
}

function fnKakaoJoin (id) {
	let self = this;
    let param = {
        userId : "kakao_"+id,
        nickname : self.tempProperties.nickname
    };
    $.ajax({
        url: "/member/kakaoJoin.dox",
        dataType: "json",
        type: "POST",
        data: param,
        success: function (data) {
            // console.log(data);
            if(data.result == 'success'){
                self.fnKakaoLogin(id);
            } else {
                alert(data.msg);
                return;
            }
        }
    });
}

function fnKakaoLogin (id) {
	let self = this;
    let param = {
        userId : "kakao_"+id
    };
    $.ajax({
        url: "/member/kakaoDisc.dox",
        dataType: "json",
        type: "POST",
        data: param,
        success: function (data) {
            //console.log(data);
            if(data.result == 'success'){
                //alert(data.msg);
                location.href="/main-list.do"
            } else {
                alert(data.msg);
                return;
            }
        }
    });
}