package com.tourisme.tourisme_app.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "tourists")
@Data
public class Tourist {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;
}
