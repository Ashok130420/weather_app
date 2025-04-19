import 'package:flutter/material.dart';
import 'package:weather/views/recipe_view.dart';
import 'package:weather/views/weather_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recipe & Weather App'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Recipes'),
              Tab(text: 'Weather'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RecipeScreen(),
            WeatherScreen(),
          ],
        ),
      ),
    );
  }
}
