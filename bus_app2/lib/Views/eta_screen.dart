import 'package:bus_app/Utility/app_colors.dart';
import 'package:bus_app/Views/enter_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_app/Control/bus_eta_model.dart';
import 'package:bus_app/Control/bus_eta_control.dart';
import 'package:get/get_connect.dart';
import 'package:get/route_manager.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:bus_app/Widgets/blue_intro_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class bus_eta_ui extends StatefulWidget {
  const bus_eta_ui(
      {super.key, required this.busStopCode, required this.busServiceNo});
  final String busStopCode;
  final String busServiceNo;
  @override
  State<bus_eta_ui> createState() => _bus_eta_uiState();
}

class _bus_eta_uiState extends State<bus_eta_ui> {
  late Future<List<BusEta>> futureBusService;
  late BusETAJSONHelper jsonHelper;
  late Timer mytimer;
  //String path = 'BusArrivalv2?BusStopCode=83139';
  @override
  void initState() {
    jsonHelper = BusETAJSONHelper();
    super.initState();
  }

  // void updateBusArrTimings() async {
  // Timer mytimer = Timer.periodic(Duration(seconds: 30), (timer) async {
  //   final response = await BusETAJSONHelper()
  //       .fetchServices(widget.busStopCode, widget.busServiceNo);
  //   setState(() => response);
  // });
  // }

  @override
  Widget build(BuildContext context) {
    // Timer mytimer = Timer.periodic(Duration(seconds: 30), (timer) async {
    //   final response = await jsonHelper.fetchServices(
    //       widget.busStopCode, widget.busServiceNo);
    //   setState(() {
    //     response;
    //   });
    // });

    // @override
    // void dispose() {
    //   mytimer.cancel();
    //   super.dispose();
    // }
    mytimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final response =
          jsonHelper.fetchServices(widget.busStopCode, widget.busServiceNo);
      setState(() {
        response;
      });
    });

    @override
    void dispose() {
      mytimer.cancel();
      //super.dispose();
    }

    return MaterialApp(
        title: 'bus arrival timing',
        home: Scaffold(
            appBar: AppBar(
              // title: Text("Bus arrival timings",
              //style:
              //TextStyle(color: AppColors.darkBlueColor, fontSize: 30)),
              backgroundColor: Colors.white.withOpacity(0.0),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/backGround1.png'),
                      fit: BoxFit.cover),
                ),
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      dispose();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterScreen()));
                    },
                  );
                },
              ),
              //title: const Text('bus arrival'),
            ),
            body: FutureBuilder<List<BusEta>>(
              future: jsonHelper.fetchServices(
                  widget.busStopCode, widget.busServiceNo),
              builder: (context, snapshot) {
                //updateBusArrTimings();
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occured'),
                  );
                } else if (snapshot.hasData) {
                  return BusServiceList(busServiceList: snapshot.data!);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }
}

//where we display the eta and bus load
class BusServiceList extends StatefulWidget {
  const BusServiceList({super.key, required this.busServiceList});
  final List<BusEta> busServiceList;

  @override
  State<BusServiceList> createState() => _BusServiceListState();
}

class _BusServiceListState extends State<BusServiceList> {
  Widget build(BuildContext context) {
    final now = DateTime.now();

    print(now.toIso8601String());
    DateTime nextestarrival = DateTime.parse(
        widget.busServiceList[0].services[0].nextBus.estimatedArrival);
    DateTime nextbus2estarrival = DateTime.parse(
        widget.busServiceList[0].services[0].nextBus2.estimatedArrival);
    //final difference = nextestarrival.difference(now);
    //print(difference.inMinutes);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.lightBlueColor.withOpacity(0.7),
        ),
        margin: const EdgeInsets.fromLTRB(10, 450, 10, 0),
        //padding: EdgeInsets.symmetric(horizontal: 156.0, vertical: 110.0),
        //color: Color.fromARGB(255, 3, 120, 116),
        //alignment: Alignment.centerLeft,
        //text button for time

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.bus_alert_outlined, size: 50.0),
                Text(
                  widget.busServiceList[0].services[0].serviceNo,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "-",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.busServiceList[0].busStopCode,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 70,
                  width: 150,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: AppColors.lightColor,
                        backgroundColor: AppColors.blueColor,
                        //fixedSize : Size(),
                      ),
                      onPressed: () {},
                      child: Column(
                        children: [
                          wheelchair_indicator(widget
                              .busServiceList[0].services[0].nextBus.feature),
                          arrIndicator(
                              nextestarrival.difference(now).inMinutes),
                          busLoadLevel(widget
                              .busServiceList[0].services[0].nextBus.load),
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 150,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: AppColors.lightColor,
                        backgroundColor: AppColors.blueColor,
                        //fixedSize : Size(),
                      ),
                      onPressed: () {},
                      child: Column(
                        children: [
                          wheelchair_indicator(widget
                              .busServiceList[0].services[0].nextBus2.feature),
                          arrIndicator(
                              nextbus2estarrival.difference(now).inMinutes),
                          busLoadLevel(widget
                              .busServiceList[0].services[0].nextBus2.load),
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Icon wheelchair_indicator(String feature) {
  if (feature == "WAB") {
    return Icon(
      Icons.wheelchair_pickup,
    );
  }
  return Icon(Icons.access_time_outlined);
}

LinearPercentIndicator busLoadLevel(String load) {
  if (load == 'SEA') {
    return LinearPercentIndicator(
      progressColor: Colors.green[400],
      backgroundColor: Colors.grey[350],
      percent: 0.3,
    );
  } else if (load == 'SDA') {
    return LinearPercentIndicator(
      progressColor: Colors.yellow[800],
      backgroundColor: Colors.grey[350],
      percent: 0.6,
    );
  } else {
    return LinearPercentIndicator(
      progressColor: Colors.red[800],
      backgroundColor: Colors.grey[350],
      percent: 1,
    );
  }
}

Text arrIndicator(int time) {
  //print(time);
  if (time <= 0) {
    // print("time $time");
    return const Text("Arr");
  } else {
    return Text(time.toString() + ' min');
  }
}
