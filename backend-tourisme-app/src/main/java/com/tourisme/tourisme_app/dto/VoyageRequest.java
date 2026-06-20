package com.tourisme.tourisme_app.dto;

import lombok.Data;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Data
public class VoyageRequest {
    private String title;
    private String destination;
    private LocalDate startDate;
    private LocalDate endDate;
    private Long touristId;
    private Long stadeId;          // optional
    private String matchLabel;     // optional
    private LocalDate matchDate;   // optional
    private List<StepRequest> itinerary = new ArrayList<>();

    @Data
    public static class StepRequest {
        private Integer dayNumber;
        private Integer orderInDay;
        private String title;
        private String time;
        private String notes;
        private Long terrainId;    // optional
    }
}
