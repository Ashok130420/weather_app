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
  List<RecipeModel> allRecipes = [];
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    recipeController.clear();
    fetchDefaultRecipes();
    recipeController.addListener(() {
      filterRecipesByTitle(recipeController.text);
    });
  }

  void filterRecipesByTitle(String query) {
    if (query.isEmpty) {
      recipes.value = allRecipes;
    } else {
      final filtered = allRecipes.where((recipe) => recipe.title!.toLowerCase().contains(query.toLowerCase())).toList();
      recipes.value = filtered;
    }
  }

  void fetchDefaultRecipes() async {
    isLoading.value = true;
    final defaultIngredients = "chicken,tomato,onion,garlic,pepper,";
    final url = '${Constants.spoonacularBaseUrl}$defaultIngredients&number=10&apiKey=${Constants.recipeApiKey}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        allRecipes = data.map<RecipeModel>((json) => RecipeModel.fromMap(json)).toList();
        recipes.value = allRecipes;
        for (var item in allRecipes) {
          log("Recipe >>> ${item.title}");
        }
      } else {
        showErrorMessage('Failed to load default recipes');
      }
    } catch (e) {
      handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  void handleException(dynamic e) {
    if (e is AppException) {
      showErrorMessage('Error: ${e.message ?? "Unexpected error occurred"}');
    } else {
      showErrorMessage('Error: $e');
    }
  }

  @override
  void onClose() {
    recipeController.dispose();
    super.onClose();
  }
}
