import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_view_controller.dart';
import '../models/recipe_model.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteViewController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomText(
          'Favorites Recipes',
          fontSize: 16,
        ),
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 20));
        }

        if (controller.favoriteItems.isEmpty) {
          return const Center(child: Text('No favorite recipes.'));
        }

        return ListView.separated(
          itemCount: controller.favoriteItems.length,
          itemBuilder: (context, index) {
            final RecipeModel recipe = controller.favoriteItems[index];
            return ListTile(
              leading: Image.network(recipe.image ?? "", width: 50, fit: BoxFit.cover),
              title: CustomText(
                recipe.title ?? "",
                fontSize: 14,
              ),
              subtitle: CustomText('Ready in ${recipe.readyInMinutes} mins'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: AppColors.red),
                onPressed: () {
                  controller.removeFromFavorites(recipe.id!);
                },
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(color: AppColors.grey),
        );
      }),
    );
  }
}
