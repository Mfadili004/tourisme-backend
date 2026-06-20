package com.tourisme.tourisme_app.repository;

import com.tourisme.tourisme_app.model.Voyage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface VoyageRepository extends JpaRepository<Voyage, Long> {
    List<Voyage> findByTouristId(Long touristId);
}
