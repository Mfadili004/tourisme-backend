package com.tourisme.tourisme_app.controller;

import com.tourisme.tourisme_app.model.Terrain;
import com.tourisme.tourisme_app.model.TerrainType;
import com.tourisme.tourisme_app.service.TerrainService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/terrains")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class TerrainController {

    private final TerrainService terrainService;

    /** GET /api/terrains  — optional ?type=STADE|SPORT|SITE  or ?city=Casablanca */
    @GetMapping
    public List<Terrain> list(
            @RequestParam(required = false) TerrainType type,
            @RequestParam(required = false) String city) {
        if (type != null) return terrainService.findByType(type);
        if (city != null) return terrainService.findByCity(city);
        return terrainService.findAll();
    }

    @GetMapping("/{id}")
    public Terrain get(@PathVariable Long id) {
        return terrainService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Terrain create(@RequestBody Terrain terrain) {
        return terrainService.save(terrain);
    }

    @PutMapping("/{id}")
    public Terrain update(@PathVariable Long id, @RequestBody Terrain terrain) {
        terrain.setId(id);
        return terrainService.save(terrain);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        terrainService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
