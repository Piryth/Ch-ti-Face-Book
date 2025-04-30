import 'package:firebase_auth/firebase_auth.dart';

class ServiceAuthentification {

  final instance = FirebaseAuth.instance;

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return email;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<String?> createAccount({
    required String email,
    required String password,
    required String surname,
    required String name,
  }) async {
    await instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return email;
  }

  Future signOut() async {
    try {
      await instance.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  String? get myId => instance.currentUser?.uid;

}
