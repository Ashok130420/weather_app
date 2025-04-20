import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/recipe_view_controller.dart';
import 'package:weather/utils/size_space.dart';
import 'package:weather/views/recipe_details_view.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text.dart';

class RecipeScreen extends StatelessWidget {
  RecipeScreen({super.key});

  final RecipeController controller = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Height(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.recipeController,
                          style: const TextStyle(color: AppColors.grey),
                          decoration: InputDecoration(
                            hintText: 'Search recipe by ingredients',
                            hintStyle: TextStyle(color: AppColors.grey),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: controller.recipeController,
                        builder: (context, child) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0.0,
                              end: controller.recipeController.text.isEmpty ? 0.0 : 1.0,
                            ),
                            duration: const Duration(milliseconds: 200),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: IconButton(
                                  icon: const Icon(Icons.search, color: AppColors.darkerGrey),
                                  onPressed: controller.fetchRecipes,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ).paddingAll(10),
                const Height(height: 10),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CupertinoActivityIndicator(radius: 20),
                      );
                    }
                    if (controller.recipes.isEmpty) {
                      return const Center(child: Text("No recipes found"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: controller.recipes.length,
                      itemBuilder: (context, index) {
                        final item = controller.recipes[index];

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => RecipeDetailsView(), arguments: [item.id]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    item.image ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: Get.width,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.black.withValues(alpha: 0.5),
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: Get.width * .9,
                                            child: CustomText(
                                              item.title ?? '',
                                              color: AppColors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Height(height: 2),
                                          CustomText(
                                            'Likes : ${item.likes}',
                                            color: AppColors.white,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
