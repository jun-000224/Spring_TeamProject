<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>회원가입 | READY</title>

  <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

  <link rel="stylesheet" href="/css/main-style.css">
  <link rel="stylesheet" href="/css/common-style.css">
  <link rel="stylesheet" href="/css/header-style.css">
  <link rel="stylesheet" href="/css/main-images.css">

  <style>
    :root{
      --bg:#f7f8fa;
      --card:#ffffff;
      --text:#111827;
      --muted:#6b7280;
      --primary:#2563eb;
      --primary-hover:#1e40af;
      --border:#e5e7eb;
      --ring:rgba(37,99,235,.12);
      --danger:#ef4444;
      --success:#16a34a;
    }
    *,*::before,*::after{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto,
                   "Noto Sans KR", Arial, "Apple SD Gothic Neo", "Malgun Gothic";
      color:var(--text);
      background:var(--bg);
    }

    .container{
      width:100%;
      max-width:720px;
      margin: clamp(40px, 8vh, 80px) auto;
      padding: 0 16px;
    }

    .card{
      background:var(--card);
      border:1px solid var(--border);
      border-radius:16px;
      padding:32px;
      box-shadow: 0 6px 18px rgba(0,0,0,.03);
    }

    .header{
      margin-bottom:8px;
    }
    .title{
      margin:0;
      font-size:22px;
      font-weight:800;
      letter-spacing:-.2px;
    }
    .subtitle{
      margin:6px 0 0;
      color:var(--muted);
      font-size:14px;
    }

    .divider{
      height:1px;
      background:#f0f2f5;
      margin:24px 0;
      border:0;
    }

    .grid{
      display:grid;
      gap:18px;
    }
    .grid-2{
      grid-template-columns: 1fr 1fr;
    }
    @media (max-width: 640px){
      .grid-2{ grid-template-columns: 1fr; }
    }

    .field{
      display:flex;
      flex-direction:column;
      gap:8px;
    }
    .label{
      font-size:14px;
      font-weight:600;
    }
    .req{ color:var(--danger); margin-left:6px; font-weight:700; }

    .input, select{
      width:100%;
      padding:14px 14px;
      border:1px solid var(--border);
      border-radius:12px;
      background:#fff;
      font-size:15px;
      outline:none;
      transition: border-color .15s, box-shadow .15s;
      min-width:0;
    }
    .input:focus, select:focus{
      border-color:var(--primary);
      box-shadow:0 0 0 4px var(--ring);
    }

    .row-inline{
      display:flex; gap:10px; align-items:center;
    }
    .row-inline .grow{ flex:1; }

    .phone-group{
      display:flex; gap:10px; align-items:center;
    }
    .phone-group select{ width:98px; min-width:98px; }
    .phone-group .seg{ flex:1; }

    .help{
      font-size:12px; color:var(--muted);
    }

    .alert{
      display:none;
      margin-top:6px;
      padding:10px 12px;
      border-radius:10px;
      background:#fff1f2;
      border:1px solid #fecaca;
      color:#991b1b;
      font-size:13px;
      width: 300px;
    }
    .alert.show{ display:block; }

    .pwd-note{
      font-size:13px; color:var(--muted);
      margin-top:-6px;
    }
    .pwdCheckMsg{
      font-size:13px; margin-top:6px;
    }
    .pwdCheckMsg .ok{ color:var(--success); font-weight:700; }
    .pwdCheckMsg .no{ color:var(--danger); font-weight:700; }

    .actions{
      display:flex; gap:12px; justify-content:flex-end; margin-top:28px;
    }
    .btn{
      display:inline-flex; align-items:center; justify-content:center;
      padding:12px 18px; border-radius:12px; border:1px solid var(--border);
      background:#fff; color:var(--text); font-weight:700; font-size:15px;
      cursor:pointer; min-width:140px;
      transition: background .15s, border-color .15s, color .15s;
    }
    .btn:hover{ border-color:var(--primary); color:var(--primary); }
    .btn.primary{
      background:var(--primary); color:#fff; border-color:var(--primary);
    }
    .btn.primary:hover{ background:var(--primary-hover); border-color:var(--primary-hover); color:#fff; }

    /* 라디오 버튼 간격 단정히 */
    .radios{ display:flex; gap:16px; align-items:center; }
    .radios label{ display:flex; gap:6px; align-items:center; font-size:14px; }

    @keyframes shake {
      0%, 100% { transform: translateX(0); }
      20%, 60% { transform: translateX(-6px); }
      40%, 80% { transform: translateX(6px); }
    }
    #alertBox {
      /* display: none;
      margin-top: 6px;
      padding: 10px 12px;
      border-radius: 10px;
      background: #fff1f2;
      border: 1px solid #fecaca;
      color: #991b1b;
      font-size: 13px;
      width: 300px; */
      transition: all 0.2s ease;
    }

    #alertBox.show {
      display: block;
      animation: shake 0.4s ease; /* ✅ 흔들림 효과 */
    }
  </style>
</head>
<body>
<%@ include file="../components/header.jsp" %>
  <div id="app">
    

      <div class="container">
        <div class="card">
          <div class="header">
            <h1 class="title">회원가입</h1>
            <p class="subtitle">필수 항목만 간단히 입력하고 READY를 시작해요.</p>
          </div>

          <!-- 기본 정보 -->
          <div class="grid">
            <div class="field">
              <label class="label">이름<span class="req">*</span></label>
              <input type="text" class="input" v-model="name"
                    @input="onNameInput"
                    @compositionstart="isComposing = true"
                    @compositionend="onCompositionEnd"
                    placeholder="홍길동"
                    autofocus="true">
            </div>
          </div>

          <div class="divider"></div>

          <!-- 생년월일 / 성별 -->
          <div class="grid grid-2">
            <div class="field">
              <label class="label">생년월일<span class="req">*</span></label>
              <div class="row-inline">
                <select v-model="year" aria-label="년">
                  <option
                    v-for="y in Array.from({length: new Date().getFullYear()-1900+1}, (_, i) => 1900 + i)"
                    :key="y" :value="y">{{ y }}</option>
                </select>
                <select v-model="month" aria-label="월">
                  <option :value="String(num).padStart(2,'0')" v-for="num in 12">{{ String(num).padStart(2,'0') }}</option>
                </select>
                <select v-model="day" aria-label="일">
                  <option v-if="month%2==1" :value="String(num).padStart(2,'0')" v-for="num in 31">{{ String(num).padStart(2,'0') }}</option>
                  <option v-else-if="month==2" :value="String(num).padStart(2,'0')" v-for="num in 29">{{ String(num).padStart(2,'0') }}</option>
                  <option v-else :value="String(num).padStart(2,'0')" v-for="num in 30">{{ String(num).padStart(2,'0') }}</option>
                </select>
              </div>
            </div>

            <div class="field">
              <label class="label">성별<span class="req">*</span></label>
              <div class="radios">
                <label><input type="radio" name="gender" value="M" v-model="gender">남자</label>
                <label><input type="radio" name="gender" value="F" v-model="gender">여자</label>
                <label><input type="radio" name="gender" value="N" v-model="gender">미공개</label>
              </div>
            </div>
          </div>

          <div class="divider"></div>

          <!-- 계정 -->
          <div class="grid grid-2">
            <div class="field">
              <label class="label">아이디<span class="req">*</span></label>
              <div class="row-inline">
                <input v-if="!idFlg" type="text" class="input grow" v-model="id" placeholder="영소문자+숫자"
                      @input="id = id.replace(/[^a-z0-9]/g,'')">
                <input v-else type="text" class="input grow" v-model="id" disabled style="background-color: rgb(136, 136, 136); color: white; font-weight: bold;" >
                <button type="button" class="btn" @click="fnIdCheck">중복체크</button>
              </div>
              
            </div>

            <div class="field">
              <label class="label">닉네임</label>
              <input type="text" class="input" v-model="nickname" placeholder="미입력 시 이름으로 설정됩니다">
            </div>
          </div>

          <div class="grid grid-2" style="margin-top:6px;">
            <div class="field">
              <label class="label">비밀번호<span class="req">*</span></label>
              <input type="password" class="input" v-model="pwd"
                    @input="pwd = pwd.replace(/[^a-zA-Z0-9!@#$%^&*(),.?/:{}|<>]/g,'')"
                    placeholder="영문/숫자/특수기호 조합 권장">
              <div class="pwd-note">영문/숫자/특수기호 사용 가능</div>
            </div>

            <div class="field">
              <label class="label">비밀번호 확인<span class="req">*</span></label>
              <input type="password" class="input" v-model="pwd2"
                    @input="pwd2 = pwd2.replace(/[^a-zA-Z0-9!@#$%^&*(),.?/:{}|<>]/g,'')"
                    placeholder="비밀번호 재입력">
              <div class="pwdCheckMsg">
                <span class="ok" v-if="pwd!=='' && pwd2!=='' && pwd===pwd2">일치합니다</span>
                <span class="no" v-else-if="pwd!=='' && pwd2!=='' && pwd!==pwd2">일치하지 않습니다</span>
              </div>
            </div>
          </div>

          <div class="divider"></div>

          <!-- 연락처 -->
          <div class="grid">
            <div class="field">
              <label class="label">이메일<span class="req">*</span></label>
              <div class="row-inline">
                <input type="text" class="input" style="max-width:240px" v-model="emailFront"
                      @input="emailFront = emailFront.replace(/[^a-z0-9]/g,'')" placeholder="아이디">
                <span>@</span>
                <select v-model="emailBack" class="grow" aria-label="이메일 도메인">
                  <option value="default">선택해주세요</option>
                  <option value="naver.com">naver.com</option>
                  <option value="gmail.com">gmail.com</option>
                  <option value="daum.net">daum.net</option>
                  <option value="yahoo.com">yahoo.com</option>
                </select>
              </div>
            </div>

            
              <label class="label">주소<span class="req">*</span></label>
              <div class="row-inline">
                <input type="text" class="input grow" v-model="addr" placeholder="주소 검색으로 입력" disabled>
                <button type="button" class="btn" @click="fnAddr">검색</button>
              </div>
            </div>

            <div class="divider"></div>
            
            <div class="field">
              <label class="label">전화번호<span class="req">*</span></label>
              <div class="phone-group">
                <select v-model="phone1" aria-label="국번">
                  <option value="010">010</option>
                  <option value="011">011</option>
                  <option value="012">012</option>
                  <option value="016">016</option>
                  <option value="017">017</option>
                  <option value="018">018</option>
                  <option value="019">019</option>
                </select>
                <input type="text" class="input seg" v-model="phone2" maxlength="4"
                      @input="phone2 = phone2.replace(/[^0-9]/g,'').slice(0,4)" placeholder="####">
                <input type="text" class="input seg" v-model="phone3" maxlength="4"
                      @input="phone3 = phone3.replace(/[^0-9]/g,'').slice(0,4)" placeholder="####">
              </div>
            </div>

            <div class="field" style="margin-top: 12px;" v-if="!certifiFlg">
              <label class="label">문자인증</label>
              <div class="row-inline">
                <input type="text" class="input grow" v-model="inputNum" :placeholder="timer || '인증번호 입력'">
                <template v-if="!smsFlg">
                  <button type="button" class="btn" @click="fnSms">인증번호 전송</button>
                </template>
                <template v-else>
                  <button type="button" class="btn" @click="fnSmsAuth">인증</button>
                </template>
                <span v-if="timer" style="font-variant-numeric: tabular-nums; font-weight:700; color:#dc2626;">{{ timer }}</span>
              </div>
            </div>

            <div class="divider"></div>

            <div class="grid">
              <div class="field">
                <label class="label">프로필 사진 업로드</label>
                <input type="file" id="file1" name="file1" accept=".jpg, .png"> 
              </div>
            </div>
          </div>

          
          <div class="actions">
            
            <div>
              <div style="margin-bottom: 10px;" id="alertBox" class="alert">{{ alertMsg }}</div>
              <button type="button" class="btn" @click="fnCancel">취소</button>
              <button style="margin-left: 10px;" type="button" class="btn primary" @click="fnJoin">가입하기</button>
            </div>
          </div>
        </div>
      </div>

    
  </div>
<%@ include file="../components/footer.jsp" %>
<script>
  function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo) {
    window.vueObj.fnResult(roadFullAddr, addrDetail, zipNo);
  }

  let today = new Date();
  let nowYear = today.getFullYear();

  const app = Vue.createApp({
    data(){
      return {
        alertMsg:"",

        isComposing: false, //한글 조합중인지 체크

        id : "",
        pwd : "",
        pwd2 : "",
        name : "",
        gender : "M",
        year : "1900",
        month : "01",
        day : "01",
        emailFront : "",
        emailBack : "default",
        addr : "",
        phone1 : "010",
        phone2 : "",
        phone3 : "",
        nickname : "",

        idFlg : false, //아이디 중복 체크 유무

        timer : "",
        count : 180,

        smsFlg : false, // 인증번호 발송 여부
        certifiFlg : false, // 문자 인증 유무
        inputNum : "", // 인증 입력 번호
        certifiStr : "" // 문자 인증 번호
      };
    },
    methods:{
      showAlert(msg){
        this.alertMsg = msg || "";
        var el = document.getElementById("alertBox");
        if(el){
          el.classList.remove("show");
          void el.offsetWidth;
          if(this.alertMsg){ el.classList.add("show"); } else { el.classList.remove("show"); }
        }
      },

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
      },

      fnTimer : function () {
          let self = this;
          let interval = setInterval(function(){
              if(self.count == 0) {
                  clearInterval(interval);
                  alert("시간이 만료되었습니다.");
              } else {
                  let min = parseInt(self.count / 60);
                  let sec = self.count % 60;

                  min = min < 10 ? "0" + min : min;
                  sec = sec < 10 ? "0" + sec : sec;
                  
                  self.timer = min + " : " + sec;

                  self.count--;
              }
          }, 1000);
      },

      fnSmsAuth : function () {
          let self = this;
          if(self.certifiStr == self.inputNum){
              alert("문자인증이 완료되었습니다.");
              self.certifiFlg = true;
          } else {
              alert("문자인증에 실패했습니다.");
          }
      },

      // fnJoin : function () {
      //     let self = this;
      //     if(self.name == ""){
      //         alert("이름을 입력해주세요.");
      //         return;
      //     }
      //     if(!self.idFlg){
      //         alert("id중복체크를 해주세요.");
      //         return;
      //     }
      //     if(self.pwd.length == ""){
      //       alert("비밀번호를 입력해주세요.");
      //       return;
      //     }
      //     if(self.pwd != self.pwd2){
      //         alert("비밀번호를 확인해주세요.");
      //         return;
      //     }
      //     if(self.emailFront == ""){
      //         alert("이메일을 입력해주세요.");
      //         return;
      //     }
      //     if(self.emailBack=="default"){
      //         alert("이메일을 입력해주세요.");
      //         return;
      //     }
      //     if(self.addr == ""){
      //         alert("주소를 입력해주세요.");
      //         return;
      //     }
      //     if(self.phone2.length !=4 || self.phone3.length != 4){
      //         alert("전화번호를 입력해주세요.");
      //         return;
      //     }
      //     if(self.nickname==""){
      //         self.nickname=self.name;
      //     }
      //     // if(!self.certifiFlg){
      //     //     alert("전화번호를 인증해주세요.")
      //     //     return;
      //     // }
          
      //     let param = {
      //         userId : self.id,
      //         pwd : self.pwd,
      //         name : self.name,
      //         gender : self.gender,
      //         birth : self.year + self.month + self.day,
      //         email : self.emailFront + '@' + self.emailBack,
      //         addr : self.addr,
      //         phone : self.phone1 + '-' + self.phone2 + '-' + self.phone3,
      //         nickname : self.nickname
      //     };
      //     console.log(param);
      //     $.ajax({
      //         url: "/member/join.dox",
      //         dataType: "json",
      //         type: "POST",
      //         data: param,
      //         success: function (data) {
      //             if(data.result=='success'){
      //                 // var form = new FormData();
      //                 // form.append( "file1",  $("#file1")[0].files[0] ); // id가 file1인 것에 첨부된 파일, 1개만 첨부할 것이기 때문에 [0]
      //                 // form.append( "userId",  data.boardNo); // 임시 pk=> boardNo 값을 가져왔으니, data.boardNo를 boardNo로
      //                 // self.upload(form);
      //                 console.log(data);
      //                 alert("가입되었습니다.");
      //                 // location.href="/member/login.do";
      //             } else{
      //                 alert("오류가 발생했습니다.");
      //                 return;
      //             }
      //         }
      //     });
      // },

            
      onNameInput(e){
        if(this.isComposing) return;
        this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g,'');
      },
      onCompositionEnd(e){
        this.isComposing = false;
        this.name = e.target.value.replace(/[^가-힣a-zA-Z]/g,'');
      },

      fnIdCheck(){
        let self =this;
        if(self.id.length==0){
            alert("아이디를 입력해주세요.");
            return;
        }
        var param = { userId: this.id };
        $.ajax({
          url:"/member/idCheck.dox", 
          type:"POST", 
          dataType:"json", 
          data:param,
          success:(data)=>{
            if(data.result=='false'){
              alert(data.msg); 
              this.idFlg = true;
            }else{
              alert(data.msg);
            }
          }
        });
      },

      fnAddr(){ 
        window.open("/member/addr.do","addr","width=500,height=500"); 
      },
      fnResult(roadFullAddr){ 
        this.addr = roadFullAddr; 
      },

      fnSms(){
        let self = this;
        if(self.phone2.length !== 4 || self.phone3.length !== 4){
          self.showAlert("전화번호를 정확히 입력해주세요."); 
           return; 
        }
        let param = {
          phone : self.phone1+self.phone2+self.phone3
        };
        $.ajax({
          url:"/send-one", 
          type:"POST", 
          dataType:"json", 
          data:param,
          success:(data)=>{
            if(data.res && data.res.statusCode == "2000"){
              alert("문자 전송 완료");
              this.certifiStr = data.ranStr;
              this.smsFlg = true;
              this.fnTimer();
            }else{
              alert("잠시 후 다시 시도해주세요.");
            }
          }
        });
      },

      // fnTimer(){
      //   this.count = 180;
      //   var interval = setInterval(()=>{
      //     if(this.count <= 0){
      //       clearInterval(interval);
      //       this.timer = "";
      //       alert("시간이 만료되었습니다.");
      //     }else{
      //       var m = String(parseInt(this.count/60)).padStart(2,"0");
      //       var s = String(this.count%60).padStart(2,"0");
      //       this.timer = m + " : " + s;
      //       this.count--;
      //     }
      //   }, 1000);
      // },

      // fnSmsAuth(){
      //   if(this.certifiStr == this.inputNum){
      //     alert("문자인증이 완료되었습니다.");
      //     this.certifiFlg = true;
      //   }else{
      //     alert("문자인증에 실패했습니다.");
      //   }
      // },

      fnJoin(){
        this.showAlert("");

        if(this.name === ""){ 
          this.showAlert("이름을 입력해주세요."); return; 
        }
        if(this.id === "") { 
          this.showAlert("아이디를 입력해주세요."); 
          return; 
        }
        if(!this.idFlg) { 
          this.showAlert("아이디 중복체크를 완료해주세요."); 
          return; 
        }
        if(this.pwd === ""){ 
          this.showAlert("비밀번호를 입력해주세요."); 
          return; 
        }
        if(this.pwd !== this.pwd2){ 
          this.showAlert("비밀번호가 일치하지 않습니다."); 
          return; 
        }
        if(this.emailFront === ""){ 
          this.showAlert("이메일을 입력해주세요."); 
          return; 
        }
        if(this.emailBack === "default"){ 
          this.showAlert("이메일 도메인을 선택해주세요."); 
          return; 
        }
        if(this.addr === ""){ 
          this.showAlert("주소를 입력해주세요."); 
          return; 
        }
        if(this.phone2.length !== 4 || this.phone3.length !== 4){
          this.showAlert("전화번호를 정확히 입력해주세요."); 
           return; 
        }
        if(this.nickname === ""){ 
          this.nickname = this.name; 
        }
        // if(!this.certifiFlg){
        //   this.showAlert("전화번호를 인증해주세요."); 
        //   return; 
        // }

        var param = {
          userId: this.id,
          pwd: this.pwd,
          name: this.name,
          gender: this.gender,
          birth: this.year + this.month + this.day,
          email: this.emailFront + "@" + this.emailBack,
          addr: this.addr,
          phone: this.phone1 + "-" + this.phone2 + "-" + this.phone3,
          nickname: this.nickname
        };

        $.ajax({
          url:"/member/join.dox", type:"POST", dataType:"json", data:param,
          success:(data)=>{
            if(data.result=='success'){
              console.log(data);
              let form = new FormData();
              form.append( "file1",  $("#file1")[0].files[0] );
              form.append( "userId",  this.id);
              this.fnProfileUpload(form);
              alert("가입되었습니다.");
              location.href="/member/login.do";
            }else{
              this.showAlert("오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            }
          },
          error:()=>{
            this.showAlert("오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
          }
        });
      },

      fnProfileUpload(form){
        var self = this;
        $.ajax({
            url : "/member/profileUpload.dox", 
            type : "POST", 
            processData : false, 
            contentType : false, 
            data : form, 
            success:function(data) { 
                console.log(data);
            }	           
        });
      },

      fnCancel(){ location.href="/member/login.do"; }
    },
    mounted(){ window.vueObj = this; }
  });

  app.mount('#app');
</script>
</body>
</html>
