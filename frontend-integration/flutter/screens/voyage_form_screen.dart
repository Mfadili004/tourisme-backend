import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/terrain.dart';

/// Create a new voyage: title, destination, dates,
/// optional stadium + match, and itinerary steps.
class VoyageFormScreen extends StatefulWidget {
  final int touristId;
  const VoyageFormScreen({super.key, required this.touristId});
  @override
  State<VoyageFormScreen> createState() => _VoyageFormScreenState();
}

class _VoyageFormScreenState extends State<VoyageFormScreen> {
  final _title = TextEditingController();
  final _destination = TextEditingController();
  final _matchLabel = TextEditingController();
  DateTime? _start, _end, _matchDate;

  List<Terrain> _stades = [];
  Terrain? _selectedStade;

  final List<_StepDraft> _steps = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    ApiService.getTerrains(type: 'STADE').then((list) {
      setState(() =>
          _stades = list.map((e) => Terrain.fromJson(e)).toList());
    });
  }

  Future<DateTime?> _pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2032),
      );

  String? _fmt(DateTime? d) =>
      d == null ? null : d.toIso8601String().split('T').first;

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le titre est obligatoire')));
      return;
    }
    setState(() => _saving = true);
    try {
      final body = {
        'title': _title.text.trim(),
        'destination': _destination.text.trim(),
        'startDate': _fmt(_start),
        'endDate': _fmt(_end),
        'touristId': widget.touristId,
        'stadeId': _selectedStade?.id,
        'matchLabel':
            _matchLabel.text.trim().isEmpty ? null : _matchLabel.text.trim(),
        'matchDate': _fmt(_matchDate),
        'itinerary': _steps
            .asMap()
            .entries
            .map((e) => {
                  'dayNumber': e.value.day,
                  'orderInDay': e.key,
                  'title': e.value.title.text,
                  'time': e.value.time.text,
                  'notes': e.value.notes.text,
                })
            .toList(),
      };
      await ApiService.createVoyage(body);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau voyage')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Titre *'),
          ),
          TextField(
            controller: _destination,
            decoration: const InputDecoration(labelText: 'Destination'),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final d = await _pickDate();
                  if (d != null) setState(() => _start = d);
                },
                child: Text(_start == null
                    ? 'Date début'
                    : _fmt(_start)!),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final d = await _pickDate();
                  if (d != null) setState(() => _end = d);
                },
                child: Text(_end == null ? 'Date fin' : _fmt(_end)!),
              ),
            ),
          ]),
          const Divider(height: 32),
          const Text('⚽ Match Coupe du Monde (optionnel)',
              style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<Terrain>(
            isExpanded: true,
            hint: const Text('Choisir un stade'),
            value: _selectedStade,
            items: _stades
                .map((s) => DropdownMenuItem(
                    value: s, child: Text('${s.name} — ${s.city}')))
                .toList(),
            onChanged: (s) => setState(() => _selectedStade = s),
          ),
          TextField(
            controller: _matchLabel,
            decoration: const InputDecoration(
                labelText: 'Match (ex: Maroc vs Espagne)'),
          ),
          OutlinedButton(
            onPressed: () async {
              final d = await _pickDate();
              if (d != null) setState(() => _matchDate = d);
            },
            child: Text(_matchDate == null
                ? 'Date du match'
                : 'Match : ${_fmt(_matchDate)}'),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Itinéraire',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Étape'),
                onPressed: () =>
                    setState(() => _steps.add(_StepDraft())),
              ),
            ],
          ),
          for (int i = 0; i < _steps.length; i++) _stepCard(i),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const CircularProgressIndicator()
                : const Text('Enregistrer le voyage'),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(int i) {
    final s = _steps[i];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Row(children: [
            SizedBox(
              width: 60,
              child: TextField(
                controller: s.day,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jour'),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: s.time,
                decoration: const InputDecoration(labelText: 'Heure'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _steps.removeAt(i)),
            ),
          ]),
          TextField(
            controller: s.title,
            decoration: const InputDecoration(labelText: 'Activité'),
          ),
          TextField(
            controller: s.notes,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
        ]),
      ),
    );
  }
}

class _StepDraft {
  final day = TextEditingController(text: '1');
  final time = TextEditingController();
  final title = TextEditingController();
  final notes = TextEditingController();
}
