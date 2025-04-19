import 'package:get/get.dart';
import '../models/recipe_model.dart';
import '../services/database_helper.dart';

class FavoriteViewController extends GetxController {
  var favoriteItems = <RecipeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final recipes = await DatabaseHelper.instance.getFavoriteRecipes();
    favoriteItems.assignAll(recipes);
  }

  Future<void> removeFromFavorites(int id) async {
    await DatabaseHelper.instance.deleteRecipe(id);
    favoriteItems.removeWhere((recipe) => recipe.id == id);
  }
}
