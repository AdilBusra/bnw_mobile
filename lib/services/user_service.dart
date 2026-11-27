import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  static final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  /// READ: Stream data profil user yang sedang login
  static Stream<UserModel?> currentUserStream() {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) {
      return Stream.value(null);
    }

    return _usersRef.doc(authUser.uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(doc.data() as Map),
          docId: doc.id,
        );
      }
      return UserModel(
        uid: authUser.uid,
        name: (authUser.displayName?.trim().isNotEmpty ?? false)
            ? authUser.displayName!.trim()
            : 'Traveler',
        email: authUser.email ?? '',
      );
    });
  }

  /// UPDATE: Simpan perubahan nama, nomor telepon, dan avatar ke Firestore
  static Future<void> updateProfile({
    required String name,
    required String phone,
    required String photoAsset,
  }) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    final cleanName = name.trim();
    await _usersRef.doc(authUser.uid).set({
      'uid': authUser.uid,
      'name': cleanName,
      'email': authUser.email ?? '',
      'phone': phone.trim(),
      'photoAsset': photoAsset,
      'active': true,
    }, SetOptions(merge: true));

    if (cleanName.isNotEmpty) {
      await authUser.updateDisplayName(cleanName);
    }
  }

  /// CREATE / DELETE Wishlist: Tambah atau hapus trip dari daftar favorit user
  static Future<void> toggleSavedTrip(String tripId, {required bool currentlySaved}) async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null || tripId.trim().isEmpty) return;

    await _usersRef.doc(authUser.uid).set({
      'uid': authUser.uid,
      'email': authUser.email ?? '',
      'savedTripIds': currentlySaved
          ? FieldValue.arrayRemove([tripId])
          : FieldValue.arrayUnion([tripId]),
    }, SetOptions(merge: true));
  }
}