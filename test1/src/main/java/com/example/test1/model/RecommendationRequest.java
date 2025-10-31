package com.example.test1.model;

import java.util.List;

import lombok.Data;

@Data
public class RecommendationRequest {
	private List<String> themes;
	private String areaCode;
	private String sigunguCode;
	private Integer headCount;
	private Integer budget;
	private BudgetWeights budgetWeights;
	private String startDate;
	private String endDate;
}
