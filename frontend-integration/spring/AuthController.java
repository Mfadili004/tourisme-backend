package com.tourisme.tourisme_app.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.tourisme.tourisme_app.model.Tourist;
import com.tourisme.tourisme_app.repository.TouristRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

/**
 * Called once after Firebase login — creates the Tourist in MySQL
 * if this is the first time.
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final TouristRepository touristRepository;

    /**
     * POST /api/auth/register
     * Body: { "idToken": "<firebase_token>" }
     * → Verifies token, creates Tourist in DB if not exists
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(
            @RequestBody Map<String, String> body) {

        String idToken = body.get("idToken");
        if (idToken == null || idToken.isBlank()) {
            return ResponseEntity.badRequest()
                .body(Map.of("error", "idToken is required"));
        }

        try {
            FirebaseToken decoded =
                FirebaseAuth.getInstance().verifyIdToken(idToken);

            String uid   = decoded.getUid();
            String email = decoded.getEmail();
            String name  = decoded.getName() != null
                           ? decoded.getName() : "Tourist";

            // Create tourist in MySQL if not already exists
            Tourist tourist = touristRepository
                .findByEmail(email)
                .orElseGet(() -> {
                    Tourist t = new Tourist();
                    t.setName(name);
                    t.setEmail(email);
                    return touristRepository.save(t);
                });

            return ResponseEntity.ok(Map.of(
                "touristId",   tourist.getId(),
                "name",        tourist.getName(),
                "email",       tourist.getEmail(),
                "firebaseUid", uid,
                "isNew",       tourist.getId() != null
            ));

        } catch (Exception e) {
            return ResponseEntity.status(401)
                .body(Map.of("error", "Invalid Firebase token"));
        }
    }

    /** GET /api/health — public ping */
    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of("status", "UP",
                                        "service", "Visit Maroc API"));
    }
}
