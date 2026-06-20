package com.tourisme.tourisme_app.repository;

import com.tourisme.tourisme_app.model.Terrain;
import com.tourisme.tourisme_app.model.TerrainType;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TerrainRepository extends JpaRepository<Terrain, Long> {
    List<Terrain> findByType(TerrainType type);
    List<Terrain> findByCityIgnoreCase(String city);
}
