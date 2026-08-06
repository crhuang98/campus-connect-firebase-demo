import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineSyncService {
  Future<void> setupFirestoreCache() async {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  }

  void listenForCacheStatus() {
    FirebaseFirestore.instance
        .collection("announcements")
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      final fromCache = snapshot.metadata.isFromCache;

      if (fromCache) {
        print("Cached announcements are being displayed.");
      } else {
        print("Live announcements from Firestore are being displayed.");
      }
    });
  }

  void listenForPendingWrites() {
    FirebaseFirestore.instance
        .collection("announcements")
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      if (snapshot.metadata.hasPendingWrites) {
        print("Some posts are still waiting to sync.");
      } else {
        print("All visible posts have finished syncing.");
      }
    });
  }
}
