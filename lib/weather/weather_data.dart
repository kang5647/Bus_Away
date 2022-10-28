
class WeatherResponse {
  final double temperature;
  final String description;
  final String icon;

  String get iconUrl{
    return 'http://openweathermap.org/img/wn/${icon}@2x.png';
  }

  WeatherResponse({required this.temperature, required this.description, required this.icon});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final temperature = json['main']['temp'];
    final description = json['weather'][0]['description'];
    final icon = json['weather'][0]['icon'];

    return WeatherResponse(temperature: temperature, description: description, icon: icon);
  }
}