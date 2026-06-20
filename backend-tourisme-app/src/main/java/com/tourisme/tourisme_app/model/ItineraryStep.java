package com.tourisme.tourisme_app.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "itinerary_steps")
@Data
public class ItineraryStep {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer dayNumber;        // day 1, 2, 3...
    private Integer orderInDay;       // sequence within a day

    private String title;             // "Visite Médina"
    private String time;              // "09:00"
    private String notes;

    // Optional link to a terrain (site/stade/sport)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "terrain_id")
    private Terrain terrain;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "voyage_id")
    @JsonIgnore
    private Voyage voyage;
}
