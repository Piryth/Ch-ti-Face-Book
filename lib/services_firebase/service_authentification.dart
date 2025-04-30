import 'package:firebase_auth/firebase_auth.dart';

class ServiceAuthentification {

  final instance = FirebaseAuth.instance;

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    return "";
  }

  Future<String?> createAccount({
    required String email,
    required String password,
    required String surname,
    required String name,
  }) async {
    return "";
  }

  Future<bool> signOut() async {
    return false;
  }

  String? get myId => instance.currentUser?.uid;

}
