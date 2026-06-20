import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

/// Handles all Firebase Authentication logic
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Key for storing touristId locally
  static const String _touristIdKey = 'tourist_id';

  /// Get current logged-in user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── REGISTER WITH EMAIL ─────────────────────────────

  Future<int> registerWithEmail(String email, String password) async {
    // 1. Create user in Firebase
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Register in our MySQL via Spring Boot
    final data = await ApiService.registerTourist();
    final touristId = data['touristId'] as int;

    // 3. Save touristId locally
    await _storage.write(
      key: _touristIdKey,
      value: touristId.toString(),
    );

    return touristId;
  }

  // ── LOGIN WITH EMAIL ────────────────────────────────

  Future<int> loginWithEmail(String email, String password) async {
    // 1. Sign in with Firebase
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 2. Sync with Spring Boot (creates user if not exists)
    final data = await ApiService.registerTourist();
    final touristId = data['touristId'] as int;

    // 3. Save touristId locally
    await _storage.write(
      key: _touristIdKey,
      value: touristId.toString(),
    );

    return touristId;
  }

  // ── GET TOURIST ID ──────────────────────────────────

  Future<int?> getTouristId() async {
    final value = await _storage.read(key: _touristIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  // ── LOGOUT ──────────────────────────────────────────

  Future<void> logout() async {
    await _auth.signOut();
    await _storage.delete(key: _touristIdKey);
  }

  // ── RESET PASSWORD ──────────────────────────────────

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
