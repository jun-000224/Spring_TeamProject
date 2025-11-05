package com.example.test1.model.reservation;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class Area {

    @JsonProperty("code")
    private String code;   // "1", "31" ...

    @JsonProperty("name")
    private String name;   // "서울", "경기도" ...
}
