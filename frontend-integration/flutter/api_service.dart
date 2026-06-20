import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

/// Service for all calls to the Spring Boot API
class ApiService {
  
  // Change this to your server IP when testing on real device
  // Use 10.0.2.2 for Android emulator (= localhost on PC)
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  /// Returns headers with valid Firebase token
  static Future<Map<String, String>> _authHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    
    final token = await user.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── AUTH ─────────────────────────────────────────────

  /// Register in MySQL after Firebase login
  static Future<Map<String, dynamic>> registerTourist() async {
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': token}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Registration failed: ${response.body}');
  }

  // ── BUDGET ───────────────────────────────────────────

  static Future<Map<String, dynamic>> createBudget(
      int touristId, double total) async {
    final response = await http.post(
      Uri.parse('$baseUrl/budget/create/$touristId/$total'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 201) return jsonDecode(response.body);
    throw Exception('Create budget failed: ${response.body}');
  }

  static Future<Map<String, dynamic>> getBudget(int touristId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/budget/$touristId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get budget failed: ${response.body}');
  }

  static Future<Map<String, dynamic>> spend(
      int touristId, String category, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/budget/spend/$touristId/$category/$amount'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Spend failed: ${response.body}');
  }

  // ── RECOMMENDATIONS ──────────────────────────────────

  static Future<List<dynamic>> getRecommendedHotels(int touristId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recommend/hotels/$touristId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get hotels failed: ${response.body}');
  }

  static Future<List<dynamic>> getRecommendedActivities(int touristId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recommend/activities/$touristId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get activities failed: ${response.body}');
  }

  // ── ALLERGENS ────────────────────────────────────────

  static Future<List<dynamic>> getSafeFoods(int touristId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/allergen/safe/$touristId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get safe foods failed: ${response.body}');
  }

  static Future<bool> isFoodSafe(int touristId, int foodId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/allergen/check/$touristId/$foodId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Check food failed: ${response.body}');
  }

  // ── ROUTE / ITINERARY ────────────────────────────────

  static Future<Map<String, dynamic>> getItinerary(
      int hotelId, List<int> activityIds) async {
    final ids = activityIds.join(',');
    final response = await http.get(
      Uri.parse('$baseUrl/route/$hotelId?activities=$ids'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get itinerary failed: ${response.body}');
  }

  // ── TERRAINS (stades / sport / sites) ────────────────

  /// type = STADE | SPORT | SITE  (null = all)
  static Future<List<dynamic>> getTerrains({String? type, String? city}) async {
    final params = <String, String>{};
    if (type != null) params['type'] = type;
    if (city != null) params['city'] = city;
    final uri = Uri.parse('$baseUrl/terrains')
        .replace(queryParameters: params.isEmpty ? null : params);
    final response = await http.get(uri, headers: await _authHeaders());
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get terrains failed: ${response.body}');
  }

  static Future<Map<String, dynamic>> getTerrain(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/terrains/$id'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get terrain failed: ${response.body}');
  }

  // ── VOYAGES ──────────────────────────────────────────

  static Future<List<dynamic>> getVoyages(int touristId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/voyages/tourist/$touristId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get voyages failed: ${response.body}');
  }

  static Future<Map<String, dynamic>> getVoyage(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/voyages/$id'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('Get voyage failed: ${response.body}');
  }

  /// body matches VoyageRequest on the backend
  static Future<Map<String, dynamic>> createVoyage(
      Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/voyages'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Create voyage failed: ${response.body}');
  }

  static Future<void> deleteVoyage(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/voyages/$id'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Delete voyage failed: ${response.body}');
    }
  }
}
