/// Matches backend Terrain entity.
class Terrain {
  final int id;
  final String name;
  final String type; // STADE | SPORT | SITE
  final String? city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? capacity;
  final String? imageUrl;
  final String? description;

  Terrain({
    required this.id,
    required this.name,
    required this.type,
    this.city,
    this.address,
    this.latitude,
    this.longitude,
    this.capacity,
    this.imageUrl,
    this.description,
  });

  factory Terrain.fromJson(Map<String, dynamic> j) => Terrain(
        id: j['id'],
        name: j['name'],
        type: j['type'],
        city: j['city'],
        address: j['address'],
        latitude: (j['latitude'] as num?)?.toDouble(),
        longitude: (j['longitude'] as num?)?.toDouble(),
        capacity: j['capacity'],
        imageUrl: j['imageUrl'],
        description: j['description'],
      );
}
