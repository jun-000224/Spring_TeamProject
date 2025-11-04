package com.example.test1.mapper;

import com.example.test1.model.MainBoard;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface AdminMapper {
    List<MainBoard> selectInquiryBoards();
}
