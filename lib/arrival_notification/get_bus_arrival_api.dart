import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app/arrival_notification/arrival_data.dart';

class ArrivalData {
  Future<ArrivalResponse> getArrival(String busStopCode) async {
    final http.Response response = await http.get(
        Uri.parse(
            'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=${busStopCode}'),
        headers: {'AccountKey': 'GTD8g+DyQ1enRyGqI9AvPg=='});

    if (response.statusCode == 200) {
      // print(response.body);
      final json = jsonDecode(response.body);
      return ArrivalResponse.fromJson(json);
    } else {
      throw Exception('Failed to load ArrivalResponse');
    }
  }
}
