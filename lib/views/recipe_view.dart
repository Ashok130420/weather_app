import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/recipe_view_controller.dart';
import 'package:weather/views/recipe_details_view.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_input_text.dart';

class RecipeScreen extends StatelessWidget {
  RecipeScreen({super.key});

  final RecipeController controller = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField(
            //   controller: controller.ingredientController,
            //   decoration: InputDecoration(
            //     labelText: 'Enter ingredients (comma-separated)',
            //     suffixIcon: IconButton(
            //       icon: Icon(Icons.search),
            //       onPressed: controller.fetchRecipes,
            //     ),
            //   ),
            // ),
            CustomTextInput(
              textCapitalization: TextCapitalization.words,
              controller: controller.ingredientController,
              labelText: "Enter ingredients (comma-separated)",
              enable: true,
              suffixIcon: Icon(
                Icons.search,
                color: AppColors.black,
              ),
              keyboardType: TextInputType.text,
              onSuffixIconPressed: () {
                controller.fetchRecipes();
              },
            ),
            SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    radius: 20,
                  ),
                );
              }
              if (controller.recipes.isEmpty) {
                return const Expanded(child: Center(child: Text("No recipes found")));
              }
              return Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = controller.recipes[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => RecipeDetailsView(), arguments: [recipe.id]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.lighterGrey),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                recipe.image ?? '',
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipe.title ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //   child: Text(
                            //     'Ready in ${recipe.readyInMinutes ?? 'N/A'} mins',
                            //     style: const TextStyle(color: Colors.grey, fontSize: 12),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
