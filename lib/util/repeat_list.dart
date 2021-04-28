import '../constants.dart';

Recipe repeatRecipes(List<Recipe> list, int id) {
  return list[id % list.length];
}