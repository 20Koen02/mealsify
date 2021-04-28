import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mealsify/util/repeat_list.dart';
import 'package:mealsify/widgets/home_recipe_card.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required Function onItemTapped,
  })   : _onItemTapped = onItemTapped,
        super(key: key);

  final Function _onItemTapped;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Function _onItemTapped;

  @override
  void initState() {
    _onItemTapped = widget._onItemTapped;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20.0),
              child: Text(
                'What do you want to cook today?',
                style: GoogleFonts.lora(
                  textStyle: TextStyle(
                      color: Color(0xFF3a2318),
                      fontSize: 36,
                      height: 1.2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Container(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popular Recipes',
                              style: TextStyle(
                                color: Color(0xFF3a2318),
                                fontSize: 18,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _onItemTapped(1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'View all',
                                      style: TextStyle(
                                        color: Color(0xFFBCAEAE),
                                        fontSize: 18,
                                        height: 1.2,
                                      ),
                                    ),
                                    Icon(
                                      EvaIcons.chevronRightOutline,
                                      color: Color(0xFFBCAEAE),
                                      size: 22,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Container(
                          height: 400.0,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, position) {
                              final recipe =
                                  repeatRecipes(testRecipes, position);
                              return HomeRecipeCard(
                                image: recipe.image,
                                title: recipe.title,
                                timeToPrep: recipe.timeToPrep,
                              );
                            },
                            separatorBuilder: (context, position) {
                              return SizedBox(width: 14.0);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(
                          "Editors' Choice",
                          style: TextStyle(
                            color: Color(0xFF3a2318),
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Container(
                          height: 400.0,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, position) {
                              final recipe =
                                  repeatRecipes(testRecipes, position + 1);
                              return HomeRecipeCard(
                                image: recipe.image,
                                title: recipe.title,
                                timeToPrep: recipe.timeToPrep,
                              );
                            },
                            separatorBuilder: (context, position) {
                              return SizedBox(width: 14.0);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
