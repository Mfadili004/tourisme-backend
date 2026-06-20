package com.tourisme.tourisme_app.service;

import com.tourisme.tourisme_app.model.Terrain;
import com.tourisme.tourisme_app.model.TerrainType;
import com.tourisme.tourisme_app.repository.TerrainRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TerrainService {

    private final TerrainRepository terrainRepository;

    public List<Terrain> findAll() {
        return terrainRepository.findAll();
    }

    public List<Terrain> findByType(TerrainType type) {
        return terrainRepository.findByType(type);
    }

    public List<Terrain> findByCity(String city) {
        return terrainRepository.findByCityIgnoreCase(city);
    }

    public Terrain findById(Long id) {
        return terrainRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Terrain not found: " + id));
    }

    public Terrain save(Terrain terrain) {
        return terrainRepository.save(terrain);
    }

    public void delete(Long id) {
        terrainRepository.deleteById(id);
    }
}
