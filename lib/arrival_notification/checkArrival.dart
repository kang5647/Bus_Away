import 'dart:io';

import 'package:test_app/arrival_notification/arrival_data.dart';
import 'package:test_app/arrival_notification/bus_service.dart';
import 'package:test_app/arrival_notification/get_bus_arrival_api.dart';

class ArrivalManager {
  final arrivalData = ArrivalData();
  late int curIndex;
  late int destIndex;
  //late String curStop;
  late String start; // boarding point
  late String destination; // alighting point
  late BusService bus;
  late ArrivalResponse arrivalResponse;
  // DateTime est = DateTime.now().add(const Duration(minutes: 10));

  ArrivalManager(BusService bus, String start, String dest) {
    this.bus = bus;
    //this.curStop = start;
    this.start = start;
    this.destination = dest;
    this.curIndex = findStartIndex();
    this.destIndex = findDestIndex();
  }

  int findStartIndex() {
    late int temp;
    for (int i = 0; i < bus.route.length; i++) {
      if (start == bus.route[i]) {
        temp = i;
        break;
      }
    }
    return temp;
  }

  int findDestIndex() {
    late int temp;
    for (int i = 0; i < bus.route.length; i++) {
      if (destination == bus.route[i]) {
        temp = i;
        break;
      }
    }
    return temp;
  }

  // check whether the current time equals to estimated arrival time
  bool checkArrival(DateTime est) {
    final now = DateTime.now();
    //print('now = ${now}, est = ${est}');
    if (now.compareTo(est) == 0 || now.compareTo(est) > 0) {
      return true;
    }
    return false;
  }

  Future<DateTime> updateArrival(String busStopCode) async {
    arrivalResponse = await arrivalData.getArrival(busStopCode);
    // print('busStop = ${busStopCode}, est = ${arrivalResponse.estimatedArrival}');
    return (arrivalResponse.estimatedArrival);
  }

  // if arrival then update the bus stop code
  Future<bool> updateCurStop() async {
    DateTime est;
    String nextStop = bus.route[curIndex + 1];
    est = await updateArrival(nextStop);
    int i = 0;
    while (!checkArrival(est)) {
      // print('Update ${i}');
      i++;
      sleep(Duration(seconds: 30));
      est = await updateArrival(nextStop);
    }
    this.curIndex++;
    // print('updated curStop = ${curStop}\n');
    return true;
    //print('curStop = ${curStop}');
  }

  void arrivalAssistant() async {
    //int next = 1;
    //int cur = 0;
    bool result;
    String nextStop;
    while (curIndex != destIndex) {
      nextStop = bus.route[curIndex + 1];
      print(
          'curStop = ${bus.busStopName[curIndex]}, nextStop = ${bus.busStopName[curIndex + 1]}, no. of stops away = ${getNoOfStopsAway()}');
      result = await updateCurStop();
      //cur++;
      //next++;
      print('Arrive at ${bus.busStopName[curIndex]} at ${DateTime.now()}\n\n');
    }
  }

  int getNoOfStopsAway() {
    return destIndex - curIndex;
  }
}
