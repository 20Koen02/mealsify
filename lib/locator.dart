
import 'package:get_it/get_it.dart';
import 'package:mealsify/controllers/AuthController.dart';
import 'package:mealsify/controllers/RecipeController.dart';

import 'controllers/UserController.dart';

final locator = GetIt.instance;

void setupControllers() {
  locator.registerSingleton<UserController>(UserController());
  locator.registerSingleton<AuthController>(AuthController());
  locator.registerSingleton<RecipeController>(RecipeController());
}