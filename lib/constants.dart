class Recipe {
  String image;
  String title;
  int timeToPrep;

  Recipe(this.image, this.title, this.timeToPrep);
}

final List<Recipe> testRecipes = [
  new Recipe("https://i.postimg.cc/JzKNSLhx/burger.jpg", "Chicken burger", 20),
  new Recipe("https://i.postimg.cc/43d6gS7g/salmon.jpg", "Salmon on toast", 20),
  new Recipe("https://i.postimg.cc/nL6whPs6/tacos.jpg", "Birria Tacos", 20),
];