package com.tourisme.tourisme_app.controller;

import com.tourisme.tourisme_app.dto.VoyageRequest;
import com.tourisme.tourisme_app.model.Voyage;
import com.tourisme.tourisme_app.service.VoyageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/voyages")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class VoyageController {

    private final VoyageService voyageService;

    /** GET /api/voyages/tourist/{touristId} */
    @GetMapping("/tourist/{touristId}")
    public List<Voyage> byTourist(@PathVariable Long touristId) {
        return voyageService.findByTourist(touristId);
    }

    @GetMapping("/{id}")
    public Voyage get(@PathVariable Long id) {
        return voyageService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Voyage create(@RequestBody VoyageRequest req) {
        return voyageService.create(req);
    }

    @PutMapping("/{id}")
    public Voyage update(@PathVariable Long id, @RequestBody VoyageRequest req) {
        return voyageService.update(id, req);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        voyageService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
