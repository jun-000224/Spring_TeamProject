package com.example.test1.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Random;

@Data
@Entity
@Table(name = "ATTR")
@NoArgsConstructor
public class Attr {

    @Id
    @Column(name = "CONTENT_ID")
    private Long contentId;

    @Column(name = "TYPE_ID")
    private Integer typeId;

    @Column(name = "FAMILY")    private double family;
    @Column(name = "LUXURY")    private double luxury;
    
    // 'UNIQUE'는 Oracle 예약어라 컬럼명으로 사용 불가
    // 'MOOD_UNIQUE'로 변경
    @Column(name = "MOOD_UNIQUE") private double unique;

    @Column(name = "ADVENTURE") private double adventure;
    @Column(name = "BUDGET")    private double budget;
    @Column(name = "FRIEND")    private double friend;
    @Column(name = "COUPLE")    private double couple;
    @Column(name = "HEALING")   private double healing;
    @Column(name = "QUIET")     private double quiet;

    
    public Attr(Long contentId, Integer typeId) {
        this.contentId = contentId;
        this.typeId = typeId;
        
        Random rand = new Random(contentId); 

        this.family = randomScore(rand);
        this.luxury = randomScore(rand);
        this.unique = randomScore(rand); 
        this.adventure = randomScore(rand);
        this.budget = randomScore(rand);
        this.friend = randomScore(rand);
        this.couple = randomScore(rand);
        this.healing = randomScore(rand);
        this.quiet = randomScore(rand);
    }
    
    private double randomScore(Random rand) {
        return Math.round(rand.nextDouble() * 100) / 100.0;
    }
}