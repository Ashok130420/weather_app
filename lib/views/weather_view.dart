/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/weather_view_controller.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.cityController,
                  decoration: InputDecoration(labelText: 'Enter city name'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: controller.fetchWeatherByCity,
              ),
              IconButton(
                icon: Icon(Icons.my_location),
                onPressed: controller.fetchWeatherByLocation,
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.weather.value == null) {
              return Center(child: Text('No data'));
            }
            final weather = controller.weather.value!;
            return Column(
              children: [
                Text('${weather.city}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Image.network(weather.iconUrl),
                Text('${weather.description}', style: TextStyle(fontSize: 18)),
                Text('${weather.temperature}°C', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ],
            );
          })
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/controllers/weather_view_controller.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.cityController,
                  decoration: InputDecoration(labelText: 'Enter city name'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: controller.fetchWeatherByCity,
              ),
              IconButton(
                icon: Icon(Icons.my_location),
                onPressed: controller.fetchWeatherByLocation,
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.weather.value == null) {
              return Center(child: Text('No data'));
            }
            final weather = controller.weather.value!;
            return Column(
              children: [
                Text('${weather.city}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Image.network(weather.iconUrl),
                Text('${weather.description}', style: TextStyle(fontSize: 18)),
                Text('${weather.temperature}°C', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ],
            );
          }),
          SizedBox(height: 20),
          Text('5-Day Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Obx(() {
            if (controller.forecast.isEmpty) {
              return Text('No forecast data');
            }
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.forecast.length,
                itemBuilder: (context, index) {
                  final forecast = controller.forecast[index];
                  return Container(
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${forecast.dateTime?.day ?? 0}/${forecast.dateTime?.month ?? 0}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Image.network(forecast.iconUrl ?? '', width: 50, height: 50),
                        Text('${forecast.temperature ?? 0.0}°C'),
                        Text(forecast.description ?? '', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
