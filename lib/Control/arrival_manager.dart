import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
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
  late String busServiceNo;
  late int noOfStopsAway;
  late List busStopList;
  late int boardingIndex;
  ArrivalManager(List busStopList, String boardingPoint, String alightingPoint,
      String busServiceNo) {
    this.jsonHelper = BusETAJSONHelper();
    this.busStopList = busStopList;
    this.busServiceNo = busServiceNo;
    this.curIndex = findStartIndex(boardingPoint);
    this.destIndex = findDestIndex(alightingPoint);
    this.boardingIndex = curIndex;
    this.noOfStopsAway = destIndex - curIndex;
    this.boarding = busStopList[curIndex]['BusStopCode'];
    this.alighting = busStopList[curIndex]['BusStopCode'];
  }

  int findStartIndex(String boardingPoint) {
    late int temp;
    for (int i = 0; i < busStopList.length; i++) {
      var busStop = busStopList[i];
      if (busStop['BusStopName'] == boardingPoint) {
        temp = i;
        break;
      }
    }
    return temp;
  }

  int findDestIndex(String alightingPoint) {
    late int temp;
    for (int i = 0; i < busStopList.length; i++) {
      var busStop = busStopList[i];
      if (busStop['BusStopName'] == alightingPoint) {
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
    List<BusEta> busServiceList;
    busServiceList = await jsonHelper.fetchServices(busStopCode, busServiceNo);
    // print('busStop = ${busStopCode}, est = ${arrivalResponse.estimatedArrival}');
    return (DateTime.parse(
        busServiceList[0].services[0].nextBus.estimatedArrival));
  }

  // if arrival then update the bus stop code
  void updateCurStop(DateTime est) async {
    if (checkArrival(est)) {
      String nextStop = busStopList[curIndex + 1]['BusStopCode'];

      this.curIndex++;
      this.noOfStopsAway--;
    }
  }

  void arrivalAssistant() async {
    //int next = 1;
    //int cur = 0;
    // bool result;
    String nextStop;
    String curStop;
    while (curIndex != destIndex) {
      curStop = busStopList[curIndex]['BusStopName'];
      nextStop = busStopList[curIndex + 1]['BusStopName'];
      print(
          'curStop = ${curStop}, nextStop = ${nextStop}, no. of stops away = ${this.noOfStopsAway}');
      //cur++;
      //next++;
      print(
          'Arrive at ${busStopList[curIndex]['BusStopName']} at ${DateTime.now()}\n\n');
    }
    //_timer?.cancel();
  }

  int getNoOfStopsAway() {
    return noOfStopsAway;
  }

  String getBusStopName(int index) {
    var busStop = busStopList[index];
    return busStop['BusStopName'];
  }

  String getBusStopCode(int index) {
    var busStop = busStopList[index];
    return busStop['BusStopCode'];
  }
}
