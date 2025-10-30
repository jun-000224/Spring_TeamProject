package com.example.test1.common;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {
	@Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();  // 비밀번호 해싱 기능만 사용
        //BCrypt가 비밀번호 해시
    }
	@Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll() // 모든 요청 허용 (로그인 필요 없음)
            )
            .csrf(csrf -> csrf.disable()) // CSRF 보호 비활성화 (필요 시 설정 가능)
            .formLogin(form -> form.disable()) // 기본 로그인 페이지 비활성화
            .httpBasic(basic -> basic.disable()) // HTTP Basic 인증 비활성화
	        .headers(headers -> headers.cacheControl(cache -> cache.disable()))
				//필터 체인
			; 

        return http.build();
    }
}
