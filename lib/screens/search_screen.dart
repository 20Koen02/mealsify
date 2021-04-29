import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mealsify/models/RecipeModel.dart';
import 'package:mealsify/controllers/RecipeController.dart';
import 'package:mealsify/screens/recipe_screen.dart';
import 'package:mealsify/widgets/search_bar.dart';

import '../locator.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<RecipeModel>? _recipes = locator.get<RecipeController>().getTopRecipes;
  List<RecipeModel>? _searchRecipes =
      locator.get<RecipeController>().getSearchRecipes;
  bool searching = false;

  List<RecipeModel>? _getRecipes() {
    return searching ? _searchRecipes : _recipes;
  }

  void setSearching(bool enabled) {
    setState(() {
      searching = enabled;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  void searchRecipes(String searchQuery) async {
    await locator.get<RecipeController>().searchForRecipes(searchQuery);
    setState(() {
      _searchRecipes = locator.get<RecipeController>().getSearchRecipes;
    });
  }

  void fetchRecipes() async {
    await locator.get<RecipeController>().loadTopRecipes();
    setState(() {
      _recipes = locator.get<RecipeController>().getTopRecipes;
    });
  }

  Future<void> _getData() async {
    setState(() {
      fetchRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SearchBar(
                searchRecipes: searchRecipes,
                searching: setSearching,
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _getRecipes() != null
                      ? RefreshIndicator(
                          onRefresh: _getData,
                          child: GridView.count(
                            crossAxisCount: 2,
                            children: List.generate(min(_getRecipes()!.length, 100),
                                (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipeScreen(
                                            recipe: _getRecipes()![index])),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            _getRecipes()![index].image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Column(
                                      children: [],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
