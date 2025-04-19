import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_view_controller.dart';
import '../models/recipe_model.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteViewController());

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        if (controller.favoriteItems.isEmpty) {
          return const Center(child: Text('No favorite recipes.'));
        }

        return ListView.builder(
          itemCount: controller.favoriteItems.length,
          itemBuilder: (context, index) {
            final RecipeModel recipe = controller.favoriteItems[index];
            return ListTile(
              leading: Image.network(recipe.image ?? "", width: 50, fit: BoxFit.cover),
              title: Text(recipe.title ?? ""),
              subtitle: Text('Ready in ${recipe.readyInMinutes} mins'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.removeFromFavorites(recipe.id!);
                },
              ),
              onTap: () {
                // Optional: Show details or navigate
              },
            );
          },
        );
      }),
    );
  }
}
