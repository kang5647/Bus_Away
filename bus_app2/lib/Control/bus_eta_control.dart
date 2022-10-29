import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:bus_app/Control/bus_eta_model.dart';
import 'package:http/http.dart' as http;

class BusETAJSONHelper {
  var headers = {
    'AccountKey': 'v5+bc4+cRje2EMII3iLWeg==',
    'accept': 'application/json'
  };

  Future<List<BusEta>> fetchServices(
      String busStopCode, String serviceNo) async {
    String uri =
        'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=$busStopCode&ServiceNo=$serviceNo';
    //uri = uri;
    final response = await http.get(Uri.parse(uri),
        headers: {'AccountKey': 'v5+bc4+cRje2EMII3iLWeg=='});
    if (response.statusCode == 200) {
      print("data fetched");
    }
    //passes data as a map
    var etajsondata = json.decode(response.body);
    //list to store objects in json file
    List<BusEta> etaTimes = [];
    etaTimes.add(BusEta.fromJson(etajsondata));
    return etaTimes;
  }
}
