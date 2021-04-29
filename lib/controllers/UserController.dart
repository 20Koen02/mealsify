import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mealsify/locator.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:mealsify/controllers/AuthController.dart';

import 'RecipeController.dart';

class UserController {
  late UserModel? _currentUser;

  void setCurrentUser(DocumentSnapshot doc) {
    _currentUser = UserModel.fromFirestore(doc);
    locator.get<RecipeController>().loadMyRecipes(currentUser!.uid);
  }

  UserModel? get currentUser => _currentUser;
}