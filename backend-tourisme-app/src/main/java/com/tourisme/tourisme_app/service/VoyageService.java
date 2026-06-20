package com.tourisme.tourisme_app.service;

import com.tourisme.tourisme_app.dto.VoyageRequest;
import com.tourisme.tourisme_app.model.*;
import com.tourisme.tourisme_app.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class VoyageService {

    private final VoyageRepository voyageRepository;
    private final TouristRepository touristRepository;
    private final TerrainRepository terrainRepository;

    public List<Voyage> findByTourist(Long touristId) {
        return voyageRepository.findByTouristId(touristId);
    }

    public Voyage findById(Long id) {
        return voyageRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Voyage not found: " + id));
    }

    @Transactional
    public Voyage create(VoyageRequest req) {
        Voyage v = new Voyage();
        apply(v, req);
        return voyageRepository.save(v);
    }

    @Transactional
    public Voyage update(Long id, VoyageRequest req) {
        Voyage v = findById(id);
        v.getItinerary().clear();   // rebuild itinerary
        apply(v, req);
        return voyageRepository.save(v);
    }

    public void delete(Long id) {
        voyageRepository.deleteById(id);
    }

    /** Maps the request DTO onto the entity. */
    private void apply(Voyage v, VoyageRequest req) {
        v.setTitle(req.getTitle());
        v.setDestination(req.getDestination());
        v.setStartDate(req.getStartDate());
        v.setEndDate(req.getEndDate());
        v.setMatchLabel(req.getMatchLabel());
        v.setMatchDate(req.getMatchDate());

        if (req.getTouristId() != null) {
            Tourist t = touristRepository.findById(req.getTouristId())
                .orElseThrow(() -> new RuntimeException("Tourist not found"));
            v.setTourist(t);
        }

        if (req.getStadeId() != null) {
            Terrain stade = terrainRepository.findById(req.getStadeId())
                .orElseThrow(() -> new RuntimeException("Stade not found"));
            v.setStade(stade);
        } else {
            v.setStade(null);
        }

        if (req.getItinerary() != null) {
            for (VoyageRequest.StepRequest s : req.getItinerary()) {
                ItineraryStep step = new ItineraryStep();
                step.setDayNumber(s.getDayNumber());
                step.setOrderInDay(s.getOrderInDay());
                step.setTitle(s.getTitle());
                step.setTime(s.getTime());
                step.setNotes(s.getNotes());
                if (s.getTerrainId() != null) {
                    Terrain terrain = terrainRepository.findById(s.getTerrainId())
                        .orElseThrow(() -> new RuntimeException("Terrain not found"));
                    step.setTerrain(terrain);
                }
                step.setVoyage(v);
                v.getItinerary().add(step);
            }
        }
    }
}
