import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/recipe_details_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:weather/utils/size_space.dart';

import '../utils/app_colors.dart';
import '../widgets/custom_text.dart';

class RecipeDetailsView extends StatelessWidget {
  RecipeDetailsView({super.key});

  final RecipeDetailsViewController controller = Get.put(RecipeDetailsViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomText(
        'Recipe Details',
        fontSize: 18,
      )),
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
            child: CustomText(
              controller.dataStatus["error"],
              color: AppColors.red,
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
                const Height(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomText("${recipe.title}", fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.saveToFavorites();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: AppColors.black,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: AppColors.white,
                            ),
                            Width(width: 4),
                            CustomText(
                              "Add Favorite",
                              fontSize: 13,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Height(height: 10),
                const CustomText("Instructions", fontWeight: FontWeight.bold, fontSize: 18),
                Height(height: 4),
                CustomText(html_parser.parse(recipe.instructions ?? '').body?.text.trim() ?? 'No instructions available.'),
                Height(height: 10),
                const CustomText("Ready In ", fontWeight: FontWeight.bold, fontSize: 16),
                Height(height: 4),
                CustomText("${recipe.readyInMinutes} min", fontWeight: FontWeight.normal, fontSize: 16),
                const Height(height: 20),
              ],
            ),
          );
        }

        return const SizedBox();
      }),
    );
  }
}
