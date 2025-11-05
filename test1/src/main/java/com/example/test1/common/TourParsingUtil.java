package com.example.test1.common;

import org.springframework.stereotype.Component;

import java.util.Random; // Random import 추가

@Component
public class TourParsingUtil {

    /**
     * 가격 문자열(예: "15,000원", "10000", "문의")에서 숫자만 추출합니다. (기존 코드 유지)
     * @param priceStr API에서 받은 가격 문자열
     * @return 추출된 숫자(long), 실패 시 0L 반환
     */
    public long parsePrice(String priceStr) {
        if (priceStr == null || priceStr.isBlank()) {
            return 0L;
        }
        
        try {
            // 쉼표(,)와 '원' 등 모든 문자 제거
            String numericStr = priceStr.replaceAll("[^0-9]", "");
            
            if (numericStr.isBlank()) {
                return 0L; // "가격 문의" 등
            }
            
            return Long.parseLong(numericStr);
        } catch (NumberFormatException e) {
            return 0L; // 파싱 실패
        }
    }

    /**
     * POI contentId를 시드(Seed)로 사용하여 일관된 더미 가격을 생성합니다.
     * @param seed POI의 contentId (Long)
     * @param min 최소 가격 (int)
     * @param max 최대 가격 (int)
     * @return 생성된 더미 가격 (long, 100원 단위 반올림)
     */
    public long generateDummyPrice(long seed, int min, int max) {
        // contentId를 시드로 사용해 난수 생성기를 초기화하여, 같은 POI는 항상 같은 값을 반환합니다.
        Random rand = new Random(seed);
        
        // min ~ max 범위의 난수를 생성
        long range = (long)max - min + 1;
        long dummyPrice = min + (long)(rand.nextDouble() * range);
        
        // 데모용으로 보기 좋게 100원 단위로 반올림
        return Math.round(dummyPrice / 100.0) * 100;
    }
}