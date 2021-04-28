import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  String displayName;
  String photoURL;
  String bio;
  bool verified;

  UserModel(this.uid,
      {required this.displayName,
      required this.photoURL,
      required this.bio,
      required this.verified});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data()!;

    return UserModel(
      doc.id,
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'] ?? '',
      bio: data['bio'] ?? 'I love food!',
      verified: data['verified'] ?? false,
    );
  }
}
