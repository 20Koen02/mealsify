import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mealsify/controllers/RecipeController.dart';
import 'package:mealsify/controllers/UserController.dart';
import 'package:mealsify/models/RecipeModel.dart';
import 'package:mealsify/models/UserModel.dart';

import '../locator.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({
    Key? key,
    required RecipeModel recipe,
  })   : _recipe = recipe,
        super(key: key);

  final RecipeModel _recipe;

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late RecipeModel _recipe;
  UserModel? currentUser = locator.get<UserController>().currentUser;
  UserModel? _recipeUser;

  void getRecipeUser() async {
    var firestoreDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_recipe.uid)
        .get();
    setState(() {
      _recipeUser = new UserModel.fromFirestore(firestoreDoc);
    });
  }

  @override
  void initState() {
    _recipe = widget._recipe;
    getRecipeUser();
    super.initState( );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recipeUser != null &&
              currentUser != null &&
              _recipeUser!.uid == currentUser!.uid
          ? FloatingActionButton(
              onPressed: () {
                locator.get<RecipeController>().deleteRecipe(_recipe);
                Navigator.pop(context);
              },
              child: const Icon(
                EvaIcons.trashOutline,
              ),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            )
          : Container(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 30.0,
                  right: 15.0,
                  top: 15.0,
                  bottom: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Material(
                            color: Color(0x4d3a2318),
                            child: _recipeUser != null
                                ? Image.network(
                                    _recipeUser!.photoURL,
                                    height: 40,
                                    fit: BoxFit.fitHeight,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      EvaIcons.personOutline,
                                      size: 24,
                                      color: Color(0xFF3a2318),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          _recipeUser?.displayName ?? 'Loading user...',
                          maxLines: 10,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.2,
                          ),
                        ),
                        if (_recipeUser?.verified ?? false)
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Icon(
                              EvaIcons.checkmarkCircle2,
                              color: Color(0xFF3a2318),
                              size: 12,
                            ),
                          )
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        EvaIcons.close,
                        size: 30,
                        color: Color(0xFF3a2318),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          _recipe.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      _recipe.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.lora(
                        textStyle: TextStyle(
                            color: Color(0xFF3a2318),
                            fontSize: 34,
                            height: 1.2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      _recipe.timeToPrep.toString() + " min",
                      style: TextStyle(
                        color: Color(0xFFB8B8B8),
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      _recipe.description,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
