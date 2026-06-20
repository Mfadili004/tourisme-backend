import 'package:flutter/material.dart';
import '../models/terrain.dart';

class TerrainDetailScreen extends StatelessWidget {
  final Terrain terrain;
  const TerrainDetailScreen({super.key, required this.terrain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(terrain.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (terrain.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(terrain.imageUrl!,
                  height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          _row(Icons.category, 'Type', terrain.type),
          if (terrain.city != null) _row(Icons.location_city, 'Ville', terrain.city!),
          if (terrain.address != null) _row(Icons.map, 'Adresse', terrain.address!),
          if (terrain.capacity != null)
            _row(Icons.people, 'Capacité', '${terrain.capacity} places'),
          if (terrain.latitude != null && terrain.longitude != null)
            _row(Icons.gps_fixed, 'Coordonnées',
                '${terrain.latitude}, ${terrain.longitude}'),
          if (terrain.description != null) ...[
            const SizedBox(height: 16),
            Text(terrain.description!,
                style: const TextStyle(fontSize: 15, height: 1.4)),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Text('$label : ',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
