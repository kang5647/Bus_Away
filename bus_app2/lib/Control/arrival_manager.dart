import 'dart:io';
import 'dart:async';

import 'package:bus_app/Views/eta_screen.dart';
import 'package:flutter/cupertino.dart';
import 'bus_service.dart';
import 'bus_eta_control.dart';
import 'bus_eta_model.dart';
//import 'package:test_app/arrival_notification/arrival_data.dart';
//import 'package:test_app/arrival_notification/get_bus_arrival_api.dart';

Timer? _timer;

class ArrivalManager {
  // data to store api response
  late Future<List<BusEta>> futureBusService;
  late BusETAJSONHelper jsonHelper;
  late NextBus nextBus;
  //final arrivalData = ArrivalData();
  //late ArrivalResponse arrivalResponse;

  late int curIndex;
  late int destIndex;
  late String boarding; // boarding point
  late String alighting; // alighting point
  late BusService bus;
  late String busServiceNo;
  late int noOfStopsAway;

  ArrivalManager(
      BusService bus, String busServiceNo, String start, String dest) {
    this.jsonHelper = BusETAJSONHelper();
    this.bus = bus;
    this.busServiceNo = busServiceNo;
    this.boarding = start;
    this.alighting = dest;
    this.curIndex = findStartIndex();
    this.destIndex = findDestIndex();
    this.noOfStopsAway = destIndex - curIndex;
  }

  int findStartIndex() {
    late int temp;
    for (int i = 0; i < bus.route.length; i++) {
      if (boarding == bus.route[i]) {
        temp = i;
        break;
      }
    }
    return temp;
  }

  int findDestIndex() {
    late int temp;
    for (int i = 0; i < bus.route.length; i++) {
      if (alighting == bus.route[i]) {
        temp = i;
        break;
      }
    }
    return temp;
  }

  // check whether the current time equals to estimated arrival time
  bool checkArrival(DateTime est) {
    final now = DateTime.now().add(Duration(seconds: 10));
    //print('now = ${now}, est = ${est}');
    if (now.compareTo(est) == 0 || now.compareTo(est) > 0) {
      return true;
    }
    return false;
  }

  Future<DateTime> updateArrival(String busStopCode) async {
    List<BusEta> busServiceList;
    busServiceList = await jsonHelper.fetchServices(busStopCode, busServiceNo);
    return (DateTime.parse(
        busServiceList[0].services[0].nextBus.estimatedArrival));
  }

  // if arrival then update the bus stop code
  Future<bool> updateCurStop() async {
    DateTime est;
    String nextStop = bus.route[curIndex + 1];
    est = await updateArrival(nextStop);
    int i = 0;
    while (!checkArrival(est)) {
      sleep(Duration(seconds: 20));
      i++;
      est = await updateArrival(nextStop);
      print('check arrival ${i}');
    }
    this.curIndex++;
    this.noOfStopsAway--;
    return true;
  }

  void arrivalAssistant() async {
    while (curIndex != destIndex) {
      print(
          'curStop = ${bus.busStopName[curIndex]}, nextStop = ${bus.busStopName[curIndex + 1]}, no. of stops away = ${this.noOfStopsAway}');
      await updateCurStop();
      print('Arrive at ${bus.busStopName[curIndex]} at ${DateTime.now()}\n\n');
    }
  }

  int getNoOfStopsAway() {
    return noOfStopsAway;
  }
}
