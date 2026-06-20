import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/voyage.dart';

class VoyageDetailScreen extends StatefulWidget {
  final int voyageId;
  const VoyageDetailScreen({super.key, required this.voyageId});
  @override
  State<VoyageDetailScreen> createState() => _VoyageDetailScreenState();
}

class _VoyageDetailScreenState extends State<VoyageDetailScreen> {
  late Future<Voyage> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getVoyage(widget.voyageId).then(Voyage.fromJson);
  }

  Future<void> _delete() async {
    await ApiService.deleteVoyage(widget.voyageId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du voyage'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: FutureBuilder<Voyage>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erreur: ${snap.error}'));
          }
          final v = snap.data!;
          // group itinerary by day
          final byDay = <int, List<ItineraryStep>>{};
          for (final s in v.itinerary) {
            byDay.putIfAbsent(s.dayNumber ?? 0, () => []).add(s);
          }
          final days = byDay.keys.toList()..sort();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(v.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              if (v.destination != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('📍 ${v.destination}'),
                ),
              if (v.startDate != null)
                Text('🗓 ${v.startDate} → ${v.endDate}'),
              if (v.stade != null || v.matchLabel != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚽ Match Coupe du Monde',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        if (v.matchLabel != null) Text(v.matchLabel!),
                        if (v.matchDate != null) Text('Date : ${v.matchDate}'),
                        if (v.stade != null)
                          Text('Stade : ${v.stade!.name} (${v.stade!.city})'),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text('Itinéraire',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (days.isEmpty)
                const Text('Aucune étape ajoutée.')
              else
                for (final d in days) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Text('Jour $d',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange)),
                  ),
                  for (final s in byDay[d]!)
                    ListTile(
                      dense: true,
                      leading: Text(s.time ?? '—'),
                      title: Text(s.title ?? ''),
                      subtitle: Text([
                        if (s.terrain != null) '📌 ${s.terrain!.name}',
                        if (s.notes != null) s.notes!,
                      ].where((x) => x.isNotEmpty).join('\n')),
                    ),
                ],
            ],
          );
        },
      ),
    );
  }
}
