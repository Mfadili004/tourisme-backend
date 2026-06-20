package com.tourisme.tourisme_app.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "terrains")
@Data
public class Terrain {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TerrainType type;

    private String city;
    private String address;

    private Double latitude;
    private Double longitude;

    private Integer capacity;        // useful for stadiums
    private String imageUrl;

    @Column(length = 1000)
    private String description;
}
