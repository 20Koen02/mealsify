import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mealsify/models/RecipeModel.dart';

class RecipeController {
  List<RecipeModel> _topRecipes = [];
  List<RecipeModel> _myRecipes = [];
  List<RecipeModel> _currentSearch = [];

  RecipeController() {
    loadTopRecipes();
  }

  Future<void> loadTopRecipes() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .limit(100)
        .get()
        .then((querySnap) {
      _topRecipes = [];
      querySnap.docs.forEach((res) {
        _topRecipes.add(new RecipeModel.fromFirestore(res));
      });
    });
  }

  void deleteRecipe(RecipeModel recipeToDelete) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(recipeToDelete.id)
        .delete()
        .then((value) => print("Post Deleted"))
        .catchError((error) => print("Failed to delete post: $error"));
  }

  Future<void> searchForRecipes(String searchQuery) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((querySnap) {
      _currentSearch = [];
      querySnap.docs.forEach((res) {
        if (res
                .data()['title']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            res
                .data()['description']
                .toLowerCase()
                .contains(searchQuery.toLowerCase())) {
          _currentSearch.add(new RecipeModel.fromFirestore(res));
        }
      });
    });
  }

  Future<void> loadMyRecipes(String uid) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(100)
        .get()
        .then((querySnap) {
      _myRecipes = [];
      querySnap.docs.forEach((res) {
        _myRecipes.add(new RecipeModel.fromFirestore(res));
      });
    });
  }

  List<RecipeModel>? get getTopRecipes => _topRecipes;

  List<RecipeModel>? get getMyRecipes => _myRecipes;

  List<RecipeModel>? get getSearchRecipes => _currentSearch;
}
