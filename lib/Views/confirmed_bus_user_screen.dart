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
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class Confirmed_info extends StatefulWidget {
  final ArrivalManager arrivalManager;
  final String busServiceNo;
  const Confirmed_info({
    super.key,
    required this.busServiceNo,
    required this.arrivalManager,
  });

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
  final List<BusEta> busServiceList;
  final ArrivalManager arrivalManager;
  const Info_display(
      {super.key, required this.busServiceList, required this.arrivalManager});

  @override
  State<Info_display> createState() => _Info_displayState();
}

class _Info_displayState extends State<Info_display> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    print(now);
    DateTime estArrival1;
    DateTime estArrival2;

    estArrival1 = DateTime.parse(
        widget.busServiceList[0].services[0].nextBus.estimatedArrival);
    estArrival2 = DateTime.parse(
        widget.busServiceList[0].services[0].nextBus2.estimatedArrival);

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.lightBlueColor.withOpacity(0.7),
        ),
        margin: const EdgeInsets.fromLTRB(10, 350, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
              child: Container(
                width: 350,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.darkBlueColor.withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Text(
                        widget.busServiceList[0].services[0].serviceNo,
                        style: TextStyle(
                            fontSize: 45,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: busTypeIcon(
                          widget.busServiceList[0].services[0].nextBus.type),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      child: Text(
                        widget.busServiceList[0].busStopCode,
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          foregroundColor: AppColors.lightColor,
                          backgroundColor: AppColors.darkBlueColor,
                          //fixedSize : Size(),
                        ),
                        onPressed: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            wheelchair_indicator(widget
                                .busServiceList[0].services[0].nextBus.feature),
                            arrIndicator(estArrival1.difference(now).inMinutes),
                            busLoadLevel(widget
                                .busServiceList[0].services[0].nextBus.load),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 120,
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          foregroundColor: AppColors.lightColor,
                          backgroundColor: AppColors.darkBlueColor,
                          //fixedSize : Size(),
                        ),
                        onPressed: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            wheelchair_indicator(widget.busServiceList[0]
                                .services[0].nextBus2.feature),
                            arrIndicator(estArrival2.difference(now).inMinutes),
                            busLoadLevel(widget
                                .busServiceList[0].services[0].nextBus2.load),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static int notification = 0;

  Text arrIndicator(int time) {
    //print(time);

    if (time <= 0 && notification == 0) {
      notification = 1;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Bus Arriving!"),
              content: new Text("Select PROCEED if you are boarding the bus"),
              actions: <Widget>[
                new TextButton(
                  child: new Text("PROCEED"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => busArrivedScreen(
                                  busNo: "",
                                  alighting: "",
                                  boarding: "boarding",
                                  arrivalManager: widget.arrivalManager,
                                )));
                  },
                ),
                new TextButton(
                  child: new Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    notification = 0;
                  },
                ),
              ],
            );
          },
        );
      });

      // notification = 1;
      return const Text("Arr",
          style: TextStyle(color: AppColors.lightColor, fontSize: 20));
    } else {
      return Text(time.toString() + ' min',
          style: TextStyle(color: AppColors.lightColor, fontSize: 20));
    }
  }

  CircleAvatar busTypeIcon(String busType) {
    if (busType == 'DD') {
      return CircleAvatar(
        backgroundColor: AppColors.lightBlueColor.withOpacity(0.0),
        radius: 17,
        backgroundImage: ExactAssetImage('assets/double_decker.png'),
      );
    } else
      return CircleAvatar(
        backgroundColor: AppColors.lightBlueColor.withOpacity(0.0),
        radius: 20,
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
        backgroundColor: AppColors.lightColor,
        percent: 0.3,
      );
    } else if (load == 'SDA') {
      return LinearPercentIndicator(
        progressColor: Colors.yellow[800],
        backgroundColor: AppColors.lightColor,
        percent: 0.6,
      );
    } else {
      return LinearPercentIndicator(
        progressColor: Colors.red[800],
        backgroundColor: AppColors.lightColor,
        percent: 1,
      );
    }
  }

//int notification = 0;

  int busArrived(int time) {
    //print(time);
    if (time <= 0) {
      // print("time $time");
      return 1;
    } else {
      return 1;
    }
  }
}
