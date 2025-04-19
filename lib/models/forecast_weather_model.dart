class ForecastWeather {
  final DateTime? dateTime;
  final double? temperature;
  final String? description;
  final String? iconUrl;

  ForecastWeather({
    this.dateTime,
    this.temperature,
    this.description,
    this.iconUrl,
  });

  factory ForecastWeather.fromJson(Map<String, dynamic> json) {
    return ForecastWeather(
      dateTime: json['dt_txt'] != null ? DateTime.parse(json['dt_txt']) : null,
      temperature: json['main']?['temp']?.toDouble(),
      description: json['weather']?.isNotEmpty ?? false ? json['weather'][0]['description'] : null,
      iconUrl: json['weather']?.isNotEmpty ?? false ? 'https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png' : null,
    );
  }
}
