import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import '../services/database_helper.dart';
import '../views/recipe_details_view.dart';

class RecipeController extends GetxController {
  final TextEditingController ingredientController = TextEditingController();
  var recipes = <RecipeModel>[].obs;
  var isLoading = false.obs;
  final _apiKey = '94b2296383904b16a8bc1c975ba6d1c0';
  List<Map> favorites = [];

  @override
  void onInit() {
    ingredientController.clear();
    fetchDefaultRecipes();
    super.onInit();
  }

  void fetchDefaultRecipes() async {
    isLoading.value = true;
    final defaultIngredients = "chicken,tomato,onion";
    final url = 'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$defaultIngredients&number=10&apiKey=$_apiKey';

    log("Fetching default recipes from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      log("Response Status: ${response.statusCode}");
      log("Response Body >>> ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        recipes.value = data.map<RecipeModel>((json) => RecipeModel.fromMap(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load default recipes');
      }
    } catch (e) {
      log("Fetch default recipes error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchRecipes() async {
    final ingredients = ingredientController.text.trim();
    if (ingredients.isEmpty) {
      fetchDefaultRecipes(); // fallback to default if empty
      return;
    }

    isLoading.value = true;
    final url = 'https://api.spoonacular.com/recipes/findByIngredients?ingredients=$ingredients&number=10&apiKey=$_apiKey';

    print("Fetching recipes with ingredients: $ingredients");
    print("URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isEmpty) {
          Get.snackbar('No Recipes Found', 'Try different ingredients');
        }
        recipes.value = data.map<RecipeModel>((json) => RecipeModel.fromMap(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch recipes');
      }
    } catch (e) {
      print("Fetch recipes error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void showRecipeDetailsDialog(RecipeModel recipe) {
    Get.defaultDialog(
      title: recipe.title ?? "",
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.image ?? ""),
            SizedBox(height: 10),
            Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.extendedIngredients!.map((ing) => Text("- $ing")).toList(),
            SizedBox(height: 10),
            Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(recipe.instructions ?? 'No instructions available.'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.favorite),
              label: Text("Save to Favorites"),
              onPressed: () async {
                // Save to favorites logic here
                await DatabaseHelper.instance.insertRecipe(recipe);
                Get.back();
                Get.snackbar('Saved', 'Recipe added to favorites');
              },
            ),
          ],
        ),
      ),
      textConfirm: 'Close',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
}
