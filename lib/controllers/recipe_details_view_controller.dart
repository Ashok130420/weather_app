import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import '../services/database_helper.dart';
import '../utils/status_messages.dart';

class RecipeDetailsViewController extends GetxController {
  var recipe = Rxn<RecipeModel>();
  final _apiKey = '94b2296383904b16a8bc1c975ba6d1c0';
  Map dataStatus = {
    "isLoading": false,
    "hasData": false,
    "hasError": false,
    "error": "",
  }.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipeDetails(Get.arguments[0]);
  }

  void fetchRecipeDetails(int id) async {
    dataStatus["isLoading"] = true;

    final url = 'https://api.spoonacular.com/recipes/$id/information?includeNutrition=false&apiKey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        recipe.value = RecipeModel.fromMap(data);
        dataStatus["hasData"] = true;
      } else {
        dataStatus["hasError"] = true;
        dataStatus["error"] = "Failed to fetch recipe details";
        showErrorMessage("Failed to fetch recipe details");
      }
    } catch (e) {
      dataStatus["hasError"] = true;
      dataStatus["error"] = e.toString();
      showErrorMessage(e.toString());
    } finally {
      dataStatus["isLoading"] = false;
    }
  }

  Future<void> saveToFavorites() async {
    if (recipe.value != null) {
      await DatabaseHelper.instance.insertRecipe(recipe.value!);
      Get.snackbar('Saved', 'Recipe added to favorites');
    }
  }
}
