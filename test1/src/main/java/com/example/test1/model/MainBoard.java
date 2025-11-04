package com.example.test1.model;

import lombok.Data;
import java.util.Date;

@Data
public class MainBoard {
    private int boardNo;
    private String userId;
    private String title;
    private String contents;
    private int fav;
    private int cnt;
    private Date crtdatetime;
    private Date upddatetime;
    private String type;
    private int reportCnt;
}
