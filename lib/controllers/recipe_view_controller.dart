import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather/utils/constants.dart';
import 'package:weather/utils/status_messages.dart';
import '../models/recipe_model.dart';
import '../services/app_exception.dart';

class RecipeController extends GetxController {
  final TextEditingController recipeController = TextEditingController();
  var recipes = <RecipeModel>[].obs;
  var isLoading = false.obs;
  List<Map> favorites = [];

  @override
  void onInit() {
    recipeController.clear();
    fetchDefaultRecipes();
    super.onInit();
  }

  void fetchDefaultRecipes() async {
    isLoading.value = true;
    final defaultIngredients = "chicken,tomato,onion";
    final url = '${Constants.spoonacularBaseUrl}$defaultIngredients&number=10&apiKey=${Constants.recipeApiKey}';

    log("Fetching default recipes from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      log("Response Status: ${response.statusCode}");
      log("Response Body >>> ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        recipes.value = data.map<RecipeModel>((json) => RecipeModel.fromMap(json)).toList();
      } else {
        showErrorMessage('Failed to load default recipes');
      }
    } catch (e) {
      log("Fetch default recipes error: $e");
      handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void fetchRecipes() async {
    final ingredients = recipeController.text.trim();
    if (ingredients.isEmpty) {
      fetchDefaultRecipes();
      return;
    }

    isLoading.value = true;
    final url = '${Constants.spoonacularBaseUrl}$ingredients&number=10&apiKey=${Constants.recipeApiKey}';

    log("Fetching recipes with ingredients: $ingredients");
    log("URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isEmpty) {
          showErrorMessage('No Recipes Found, Try different ingredients');
        }
        recipes.value = data.map<RecipeModel>((json) => RecipeModel.fromMap(json)).toList();
      } else {
        showErrorMessage('Failed to fetch recipes');
      }
    } catch (e) {
      log("Fetch recipes error: $e");
      handleException(e);
    } finally {
      isLoading.value = false;
    }
  }
  void handleException(dynamic e) {
    log('Handled Exception: $e');
    if (e is AppException) {
      showErrorMessage('Error: ${e.message ?? "Unexpected error occurred"}');
    } else {
      showErrorMessage('Error: $e');
    }
  }
}
