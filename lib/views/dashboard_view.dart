import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/dashboard_view_controller.dart';
import 'package:weather/utils/app_colors.dart';
import 'package:weather/views/favorite_view.dart';
import 'package:weather/views/recipe_view.dart';
import 'package:weather/views/weather_view.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [WeatherScreen(), RecipeScreen(), FavoriteView()];
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text('Recipe & Weather App'),
      ),
      body: Obx(
        () => PageView(
          children: [tabs[controller.currentIndexNavBottom.value]],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(spreadRadius: 0.0, color: AppColors.bottomNavColor, blurRadius: 0.0, offset: Offset(0, -1)),
            ],
            color: AppColors.bottomNavColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  controller.currentIndexNavBottom.value = 0;
                },
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: controller.currentIndexNavBottom.value == 0 ? AppColors.black : AppColors.bottomNavColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                        ),
                        height: 4,
                        width: 80,
                      ),
                      SizedBox(height: 7),
                      Icon(Icons.device_thermostat,
                          size: 32, color: controller.currentIndexNavBottom.value == 0 ? AppColors.black : AppColors.grey),
                      Text("Weather",
                          style: TextStyle(color: controller.currentIndexNavBottom.value == 0 ? AppColors.black : AppColors.grey)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.currentIndexNavBottom.value = 1;
                },
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: controller.currentIndexNavBottom.value == 1 ? AppColors.black : AppColors.bottomNavColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                        ),
                        height: 4,
                        width: 80,
                      ),
                      SizedBox(height: 7),
                      Icon(Icons.fastfood, size: 32, color: controller.currentIndexNavBottom.value == 1 ? AppColors.black : AppColors.grey),
                      Text("Recipes",
                          style: TextStyle(color: controller.currentIndexNavBottom.value == 1 ? AppColors.black : AppColors.grey)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.currentIndexNavBottom.value = 2;
                },
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: controller.currentIndexNavBottom.value == 2 ? AppColors.black : AppColors.bottomNavColor,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                        ),
                        height: 4,
                        width: 80,
                      ),
                      SizedBox(height: 7),
                      Icon(Icons.favorite, size: 32, color: controller.currentIndexNavBottom.value == 2 ? AppColors.black : AppColors.grey),
                      Text("Favorites",
                          style: TextStyle(color: controller.currentIndexNavBottom.value == 2 ? AppColors.black : AppColors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 50),
        ),
      ),
    );
  }
}
