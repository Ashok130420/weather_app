import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/services/app_exception.dart';
import 'package:weather/services/rest_service.dart';
import 'package:weather/utils/status_messages.dart';
import '../models/weather_model.dart';
import '../models/forecast_weather_model.dart';
import '../utils/constants.dart';

class WeatherController extends GetxController {
  final TextEditingController cityController = TextEditingController();
  final isLoading = false.obs;
  final weather = Rxn<Weather>();
  final forecast = <ForecastWeather>[].obs;

  @override
  void onInit() {
    super.onInit();
    getWeatherByLocation();
  }

  Future<void> getWeatherByCity() async {
    final city = cityController.text.trim();
    if (city.isEmpty) {
      showErrorMessage('Error, Please enter a city name');
      return;
    }

    await getWeather(city);
    await getForecastByCity(city);
  }

  Future<void> getWeatherByLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorMessage('Error ,Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorMessage('Error, Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showErrorMessage('Error, Location permissions are permanently denied.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      log('Location permission granted! Lat: ${position.latitude}, Lon: ${position.longitude}');
      await getWeatherByCoords(position.latitude, position.longitude);
      await getForecastByCoords(position.latitude, position.longitude);
    } catch (e) {
      log('Location Error: $e');
      showErrorMessage('Location Error $e');
    }
  }

  Future<void> getWeather(String city) async {
    isLoading.value = true;
    final encodedCity = Uri.encodeComponent(city);
    final url = '${Constants.openWeatherMapBaseUrl}weather?q=$encodedCity,IN&appid=${Constants.weatherApiKey}&units=metric';

    try {
      final data = await RestHelper.getRequest(url);
      log('Weather API Success (City): $data');
      weather.value = Weather(
        city: data['name'],
        description: data['weather'][0]['description'],
        temperature: data['main']['temp'].toDouble(),
        iconUrl: 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
        condition: data['weather'][0]['main'],
      );
    } catch (e) {
      log('Weather API Failure: $e');
      handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWeatherByCoords(double lat, double lon) async {
    isLoading.value = true;
    final url = '${Constants.openWeatherMapBaseUrl}weather?lat=$lat&lon=$lon&appid=${Constants.weatherApiKey}&units=metric';

    try {
      final data = await RestHelper.getRequest(url);
      log('Weather API Success (Coords): $data');
      weather.value = Weather(
        city: data['name'],
        description: data['weather'][0]['description'],
        temperature: data['main']['temp'].toDouble(),
        iconUrl: 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png',
        condition: data['weather'][0]['main'],
      );
    } catch (e) {
      log('Weather API Failure: $e');
      handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getForecastByCity(String city) async {
    final encodedCity = Uri.encodeComponent(city);
    final url = '${Constants.openWeatherMapBaseUrl}forecast?q=$encodedCity,IN&appid=${Constants.weatherApiKey}&units=metric';
    await getForecast(url);
  }

  Future<void> getForecastByCoords(double lat, double lon) async {
    final url = '${Constants.openWeatherMapBaseUrl}forecast?lat=$lat&lon=$lon&appid=${Constants.weatherApiKey}&units=metric';
    await getForecast(url);
  }

  Future<void> getForecast(String url) async {
    try {
      final data = await RestHelper.getRequest(url);
      log('Forecast API Success: $data');
      final List<dynamic> list = data['list'];
      final forecastList =
          list.where((item) => item['dt_txt'].toString().contains('12:00:00')).map((item) => ForecastWeather.fromJson(item)).toList();
      forecast.assignAll(forecastList);
    } catch (e) {
      log('Forecast API Failure: $e');
      handleException(e);
    }
  }

  void handleException(dynamic e) {
    log('Handled Exception: $e');
    if (e is AppException) {
      showErrorMessage('Error ${e.message} ?? Unexpected error occurred');
    } else {
      showErrorMessage('Error $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/weather/sun.json';
    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/weather/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/weather/rain.json';
      case 'thunderstorm':
        return 'assets/weather/thunder.json';
      case 'clear':
        return 'assets/weather/sun.json';
      default:
        return 'assets/weather/sun.json';
    }
  }

  Color getBackgroundColor() {
    final now = DateTime.now();
    final hour = now.hour;
    final description = weather.value?.description?.toLowerCase() ?? '';

    if (hour >= 6 && hour < 12) {
      if (description.contains('clear') || description.contains('sun')) return Colors.orangeAccent;
      return Colors.lightBlue.shade100;
    } else if (hour >= 12 && hour < 17) {
      if (description.contains('rain')) return Colors.grey.shade400;
      return Colors.yellow.shade300;
    } else if (hour >= 17 && hour < 20) {
      return Colors.deepOrange.shade200;
    } else {
      if (description.contains('clear')) return Colors.indigo.shade900;
      return Colors.grey.shade800;
    }
  }
}
