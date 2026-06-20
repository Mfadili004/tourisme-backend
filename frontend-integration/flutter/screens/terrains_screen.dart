import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/terrain.dart';
import 'terrain_detail_screen.dart';

class TerrainsScreen extends StatefulWidget {
  const TerrainsScreen({super.key});
  @override
  State<TerrainsScreen> createState() => _TerrainsScreenState();
}

class _TerrainsScreenState extends State<TerrainsScreen> {
  String? _filter; // null=Tous, STADE, SPORT, SITE
  late Future<List<Terrain>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ApiService.getTerrains(type: _filter)
        .then((list) => list.map((e) => Terrain.fromJson(e)).toList());
  }

  void _setFilter(String? f) {
    setState(() {
      _filter = f;
      _load();
    });
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'STADE':
        return Icons.stadium;
      case 'SPORT':
        return Icons.sports_soccer;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terrains & Stades')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                _chip('Tous', null),
                _chip('Stades ⚽', 'STADE'),
                _chip('Sport', 'SPORT'),
                _chip('Sites', 'SITE'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Terrain>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Erreur: ${snap.error}'));
                }
                final items = snap.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('Aucun terrain trouvé.'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final t = items[i];
                    return ListTile(
                      leading: CircleAvatar(child: Icon(_iconFor(t.type))),
                      title: Text(t.name),
                      subtitle: Text([
                        t.city ?? '',
                        if (t.capacity != null) '${t.capacity} places',
                      ].where((s) => s.isNotEmpty).join(' • ')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TerrainDetailScreen(terrain: t),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String? value) {
    final selected = _filter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => _setFilter(value),
      ),
    );
  }
}
