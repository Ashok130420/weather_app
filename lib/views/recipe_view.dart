import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/recipe_view_controller.dart';

import 'favorite_view.dart';

class RecipeScreen extends StatelessWidget {
  final RecipeController controller = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Recipe Finder"),
          InkWell(onTap: () => Get.to(() => FavoriteView()), child: Text("favorites")),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: controller.ingredientController,
              decoration: InputDecoration(
                labelText: 'Enter ingredients (comma-separated)',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: controller.fetchRecipes,
                ),
              ),
            ),
            SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.recipes.isEmpty) {
                return Expanded(child: Center(child: Text("No recipes found")));
              }
              return Expanded(
                  child: ListView.builder(
                itemCount: controller.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = controller.recipes[index];
                  return ListTile(
                    leading: Image.network(recipe.image ?? "", width: 50),
                    title: Text(recipe.title ?? ""),
                    subtitle: Text('Ready in ${recipe.readyInMinutes ?? 'N/A'} mins'),
                    onTap: () => controller.fetchRecipeDetails(recipe.id ?? 0),
                  );
                },
              ));
            }),
          ],
        ),
      ),
    );
  }
}
