import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/services/location_service.dart';

import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locationService = LocationService();
  locationService.requestLocationPermission();

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe & Weather App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}
