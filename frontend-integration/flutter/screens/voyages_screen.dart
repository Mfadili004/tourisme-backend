import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/voyage.dart';
import 'voyage_detail_screen.dart';
import 'voyage_form_screen.dart';

class VoyagesScreen extends StatefulWidget {
  final int touristId;
  const VoyagesScreen({super.key, required this.touristId});
  @override
  State<VoyagesScreen> createState() => _VoyagesScreenState();
}

class _VoyagesScreenState extends State<VoyagesScreen> {
  late Future<List<Voyage>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = ApiService.getVoyages(widget.touristId)
        .then((list) => list.map((e) => Voyage.fromJson(e)).toList());
  }

  Future<void> _refresh() async => setState(_load);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Voyages')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nouveau'),
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => VoyageFormScreen(touristId: widget.touristId),
            ),
          );
          if (created == true) _refresh();
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Voyage>>(
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
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Aucun voyage. Appuyez sur +')),
                ],
              );
            }
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final v = items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.luggage, size: 32),
                    title: Text(v.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text([
                      v.destination ?? '',
                      if (v.matchLabel != null) '⚽ ${v.matchLabel}',
                      if (v.startDate != null) '${v.startDate} → ${v.endDate}',
                    ].where((s) => s.isNotEmpty).join('\n')),
                    isThreeLine: v.matchLabel != null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VoyageDetailScreen(voyageId: v.id!),
                      ),
                    ).then((_) => _refresh()),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
