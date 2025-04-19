import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/recipe_details_view_controller.dart';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'package:html/parser.dart' as html_parser;

import '../utils/app_colors.dart';

class RecipeDetailsView extends StatelessWidget {
  RecipeDetailsView({super.key});

  final RecipeDetailsViewController controller = Get.put(RecipeDetailsViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.recipe.value?.title ?? 'Recipe Details'))),
      body: Obx(() {
        if (controller.dataStatus["isLoading"]) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: AppColors.black,
            ),
          );
        }

        if (controller.dataStatus["hasError"]) {
          return Center(
            child: Text(
              controller.dataStatus["error"],
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (controller.dataStatus["hasData"] && controller.recipe.value != null) {
          final recipe = controller.recipe.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.image != null) Image.network(recipe.image!, fit: BoxFit.cover),
                const SizedBox(height: 10),
                const Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...?recipe.extendedIngredients?.map((ing) => Text("- $ing")),
                const SizedBox(height: 10),
                const Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(html_parser.parse(recipe.instructions ?? '').body?.text.trim() ?? 'No instructions available.'),
                const Text("Ready In ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("${recipe.readyInMinutes} min", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.favorite),
                  label: const Text("Save to Favorites"),
                  onPressed: controller.saveToFavorites,
                ),
              ],
            ),
          );
        }

        return const SizedBox(); // fallback in case nothing matches
      }),
    );
  }
}
