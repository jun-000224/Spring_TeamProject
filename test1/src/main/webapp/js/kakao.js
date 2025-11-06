window.code = "";
let tempProperties = {};

function fnKakao () {
	let self = this;
	let param = {
		code: self.code
	};
	$.ajax({
        url: "/kakao.dox",
        dataType: "json",
        type: "POST",
        data: param,
        success: function (data) {
             console.log(data);
            // self.sessionName = data.properties.nickname;
            self.fnKakaoDisc(data.id);
			self.tempId = data.id;
            self.tempProperties = data.properties;
            // console.log(self.tempProperties);
        }
    });
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
            console.log(data);
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