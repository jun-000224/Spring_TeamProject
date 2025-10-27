<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 페이지</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div id="container">
        <form id="loginForm" method="post">
            <div>
                아이디 : <input type="text" id="userId" name="userId">
            </div>
            <div>
                비밀번호 : <input type="password" id="pwd" name="pwd">
            </div>
            <div>
                <button type="button" onclick="fnLogin()">로그인</button>
            </div>
        </form>
    </div>

    <script>
        function fnLogin() {
            var userId = document.getElementById("userId").value;
            var pwd = document.getElementById("pwd").value;

            // 유효성 검사
            if (!userId || !pwd) {
                alert("아이디와 비밀번호를 입력하세요.");
                return;
            }

            // AJAX 요청
            $.ajax({
                url: "login.dox", // 로그인 처리를 위한 URL
                dataType: "json",
                type: "POST",
                data: {
                    userId: userId,
                    pwd: pwd
                },
                success: function(data) {
                    console.log(data);
                    if (data.result === "success") {
                        // 로그인 성공 시 페이지 전환
                        window.location.href = "";
                    } else {
                        // 로그인 실패 시 경고 메시지 출력
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    // 오류 처리
                    alert("오류가 발생했습니다: " + error);
                }
            });
        }
    </script>
</body>
</html>
