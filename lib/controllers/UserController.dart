import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealsify/locator.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:mealsify/controllers/AuthController.dart';

import 'RecipeController.dart';

class UserController {
  late UserModel? _currentUser;
  AuthController _authController = locator.get<AuthController>();

  UserController() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        var firestoreDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
        _currentUser = UserModel.fromFirestore(firestoreDoc);
        locator.get<RecipeController>().loadMyRecipes(firebaseUser.uid);
      }
    });
  }

  UserModel? get currentUser => _currentUser;
}