import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mealsify/util/repeat_list.dart';
import 'package:mealsify/widgets/search_bar.dart';

import '../constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List _recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  void fetchRecipes() async {
    var result = new List.generate(
        100, (index) => repeatRecipes(testRecipes, index).image);
    result.shuffle(Random.secure());
    setState(() {
      _recipes = result;
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
              child: SearchBar(),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _recipes.length != 0
                      ? RefreshIndicator(
                          onRefresh: _getData,
                          child: GridView.count(
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            children: List.generate(100, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(_recipes[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    children: [],
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
