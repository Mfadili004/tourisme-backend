# GUIDE DE CONFIGURATION — Visit Maroc Full Stack

## ÉTAPE 1 — Créer le projet Firebase

1. Va sur https://console.firebase.google.com
2. Clique "Add project" → nom: "visit-maroc"
3. Désactive Google Analytics (optionnel)
4. Clique "Create project"

---

## ÉTAPE 2 — Activer Firebase Authentication

1. Dans Firebase Console → Authentication → Get started
2. Onglet "Sign-in method" → Active "Email/Password"
3. Clique Save

---

## ÉTAPE 3 — Configurer le backend Spring Boot

### 3a. Télécharger le fichier Service Account
1. Firebase Console → Project Settings (⚙️)
2. Onglet "Service accounts"
3. Clique "Generate new private key"
4. Télécharge le fichier JSON
5. Renomme-le: `firebase-service-account.json`
6. Place-le dans: `src/main/resources/`

### 3b. Ajouter les dépendances (pom.xml)
Copie le contenu de `pom_firebase_additions.xml` dans ton pom.xml

### 3c. Copier les fichiers Java
Copie ces fichiers dans `src/main/java/com/tourisme/tourisme_app/config/`:
- FirebaseConfig.java
- FirebaseAuthFilter.java

Copie dans `src/main/java/com/tourisme/tourisme_app/controller/`:
- AuthController.java

---

## ÉTAPE 4 — Configurer l'app Flutter

### 4a. Enregistrer l'app Android dans Firebase
1. Firebase Console → Project Overview → Add app → Android
2. Package name: com.example.tourisme_app  (vérifie dans AndroidManifest.xml)
3. Télécharge `google-services.json`
4. Place-le dans le dossier `android/app/` de ton projet Flutter

### 4b. Modifier android/build.gradle (project level)
```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
  }
}
```

### 4c. Modifier android/app/build.gradle
```gradle
apply plugin: 'com.google.gms.google-services'
```

### 4d. Ajouter les dépendances Flutter
Copie le contenu de `pubspec_additions.yaml` dans ton pubspec.yaml
Puis: flutter pub get

### 4e. Copier les fichiers Dart dans lib/
- main.dart
- auth_service.dart
- api_service.dart

---

## ÉTAPE 5 — Changer l'adresse du serveur

Dans `api_service.dart`, ligne 12:
- Émulateur Android: `http://10.0.2.2:8080/api`
- Appareil réel sur même WiFi: `http://192.168.X.X:8080/api`
- Production: `https://ton-domaine.com/api`

---

## FLUX COMPLET — Comment tout fonctionne

```
USER               FLUTTER               FIREBASE            SPRING BOOT         MYSQL
 |                    |                     |                    |                  |
 |-- email/password ->|                     |                    |                  |
 |                    |-- createUser() ---->|                    |                  |
 |                    |<-- Firebase Token --|                    |                  |
 |                    |                     |                    |                  |
 |                    |-- POST /auth/register (token) ---------->|                  |
 |                    |                     |   verifyToken() -->|                  |
 |                    |                     |<-- UID, email -----|                  |
 |                    |                     |                    |-- INSERT tourist->|
 |                    |<-- { touristId: 5 } --------------------|                  |
 |                    |                     |                    |                  |
 |-- View Hotels ---->|                     |                    |                  |
 |                    |-- GET /recommend/hotels/5 (token) ------>|                  |
 |                    |                     |   verifyToken() -->|                  |
 |                    |                     |                    |-- SELECT hotels ->|
 |<-- Hotel List -----|<-- [hotels JSON] ---|------------------- |                  |
```

---

## SÉCURITÉ — Points importants

| Point | Status |
|-------|--------|
| Mot de passe non visible | ✅ Variable d'environnement |
| Token Firebase vérifié côté serveur | ✅ FirebaseAuthFilter |
| CORS configuré pour Flutter | ✅ CorsConfig |
| Routes publiques (health, register) | ✅ WhiteList dans Filter |
| Gestion d'erreurs 404/400/500 | ✅ GlobalExceptionHandler |

