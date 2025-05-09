import 'package:get/get.dart';
import '../models/recipe_model.dart';
import '../services/database_helper.dart';

class FavoriteViewController extends GetxController {
  var favoriteItems = <RecipeModel>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    final recipes = await DatabaseHelper.instance.getFavoriteRecipes();
    favoriteItems.assignAll(recipes);
    isLoading.value = false;
  }

  Future<void> removeFromFavorites(int id) async {
    await DatabaseHelper.instance.deleteRecipe(id);
    favoriteItems.removeWhere((recipe) => recipe.id == id);
  }
}
