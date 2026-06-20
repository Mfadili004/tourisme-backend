import 'terrain.dart';

class ItineraryStep {
  final int? dayNumber;
  final int? orderInDay;
  final String? title;
  final String? time;
  final String? notes;
  final Terrain? terrain;

  ItineraryStep({
    this.dayNumber,
    this.orderInDay,
    this.title,
    this.time,
    this.notes,
    this.terrain,
  });

  factory ItineraryStep.fromJson(Map<String, dynamic> j) => ItineraryStep(
        dayNumber: j['dayNumber'],
        orderInDay: j['orderInDay'],
        title: j['title'],
        time: j['time'],
        notes: j['notes'],
        terrain: j['terrain'] != null ? Terrain.fromJson(j['terrain']) : null,
      );

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'orderInDay': orderInDay,
        'title': title,
        'time': time,
        'notes': notes,
        'terrainId': terrain?.id,
      };
}

class Voyage {
  final int? id;
  final String title;
  final String? destination;
  final String? startDate;
  final String? endDate;
  final Terrain? stade;
  final String? matchLabel;
  final String? matchDate;
  final List<ItineraryStep> itinerary;

  Voyage({
    this.id,
    required this.title,
    this.destination,
    this.startDate,
    this.endDate,
    this.stade,
    this.matchLabel,
    this.matchDate,
    this.itinerary = const [],
  });

  factory Voyage.fromJson(Map<String, dynamic> j) => Voyage(
        id: j['id'],
        title: j['title'],
        destination: j['destination'],
        startDate: j['startDate'],
        endDate: j['endDate'],
        stade: j['stade'] != null ? Terrain.fromJson(j['stade']) : null,
        matchLabel: j['matchLabel'],
        matchDate: j['matchDate'],
        itinerary: (j['itinerary'] as List? ?? [])
            .map((e) => ItineraryStep.fromJson(e))
            .toList(),
      );
}
