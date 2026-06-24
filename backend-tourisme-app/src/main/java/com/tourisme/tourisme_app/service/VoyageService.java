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
        v.getItinerary().clear();
        apply(v, req);
        return voyageRepository.save(v);
    }

    public void delete(Long id) {
        voyageRepository.deleteById(id);
    }

    /** Maps the request DTO onto the entity. Entites introuvables = ignorees. */
    private void apply(Voyage v, VoyageRequest req) {
        v.setTitle(req.getTitle());
        v.setDestination(req.getDestination());
        v.setStartDate(req.getStartDate());
        v.setEndDate(req.getEndDate());
        v.setMatchLabel(req.getMatchLabel());
        v.setMatchDate(req.getMatchDate());

        // Tourist optionnel : si introuvable, on n'attache rien
        if (req.getTouristId() != null) {
            v.setTourist(touristRepository.findById(req.getTouristId()).orElse(null));
        } else {
            v.setTourist(null);
        }

        // Stade optionnel
        if (req.getStadeId() != null) {
            v.setStade(terrainRepository.findById(req.getStadeId()).orElse(null));
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
                    step.setTerrain(terrainRepository.findById(s.getTerrainId()).orElse(null));
                }
                step.setVoyage(v);
                v.getItinerary().add(step);
            }
        }
    }
}