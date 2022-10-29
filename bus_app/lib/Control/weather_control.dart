import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  String? cityName;
  double? temp;
  String? mainDesc;
  String? icon;

  Weather({this.cityName, this.temp, this.mainDesc, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    cityName = json['name'];
    temp = json['main']['temp'];
    mainDesc = json['weather'][0]['main'];
    icon = json['weather'][0]['icon'];
  }
}

class WeatherApiClient {
  Future<Weather>? getCurrentWeather() async {
    var endpoint = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Singapore&appid=514550b5f6477cc5155c042bee66b888&units=metric");

    var response = await http.get(endpoint);
    var body = jsonDecode(response.body);

    return Weather.fromJson(body);
  }
}
