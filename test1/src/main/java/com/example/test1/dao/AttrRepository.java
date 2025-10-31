package com.example.test1.dao;

import com.example.test1.model.Attr;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AttrRepository extends JpaRepository<Attr, Long> {

    // On-Demand 로직을 위한 핵심 메소드
    // POI 목록(contentId 리스트)을 받아서, 
    // DB에 이미 저장된 Attr 목록을 반환합니다.
    List<Attr> findByContentIdIn(List<Long> contentIds);
}