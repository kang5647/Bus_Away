/// A control class which sets the current bus stop and the no. of stops away
/// Uses [BusETAJSONHelper] to retrieve data from LTA API

import 'dart:async';
import 'bus_eta_control.dart';
import 'bus_eta_model.dart';

class ArrivalManager {
  /// A list to store api response
  late Future<List<BusEta>> futureBusService;

  /// API to Json control class
  late BusETAJSONHelper jsonHelper;

  /// Info of the next bus
  late NextBus nextBus;

  /// Current bus stop index
  late int curIndex;

  /// Alighting stop index
  late int destIndex;

  /// Boarding stop code
  late String boarding;

  /// Alighting stop code
  late String alighting;

  /// Bus Service Number
  late String busServiceNo;

  /// Stores number of stops away between current bus stop and alighting stop
  late int noOfStopsAway;

  /// Stores a list of bus stops of the bus route
  late List busStopList;

  /// The boarding stop index
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

  /// Find the boarding stop index
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

  /// Find the alighting stop index
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

  /// Check whether the current time equals to estimated arrival time
  bool checkArrival(DateTime est) {
    final now = DateTime.now();
    //print('now = ${now}, est = ${est}');
    if (now.compareTo(est) == 0 || now.compareTo(est) > 0) {
      return true;
    }
    return false;
  }

  /// Get the bus ETA from LTA API
  Future<DateTime> updateArrival(String busStopCode) async {
    List<BusEta> busServiceList;
    busServiceList = await jsonHelper.fetchServices(busStopCode, busServiceNo);
    return (DateTime.parse(
        busServiceList[0].services[0].nextBus.estimatedArrival));
  }

  /// If arrival, update the bus stop code
  void updateCurStop(DateTime est) async {
    if (checkArrival(est)) {
      String nextStop = busStopList[curIndex + 1]['BusStopCode'];

      curIndex++;
      noOfStopsAway--;
    }
  }

  /// Print [curStop], [nextStop], [noOfStopAway] for debugging
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
          'curStop = ${curStop}, nextStop = ${nextStop}, no. of stops away = ${noOfStopsAway}');
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
