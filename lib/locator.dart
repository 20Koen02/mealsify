
import 'package:get_it/get_it.dart';
import 'package:mealsify/services/AuthService.dart';

import 'services/UserService.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<UserService>(UserService());
}