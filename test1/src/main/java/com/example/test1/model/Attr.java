package com.example.test1.model;

import lombok.Data;
import lombok.NoArgsConstructor; // [ ⭐ 1. 기본 생성자용 @NoArgsConstructor ]
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Random; 

@Data
@Entity
@Table(name = "ATTR")
@NoArgsConstructor // [ ⭐ 1. (public Attr() 생성) - 이게 없으면 오류 ]
public class Attr {

    @Id
    @Column(name = "CONTENT_ID")
    private Long contentId;

    @Column(name = "TYPE_ID")
    private Integer typeId;

    @Column(name = "REL_COUPLE")    private double relCouple;
    @Column(name = "REL_FAMILY")    private double relFamily;
    @Column(name = "REL_FRIEND")    private double relFriend;
    @Column(name = "REL_ALONE")     private double relAlone;
    @Column(name = "SIZE_SMALL")    private double sizeSmall;
    @Column(name = "SIZE_LARGE")    private double sizeLarge;
    @Column(name = "MOOD_UNIQUE")   private double moodUnique;
    @Column(name = "MOOD_HEALING")  private double moodHealing;
    
    /**
	씨드 기반 생성자
    RecommendationService가 호출하는 생성자입니다.
    */
    public Attr(Long contentId, Integer typeId) {
        this.contentId = contentId;
        this.typeId = typeId;
        
        Random rand = new Random(contentId); 

        this.relCouple = randomScore(rand);
        this.relFamily = randomScore(rand);
        this.relFriend = randomScore(rand);
        this.relAlone = randomScore(rand);
        this.sizeSmall = randomScore(rand);
        this.sizeLarge = randomScore(rand);
        this.moodUnique = randomScore(rand);
        this.moodHealing = randomScore(rand);
    }
    
    //헬퍼 메소드
    private double randomScore(Random rand) {
        return Math.round(rand.nextDouble() * 100) / 100.0;
    }
}