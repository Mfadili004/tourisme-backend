package com.tourisme.tourisme_app.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "voyages")
@Data
public class Voyage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    private String destination;      // e.g. "Casablanca"

    private LocalDate startDate;
    private LocalDate endDate;

    // Owner of the trip
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tourist_id")
    private Tourist tourist;

    // Optional: stadium / match linked to this trip (World Cup use case)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "stade_id")
    private Terrain stade;

    private String matchLabel;       // e.g. "Maroc vs Espagne — 1/8 finale"
    private LocalDate matchDate;

    // Full itinerary: ordered stops
    @OneToMany(mappedBy = "voyage", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("dayNumber ASC, orderInDay ASC")
    private List<ItineraryStep> itinerary = new ArrayList<>();
}
