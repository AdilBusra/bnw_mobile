import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoAsset;
  final String? photoBase64;
  final List<String> savedTripIds;
  final bool active;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.photoAsset = 'assets/images/profile.png',
    this.photoBase64,
    this.savedTripIds = const [],
    this.active = true,
    this.createdAt,
  });

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'photoAsset': photoAsset,
        'photoBase64': photoBase64,
        'savedTripIds': savedTripIds,
        'active': active,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    final rawSaved = json['savedTripIds'];
    final savedIds = rawSaved is List
        ? rawSaved.map((e) => e.toString()).toList()
        : <String>[];

    return UserModel(
      uid: (json['uid'] as String?) ?? docId ?? '',
      name: (json['name'] as String?) ??
          (json['displayName'] as String?) ??
          'Traveler',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      photoAsset: (json['photoAsset'] as String?)?.isNotEmpty == true
          ? json['photoAsset'] as String
          : 'assets/images/profile.png',
      photoBase64: json['photoBase64'] as String?,
      savedTripIds: savedIds,
      active: json['active'] is bool ? json['active'] as bool : true,
      createdAt: _parseDate(json['createdAt']),
    );
  }
}