import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk Register
  Future<String?> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(), // Catat waktu pendaftaran
      });

      return "Berhasil Daftar";
    } on FirebaseAuthException catch (e) {
      return e.message; 
    } catch (e) {
      return e.toString();
    }
  }

  // Fungsi untuk Login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return "Berhasil Login";
    } on FirebaseAuthException catch (e) {
      return e.message; 
    }
  }

  // Fungsi untuk Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}