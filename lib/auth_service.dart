import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> register(String email, String password) async {
    if (!email.endsWith("@uopeople.edu")) {
      throw Exception("A university email address is required.");
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.sendEmailVerification();
    return credential;
  }

  Future<UserCredential> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user?.emailVerified != true) {
      throw Exception("Please verify your email before using the app.");
    }

    return credential;
  }

  Future<bool> isVerifiedCampusUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    await user.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;
    final email = refreshedUser?.email ?? "";

    return refreshedUser?.emailVerified == true &&
        email.endsWith("@uopeople.edu");
  }
}
