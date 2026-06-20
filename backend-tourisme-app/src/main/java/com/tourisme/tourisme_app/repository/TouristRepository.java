package com.tourisme.tourisme_app.repository;

import com.tourisme.tourisme_app.model.Tourist;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface TouristRepository extends JpaRepository<Tourist, Long> {
    Optional<Tourist> findByEmail(String email);
}
