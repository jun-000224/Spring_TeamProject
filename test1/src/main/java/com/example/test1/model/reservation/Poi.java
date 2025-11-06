package com.example.test1.model.reservation;

import lombok.Data;

@Data
public class Poi {
	
	private Long poiId;
	private Long contentId;
	private Integer typeId;
	private Long resNum;
	private String reservDate;
	private Integer rating;
	private String content;
	
	private String mapX;
	private String mapY;
	private String PlaceName;
	
}
