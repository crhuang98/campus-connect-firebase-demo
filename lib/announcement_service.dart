import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnnouncementService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createAnnouncement({
    required String title,
    required String body,
    required String authorId,
    required String authorRole,
  }) async {
    await _db.collection("announcements").add({
      "title": title,
      "body": body,
      "authorId": authorId,
      "authorRole": authorRole,
      "createdAt": FieldValue.serverTimestamp(),
      "visibility": "campus",
    });
  }

  Stream<List<Map<String, dynamic>>> watchAnnouncements() {
    return _db
        .collection("announcements")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "title": data["title"] ?? "",
          "body": data["body"] ?? "",
          "authorId": data["authorId"] ?? "",
        };
      }).toList();
    });
  }

  Future<void> createPostWhileOffline({
    required String title,
    required String body,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Authentication is required.");
    }

    await _db.collection("announcements").add({
      "title": title,
      "body": body,
      "authorId": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
      "syncStatus": "pending",
    });
  }
}
