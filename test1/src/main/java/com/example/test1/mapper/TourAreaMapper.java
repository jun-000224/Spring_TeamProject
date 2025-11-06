package com.example.test1.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.test1.model.reservation.Area;

import java.util.List;

@Mapper
public interface TourAreaMapper {

    // 예시) 지역코드 캐시 저장
    int upsertAreaCodes(@Param("type") String type, @Param("json") String json);

    // 예시) 캐시 조회
    String findAreaCodesJson(@Param("type") String type);

    // 예시) DB에서 부모코드 기준 조회
    List<Area> selectAreasByParent(@Param("parentCode") String parentCode);
}
