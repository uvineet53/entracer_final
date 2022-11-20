import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveUser(String email, String password) async {
    await _firestore.collection("users").doc(email).set({
      "email": email,
      "password": password,
    });
  }
}
