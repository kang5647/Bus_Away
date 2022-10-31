import 'dart:async';
import 'dart:ffi';

import 'package:bus_app/Views/bus_arrived_screen.dart';
import 'package:bus_app/Views/eta_screen.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:bus_app/Views/enter_screen.dart';
import 'package:bus_app/Control/bus_eta_model.dart';
import 'package:bus_app/Control/bus_eta_control.dart';
import 'package:bus_app/Utility/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'bus_arrived_screen.dart';
import 'package:bus_app/Control/arrival_manager.dart';

class Confirmed_info extends StatefulWidget {
  final ArrivalManager arrivalManager;
  final String busServiceNo;
  final int busChoice;
  const Confirmed_info(
      {super.key,
      required this.busServiceNo,
      required this.arrivalManager,
      required this.busChoice});

  @override
  State<Confirmed_info> createState() => _Confirmed_infoState();
}

class _Confirmed_infoState extends State<Confirmed_info> {
  late Future<List<BusEta>> futureBusService;
  late BusETAJSONHelper jsonHelper;
  late Timer mytimer;
  //String path = 'BusArrivalv2?BusStopCode=83139';
  @override
  void initState() {
    jsonHelper = BusETAJSONHelper();
    super.initState();

    mytimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final response = await jsonHelper.fetchServices(
          widget.arrivalManager.boarding, widget.busServiceNo);
      setState(() {
        response;
      });
    });

    @override
    void dispose() {
      mytimer.cancel();
      //super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    futureBusService = jsonHelper.fetchServices(
        widget.arrivalManager.boarding, widget.busServiceNo);
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
                      mytimer.cancel();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bus_eta_ui(
                                    busServiceNo: widget.busServiceNo,
                                    arrivalManager: widget.arrivalManager,
                                  )));
                    },
                  );
                },
              ),
              //title: const Text('bus arrival'),
            ),
            body: FutureBuilder<List<BusEta>>(
              future: futureBusService,
              builder: (context, snapshot) {
                //updateBusArrTimings();
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error has occured'),
                  );
                } else if (snapshot.hasData) {
                  return Info_display(
                    busServiceList: snapshot.data!,
                    busChoice: widget.busChoice,
                    arrivalManager: widget.arrivalManager,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }
}

class Info_display extends StatefulWidget {
  final int busChoice;
  final List<BusEta> busServiceList;
  final ArrivalManager arrivalManager;
  const Info_display(
      {super.key,
      required this.busServiceList,
      required this.busChoice,
      required this.arrivalManager});

  @override
  State<Info_display> createState() => _Info_displayState();
}

class _Info_displayState extends State<Info_display> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    print(now);
    DateTime confirmedestarrival;
    String busType;
    String wheelchair;
    String busLoad;
    int busTime;

    if (widget.busChoice == 1) {
      confirmedestarrival = DateTime.parse(
          widget.busServiceList[0].services[0].nextBus.estimatedArrival);
      busType = widget.busServiceList[0].services[0].nextBus.type;
      wheelchair = widget.busServiceList[0].services[0].nextBus.feature;
      busTime = confirmedestarrival.difference(now).inMinutes;
      busLoad = widget.busServiceList[0].services[0].nextBus.load;
    } else {
      confirmedestarrival = DateTime.parse(
          widget.busServiceList[0].services[0].nextBus2.estimatedArrival);
      busType = widget.busServiceList[0].services[0].nextBus2.type;
      wheelchair = widget.busServiceList[0].services[0].nextBus2.feature;
      busTime = confirmedestarrival.difference(now).inMinutes;
      busLoad = widget.busServiceList[0].services[0].nextBus2.load;
    }

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
          // children: [
          //   Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.busServiceList[0].services[0].serviceNo,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: busTypeIcon(busType),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    widget.arrivalManager.bus
                        .busStopName[widget.arrivalManager.curIndex],
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            //   ],
            // ),
            // Text(
            //   'Current bus location: ',
            //   style: TextStyle(
            //       fontSize: 20,
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold),
            // ),
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => busArrivedScreen(
                                      busNo:
                                          widget.arrivalManager.bus.serviceNo,
                                      alighting:
                                          widget.arrivalManager.alighting,
                                      boarding: widget.arrivalManager.boarding,
                                      arrivalManager: widget.arrivalManager,
                                    )));
                      },
                      child: Column(
                        children: [
                          wheelchair_indicator(wheelchair),
                          arrIndicator(busTime),
                          busLoadLevel(busLoad),
                        ],
                      )),
                ),
                // SizedBox(
                //   height: 70,
                //   width: 150,
                //   child: TextButton(
                //       style: TextButton.styleFrom(
                //         textStyle: const TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         foregroundColor: AppColors.lightBlueColor,
                //         backgroundColor: Colors.white,
                //         //fixedSize : Size(),
                //       ),
                //       onPressed: () {
                //         Navigator.pop(context);
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => busArrivedScreen()));
                //       },
                //       child: Text("no of stops away: ")),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

CircleAvatar busTypeIcon(String busType) {
  if (busType == 'DD') {
    return CircleAvatar(
      backgroundColor: AppColors.lightBlueColor.withOpacity(0.7),
      radius: 26,
      backgroundImage: ExactAssetImage('assets/double_decker.png'),
    );
  } else
    return CircleAvatar(
      backgroundColor: AppColors.lightBlueColor.withOpacity(0.7),
      radius: 26,
      backgroundImage: ExactAssetImage('assets/bus.png'),
    );
  ;
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

int busArrived(int time) {
  //print(time);
  if (time <= 0) {
    // print("time $time");
    return 1;
  } else {
    return 1;
  }
}
