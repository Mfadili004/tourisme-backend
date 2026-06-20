package com.tourisme.tourisme_app.service;

import com.tourisme.tourisme_app.model.Terrain;
import com.tourisme.tourisme_app.model.TerrainType;
import com.tourisme.tourisme_app.repository.TerrainRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {

    private final TerrainRepository terrainRepository;

    @Override
    public void run(String... args) {
        if (terrainRepository.count() > 0) return;   // seed once

        // ── World Cup 2030 stadiums in Morocco ──
        stade("Grand Stade Hassan II", "Casablanca", 115000, 33.5333, -7.6333);
        stade("Stade Moulay Abdellah", "Rabat", 69500, 33.9716, -6.8498);
        stade("Stade de Marrakech", "Marrakech", 45240, 31.6469, -8.0926);
        stade("Stade Adrar", "Agadir", 46000, 30.4035, -9.5430);
        stade("Stade Ibn Batouta", "Tanger", 65000, 35.7300, -5.8950);
        stade("Complexe Sportif de Fès", "Fès", 45000, 34.0331, -5.0003);

        // ── Sample tourist sites ──
        site("Médina de Fès", "Fès", 34.0650, -4.9770);
        site("Place Jemaa el-Fna", "Marrakech", 31.6258, -7.9892);
        site("Mosquée Hassan II", "Casablanca", 33.6083, -7.6325);

        // ── Sample bookable sport terrains ──
        sport("Terrain Five Agdal", "Rabat", 33.9900, -6.8500);
        sport("Padel Club Marrakech", "Marrakech", 31.6400, -8.0100);
    }

    private void stade(String name, String city, int cap, double lat, double lng) {
        Terrain t = new Terrain();
        t.setName(name); t.setCity(city); t.setType(TerrainType.STADE);
        t.setCapacity(cap); t.setLatitude(lat); t.setLongitude(lng);
        t.setDescription("Stade hôte de la Coupe du Monde 2030.");
        terrainRepository.save(t);
    }

    private void site(String name, String city, double lat, double lng) {
        Terrain t = new Terrain();
        t.setName(name); t.setCity(city); t.setType(TerrainType.SITE);
        t.setLatitude(lat); t.setLongitude(lng);
        terrainRepository.save(t);
    }

    private void sport(String name, String city, double lat, double lng) {
        Terrain t = new Terrain();
        t.setName(name); t.setCity(city); t.setType(TerrainType.SPORT);
        t.setLatitude(lat); t.setLongitude(lng);
        terrainRepository.save(t);
    }
}
