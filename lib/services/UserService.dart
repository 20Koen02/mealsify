import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealsify/locator.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:mealsify/services/AuthService.dart';

class UserService {
  late UserModel? _currentUser;
  AuthService _authService = locator.get<AuthService>();

  UserService() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        var firestoreDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
        _currentUser = UserModel.fromFirestore(firestoreDoc);
      }
    });
  }

  UserModel? get currentUser => _currentUser;
}