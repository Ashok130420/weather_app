/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class WeatherController extends GetxController {
  final TextEditingController cityController = TextEditingController();
  final isLoading = false.obs;
  final weather = Rxn<Weather>();

  static const String _apiKey = 'f35944a2f733d5d3bce0dbf83997095c';

  @override
  void onInit() {
    super.onInit();
    fetchWeatherByLocation(); // Automatically fetch weather when controller is initialized
  }

  Future<void> fetchWeatherByCity() async {
    final city = cityController.text.trim();
    if (city.isEmpty) {
      Get.snackbar('Error', 'Please enter a city name');
      return;
    }
    await _fetchWeather(city);
  }

  Future<void> fetchWeatherByLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _fetchWeatherByCoords(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    }
  }

  Future<void> _fetchWeather(String city) async {
    isLoading.value = true;
    final encodedCity = Uri.encodeComponent(city);
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$encodedCity,IN&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      print('City Weather Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weather.value = Weather(
          city: data['name'],
          description: data['weather'][0]['description'],
          temperature: data['main']['temp'].toDouble(),
          iconUrl: 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Failed to fetch weather');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchWeatherByCoords(double lat, double lon) async {
    isLoading.value = true;
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      print('Coords Weather Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weather.value = Weather(
          city: data['name'],
          description: data['weather'][0]['description'],
          temperature: data['main']['temp'].toDouble(),
          iconUrl: 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Failed to fetch weather');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

import '../models/forecast_weather_model.dart';

class WeatherController extends GetxController {
  final TextEditingController cityController = TextEditingController();
  final isLoading = false.obs;
  final weather = Rxn<Weather>();
  final forecast = <ForecastWeather>[].obs;

  static const String _apiKey = 'f35944a2f733d5d3bce0dbf83997095c';

  @override
  void onInit() {
    super.onInit();
    fetchWeatherByLocation(); // Automatically fetch weather when controller is initialized
  }

  Future<void> fetchWeatherByCity() async {
    final city = cityController.text.trim();
    if (city.isEmpty) {
      Get.snackbar('Error', 'Please enter a city name');
      return;
    }
    await _fetchWeather(city);
    await _fetchForecastByCity(city); // Fetch forecast when city is entered
  }

  Future<void> fetchWeatherByLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _fetchWeatherByCoords(position.latitude, position.longitude);
      await _fetchForecastByCoords(position.latitude, position.longitude); // Fetch forecast based on location
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    }
  }

  Future<void> _fetchWeather(String city) async {
    isLoading.value = true;
    final encodedCity = Uri.encodeComponent(city);
    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$encodedCity,IN&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      print('City Weather Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weather.value = Weather(
          city: data['name'],
          description: data['weather'][0]['description'],
          temperature: data['main']['temp'].toDouble(),
          iconUrl: 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Failed to fetch weather');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchWeatherByCoords(double lat, double lon) async {
    isLoading.value = true;
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      print('Coords Weather Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        weather.value = Weather(
          city: data['name'],
          description: data['weather'][0]['description'],
          temperature: data['main']['temp'].toDouble(),
          iconUrl: 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Failed to fetch weather');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch weather: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchForecastByCity(String city) async {
    final encodedCity = Uri.encodeComponent(city);
    final url = 'https://api.openweathermap.org/data/2.5/forecast?q=$encodedCity,IN&appid=$_apiKey&units=metric';

    await _fetchForecast(url);
  }

  Future<void> _fetchForecastByCoords(double lat, double lon) async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';

    await _fetchForecast(url);
  }

  Future<void> _fetchForecast(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      print('Forecast Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'];
        final List<ForecastWeather> forecastList = list
            .where((item) => item['dt_txt'].toString().contains('12:00:00')) // Midday only
            .map((item) => ForecastWeather.fromJson(item))
            .toList();
        forecast.assignAll(forecastList);
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar('Error', error['message'] ?? 'Failed to fetch forecast');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch forecast: $e');
    }
  }
}
