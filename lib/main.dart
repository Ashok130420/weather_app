import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:weather/services/location_service.dart';
import 'package:weather/utils/app_colors.dart';

import 'views/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locationService = LocationService();
  locationService.requestLocationPermission();

  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor primary = const MaterialColor(0xff2E66D3, {
      50: AppColors.primary,
      100: AppColors.primary,
      200: AppColors.primary,
      300: AppColors.primary,
      400: AppColors.primary,
      500: AppColors.primary,
      600: AppColors.primary,
      700: AppColors.primary,
      800: AppColors.primary,
      900: AppColors.primary
    });
    return GetMaterialApp(
      title: 'Recipe & Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
        primarySwatch: primary,
        scaffoldBackgroundColor: const Color(0xffffffff),
      ).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(primary: AppColors.primary),
      ),
      home: DashboardView(),
    );
  }
}
