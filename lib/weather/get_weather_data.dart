import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app/weather/weather_data.dart';

class WeatherData {
  Future<WeatherResponse> getWeather() async {
    final queryParameters = {
      'q': 'Singapore',
      'appid': '514550b5f6477cc5155c042bee66b888',
      'units': 'metric',
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    // print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
