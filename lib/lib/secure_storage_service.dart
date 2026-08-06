import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String> getFirebaseIdToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Authentication is required.");
    }

    return await user.getIdToken(true);
  }

  Future<void> saveSecureToken(String token) async {
    await secureStorage.write(
      key: "firebase_id_token",
      value: token,
    );
  }

  Future<String?> readSecureToken() async {
    return await secureStorage.read(key: "firebase_id_token");
  }

  Future<void> clearSecureToken() async {
    await secureStorage.delete(key: "firebase_id_token");
  }
}
