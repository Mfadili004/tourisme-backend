package com.tourisme.tourisme_app.config;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

/**
 * Intercepts every request and verifies Firebase JWT token.
 * Flutter sends:  Authorization: Bearer <firebase_id_token>
 */
@Component
public class FirebaseAuthFilter extends OncePerRequestFilter {

    private static final String[] PUBLIC_PATHS = {
        "/api/auth", "/api/health"
    };

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();

        // Allow public routes without token
        for (String pub : PUBLIC_PATHS) {
            if (path.startsWith(pub)) {
                filterChain.doFilter(request, response);
                return;
            }
        }

        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            sendError(response, 401, "Missing or invalid Authorization header");
            return;
        }

        String idToken = authHeader.substring(7);

        try {
            FirebaseToken decoded =
                FirebaseAuth.getInstance().verifyIdToken(idToken);

            // Inject Firebase user info into request attributes
            request.setAttribute("uid",   decoded.getUid());
            request.setAttribute("email", decoded.getEmail());
            request.setAttribute("name",  decoded.getName());

            filterChain.doFilter(request, response);

        } catch (Exception e) {
            sendError(response, 401, "Invalid or expired Firebase token");
        }
    }

    private void sendError(HttpServletResponse resp,
                           int status, String message) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.getWriter().write(
            "{\"error\":" + status + ",\"message\":\"" + message + "\"}");
    }
}
