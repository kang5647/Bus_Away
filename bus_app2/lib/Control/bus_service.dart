import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusService {
  late String serviceNo;
  late List<String> route = [];
  late List<String> busStopName = [];

  BusService(String busNo) {
    this.serviceNo = busNo;
    /*this.route = [
      '27291',
      '27311',
      '27061',
      '27211'
    ]; // test from hall2 to lee wee nam lib
    this.busStopName = [
      'Opp Hall 6',
      'Hall 2',
      'Opp Blk 41',
      'Lee Wee Name Lib'
    ];*/
    getBusStopData();
  }

  void getBusStopData() async {
    List data = [];
    //List busStopsCode = [];
    final result = await FirebaseFirestore.instance
        .collection('BusRoutes')
        .where('BusServiceNo', isEqualTo: this.serviceNo)
        .get();

    var resultList = result.docs.map((e) => e.data()).toList();
    var busServiceInfo = resultList[0];

    data.addAll(busServiceInfo['BusStops']);
    for (var busStop in data) {
      print(busStop['BusStopName']);
      print(busStop['BusStopCode']);
      this.route.add(busStop['BusStopCode']);
      this.busStopName.add(busStop['BusStopName']);
    }
    //this.busStopName.addAll(busServiceInfo['BusStopName']);
    print(route);
    print(busStopName);
  }
}
