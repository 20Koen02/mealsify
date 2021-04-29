import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mealsify/models/RecipeModel.dart';
import 'package:mealsify/models/UserModel.dart';
import 'package:mealsify/controllers/RecipeController.dart';
import 'package:mealsify/controllers/UserController.dart';
import 'package:mealsify/screens/recipe_screen.dart';
import '../locator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<RecipeModel>? _recipes = locator.get<RecipeController>().getTopRecipes;
  UserModel? currentUser = locator.get<UserController>().currentUser;


  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  void fetchRecipes() async {
    if (currentUser != null) {
      await locator.get<RecipeController>().loadMyRecipes(currentUser!.uid);
      setState(() {
        _recipes = locator.get<RecipeController>().getMyRecipes;
      });
    }
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
        child: DefaultTabController(
          length: 1,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        // TODO: Edit Profile
                        // Padding(
                        //   padding: const EdgeInsets.all(15.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Icon(
                        //         EvaIcons.editOutline,
                        //         size: 30,
                        //         color: Color(0xFF3a2318),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 60.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Material(
                            color: Color(0x4d3a2318),
                            child: currentUser != null
                                ? Image.network(
                                    currentUser!.photoURL,
                                    height: 120,
                                    fit: BoxFit.fitHeight,
                                  )
                                : Icon(
                                    EvaIcons.personOutline,
                                    size: 120,
                                    color: Color(0xFF3a2318),
                                  ),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentUser?.displayName ?? 'Loading User...',
                              style: TextStyle(
                                color: Color(0xFF3a2318),
                                fontSize: 40,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (currentUser?.verified ?? false)
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  EvaIcons.checkmarkCircle2,
                                  color: Color(0xFF3a2318),
                                ),
                              )
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          currentUser?.bio ?? '',
                          style: TextStyle(
                            color: Color(0xFFB8B8B8),
                            fontSize: 20,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 25.0),
                      ],
                    )
                  ]),
                ),
              ];
            },
            body: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Your Recipes",
                        style: TextStyle(
                          color: Color(0xFF3a2318),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // TODO: Following Page
                    // Tab(
                    //   child: Text(
                    //     "Following",
                    //     style: TextStyle(
                    //       color: Color(0xFF3a2318),
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _recipes != null
                            ? RefreshIndicator(
                                onRefresh: _getData,
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  children: List.generate(_recipes!.length, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RecipeScreen(
                                                  recipe: _recipes![index])),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  _recipes![index].image),
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
                      // TODO: Following Page
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: _recipes.length != 0
                      //       ? RefreshIndicator(
                      //           onRefresh: _getData,
                      //           child: ListView.separated(
                      //             itemCount: 10,
                      //             itemBuilder: (context, position) {
                      //               final recipe = _recipes[position];
                      //               return BigRecipeCard(
                      //                 image: recipe.image,
                      //                 title: recipe.title,
                      //                 timeToPrep: recipe.timeToPrep,
                      //               );
                      //             },
                      //             separatorBuilder: (context, position) {
                      //               return SizedBox(width: 14.0);
                      //             },
                      //           ),
                      //         )
                      //       : Center(child: CircularProgressIndicator()),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
