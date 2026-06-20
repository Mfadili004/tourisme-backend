# Ajout : Voyages & Terrains (Coupe du Monde)

## Backend (Spring Boot)
Nouveaux fichiers dans `com.tourisme.tourisme_app` :
- `model/` : `Tourist`, `Terrain`, `TerrainType`, `Voyage`, `ItineraryStep`
- `repository/` : `TouristRepository`, `TerrainRepository`, `VoyageRepository`
- `service/` : `TerrainService`, `VoyageService`, `DataSeeder`
- `controller/` : `TerrainController`, `VoyageController`
- `dto/` : `VoyageRequest`

Au démarrage, `DataSeeder` insère les 6 stades marocains de la CDM 2030
(Casablanca, Rabat, Marrakech, Agadir, Tanger, Fès) + quelques sites et terrains de sport.

### Endpoints
| Méthode | URL | Rôle |
|---|---|---|
| GET | `/api/terrains?type=STADE\|SPORT\|SITE` | liste filtrée |
| GET | `/api/terrains/{id}` | détail |
| POST/PUT/DELETE | `/api/terrains` | admin |
| GET | `/api/voyages/tourist/{touristId}` | voyages d'un touriste |
| GET | `/api/voyages/{id}` | détail + itinéraire |
| POST | `/api/voyages` | créer (body = VoyageRequest) |
| PUT/DELETE | `/api/voyages/{id}` | modifier / supprimer |

> Configure MySQL dans `application.properties` (url/username/password).

## Frontend (Flutter)
Nouveaux fichiers :
- `models/terrain.dart`, `models/voyage.dart`
- `screens/terrains_screen.dart`, `terrain_detail_screen.dart`
- `screens/voyages_screen.dart`, `voyage_detail_screen.dart`, `voyage_form_screen.dart`
- Méthodes ajoutées dans `api_service.dart`

### Brancher dans la navigation
Dans ta HomePage, ajoute deux boutons :

```dart
ElevatedButton(
  onPressed: () => Navigator.push(context,
    MaterialPageRoute(builder: (_) => const TerrainsScreen())),
  child: const Text('Stades & Terrains'),
),
ElevatedButton(
  onPressed: () => Navigator.push(context,
    MaterialPageRoute(builder: (_) => VoyagesScreen(touristId: monTouristId))),
  child: const Text('Mes Voyages'),
),
```

`monTouristId` = l'`id` renvoyé par `/api/auth/register` après le login Firebase.

### Exemple de body POST /api/voyages
```json
{
  "title": "CDM 2030 - Casablanca",
  "destination": "Casablanca",
  "startDate": "2030-06-10",
  "endDate": "2030-06-15",
  "touristId": 1,
  "stadeId": 1,
  "matchLabel": "Maroc vs Espagne - 1/8",
  "matchDate": "2030-06-12",
  "itinerary": [
    {"dayNumber":1,"orderInDay":0,"title":"Visite Médina","time":"09:00"},
    {"dayNumber":2,"orderInDay":0,"title":"Match au stade","time":"20:00","terrainId":1}
  ]
}
```
