import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/weather_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather/utils/app_colors.dart';
import 'package:weather/utils/size_space.dart';
import '../widgets/custom_text.dart';
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  final WeatherController controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bgColor = controller.getBackgroundColor();

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor.withValues(alpha: 0.7),
              bgColor,
              bgColor.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05,
                vertical: Get.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkerGrey.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.cityController,
                            style: const TextStyle(color: AppColors.white),
                            onFieldSubmitted: (value) {
                              controller.getWeatherByCity();
                            },
                            decoration: InputDecoration(
                              hintText: 'Search city...',
                              hintStyle: TextStyle(color: AppColors.white),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: controller.cityController,
                          builder: (context, child) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0.0,
                                end: controller.cityController.text.isEmpty ? 0.0 : 1.0,
                              ),
                              duration: const Duration(milliseconds: 200),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: IconButton(
                                    icon: const Icon(Icons.search, color: AppColors.white),
                                    onPressed: () {
                                      controller.getWeatherByCity();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.my_location, color: AppColors.white),
                          onPressed: () {
                            controller.getWeatherByLocation();
                          },
                        ),
                      ],
                    ),
                  ),
                  Height(height: Get.height * 0.03),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CupertinoActivityIndicator(
                          radius: 20,
                          color: AppColors.white,
                        ),
                      );
                    }

                    if (controller.weather.value == null) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_off,
                              size: Get.width * 0.2,
                              color: AppColors.white.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            CustomText(
                              'No weather data available',
                              color: AppColors.white.withOpacity(0.7),
                              fontSize: Get.width * 0.045,
                            ),
                          ],
                        ),
                      );
                    }

                    final weather = controller.weather.value!;
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: EdgeInsets.all(Get.width * 0.05),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkerGrey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CustomText(
                                  weather.city ?? "",
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                                // Image.network(
                                //   weather.iconUrl ?? '',
                                //   width: 120,
                                //   height: 120,
                                // ),
                                Lottie.asset(
                                  controller.getWeatherAnimation(weather.condition?.toLowerCase()),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                CustomText(
                                  weather.description ?? '',
                                  fontSize: Get.width * 0.045,
                                  color: AppColors.white,
                                ),
                                SizedBox(height: Get.height * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      '${weather.temperature}°',
                                      fontSize: Get.width * 0.12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                    CustomText(
                                      'C',
                                      fontSize: Get.width * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  Height(height: Get.height * 0.04),
                  Obx(() {
                    if (controller.forecast.isEmpty) {
                      return Center(
                        child: CustomText(
                          'No forecast available',
                          color: AppColors.white.withValues(alpha: 0.7),
                          fontSize: Get.width * 0.04,
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.02),
                          child: CustomText(
                            'Weather forecast next days',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        Height(height: Get.height * 0.02),
                        SizedBox(
                          height: Get.height * 0.22,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.forecast.length,
                            itemBuilder: (context, index) {
                              final forecast = controller.forecast[index];
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(milliseconds: 400 + (index * 100)),
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Container(
                                      width: Get.width * 0.3,
                                      margin: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                                      padding: EdgeInsets.all(Get.width * 0.03),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.darkerGrey.withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomText(
                                            '${forecast.dateTime?.day ?? 0}/${forecast.dateTime?.month ?? 0}/${forecast.dateTime?.year ?? 0}',
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                            fontSize: Get.width * 0.035,
                                          ),
                                          Image.network(
                                            forecast.iconUrl ?? '',
                                            width: Get.width * 0.12,
                                            height: Get.width * 0.12,
                                          ),
                                          CustomText(
                                            '${forecast.temperature ?? 0.0}°C',
                                            color: AppColors.white,
                                            fontSize: Get.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          CustomText(
                                            forecast.description ?? '',
                                            textAlign: TextAlign.center,
                                            color: AppColors.white.withValues(alpha: 0.9),
                                            fontSize: Get.width * 0.03,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
