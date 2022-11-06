/// Display Estimated Time Arrival (ETA) of the selected bus service at the boarding point
/// Also show the next oncoming bus service to the boarding point
/// Other than ETA, user can view the occupancy and the type of the bus, and whether the bus is wheelchair-accessible

import 'dart:async';
import 'package:bus_app/Constant/constants.dart';
import 'package:bus_app/Views/bus_arrived_screen.dart';
import 'package:bus_app/Views/select_bus_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_app/Control/bus_eta_model.dart';
import 'package:bus_app/Control/bus_eta_control.dart';
import 'package:bus_app/Utility/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:bus_app/Control/arrival_manager.dart';
import 'package:flutter/scheduler.dart';

GlobalKey<_Confirmed_infoState> globalKey = GlobalKey();

class Confirmed_info extends StatefulWidget {
  final ArrivalManager arrivalManager;
  final String busServiceNo;
  final Function(String) onBusStopChanged;

  const Confirmed_info(
      {super.key,
      required this.busServiceNo,
      required this.arrivalManager,
      required this.onBusStopChanged});

  @override
  State<Confirmed_info> createState() => _Confirmed_infoState();
}

class _Confirmed_infoState extends State<Confirmed_info> {
  /// A list to hold the bus ETA info
  late Future<List<BusEta>> futureBusService;

  /// An API manager which converts the json data from API to an object list
  late BusETAJSONHelper jsonHelper;
  late Timer mytimer;

  /// Overlay for bus_arrived_screen
  OverlayEntry? entry;
  OverlayState? overlay;

  ///Show [busArrivedScreen] which displays the current bus stop and the number of stops away from the destination
  void showOverlay() {
    mytimer.cancel();
    final overlay = Overlay.of(context)!;
    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     color: AppColors.lightBlueColor,
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   margin: const EdgeInsets.fromLTRB(10, 550, 10, 0),
          // ),
          busArrivedScreen(
            busNo: widget.arrivalManager.busServiceNo,
            alighting: widget.arrivalManager.alighting,
            boarding: widget.arrivalManager.boarding,
            arrivalManager: widget.arrivalManager,
            onBusStopChanged: (String busStopName) {
              widget.onBusStopChanged(busStopName);
            },
          ),
        ],
      ),
    );

    overlay.insert(entry!);
  }

  /// Set timer with 30 seconds duration
  void startTimer() {
    mytimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (!mounted) {
        timer.cancel();
      } else {
        final response = await jsonHelper.fetchServices(
            widget.arrivalManager.boarding, widget.busServiceNo);
        setState(() {
          response;
        });
      }
    });
  }

  @override
  void initState() {
    jsonHelper = BusETAJSONHelper();
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    mytimer.cancel();
    entry?.remove();
    super.dispose();
  }

  void removeOverlay() {
    print('Dispose overlay');
    overlay?.dispose();
    overlay = null;
  }

  /// Display the bus ETA info after data retrieval using LTA API is successful
  @override
  Widget build(BuildContext context) {
    futureBusService = jsonHelper.fetchServices(
        widget.arrivalManager.boarding, widget.busServiceNo);
    return FutureBuilder<List<BusEta>>(
      key: globalKey,
      future: futureBusService,
      builder: (context, snapshot) {
        //updateBusArrTimings();
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occured'),
          );
        } else if (snapshot.hasData) {
          return Info_display(
            snapshot.data!,
            widget.arrivalManager,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  /// A widget class which builds the busETA container
  /// If the bus service has ended operation, the widget will display "Not in operation" text and go back to bus selection page
  Widget Info_display(List busServiceList, ArrivalManager arrivalManager) {
    final now = DateTime.now();
    print(now);
    DateTime estArrival1;
    DateTime estArrival2;

    try {
      estArrival1 = DateTime.parse(
          busServiceList[0].services[0].nextBus.estimatedArrival);
      estArrival2 = DateTime.parse(
          busServiceList[0].services[0].nextBus2.estimatedArrival);
    } catch (e) {
      return AlertDialog(
        title: const Text('Alert'),
        content: const Text('Buses are currently not in operation'),
        actions: <Widget>[
          TextButton(
              onPressed: () => {
                    Navigator.pop(context, 'Cancel'),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Select_Bus_UI(
                                  query: widget.arrivalManager.busServiceNo,
                                )))
                  },
              child: const Text('Cancel')),
        ],
      );
    }
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child:
          // Overall container, i.e the background
          Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.blueBackground,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 4.0,
                blurRadius: 3.0)
          ],
        ),
        height: 210,
        // margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bus number, boarding point info
            Container(
              width: 350,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.blueTitle,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    busServiceList[0].services[0].serviceNo,
                    style: GoogleFonts.poppins(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  busTypeIcon(busServiceList[0].services[0].nextBus.type),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.arrivalManager
                            .busStopList[widget.arrivalManager.curIndex]
                        ['BusStopName'],
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            // The timing widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Left timing widget
                Container(
                  height: 80,
                  width: 150,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        foregroundColor: AppColors.whiteColor,
                        backgroundColor: AppColors.blueBoxColor,
                        //fixedSize : Size(),
                      ),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          wheelchair_indicator(
                              busServiceList[0].services[0].nextBus.feature),
                          arrIndicator(
                              estArrival1.difference(now).inMinutes, 1),
                          busLoadLevel(
                              busServiceList[0].services[0].nextBus.load),
                        ],
                      )),
                ),

                // Right timing widget
                Container(
                  height: 80,
                  width: 150,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        foregroundColor: AppColors.whiteColor,
                        backgroundColor: AppColors.blueBoxColor,
                        //fixedSize : Size(),
                      ),
                      onPressed: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          wheelchair_indicator(
                              busServiceList[0].services[0].nextBus2.feature),
                          arrIndicator(
                              estArrival2.difference(now).inMinutes, 2),
                          busLoadLevel(
                              busServiceList[0].services[0].nextBus2.load),
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

  static int notification = 0;

  /// if the bus has arrived at the [boardingStop], prompt the user to go to [busArrivedScreen]
  Text arrIndicator(int time, int busOrder) {
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
                TextButton(
                  child: Text("PROCEED"),
                  onPressed: () {
                    //Press process to show overlays
                    //notification = 0;
                    Navigator.of(context).pop();
                    showOverlay();
                  },
                ),
                TextButton(
                  child: new Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });

      // notification = 1
    } else if (busOrder == 1 && time > 0) {
      notification = 0;
    }
    if (time <= 0) {
      return const Text("Arr",
          style: TextStyle(color: AppColors.whiteColor, fontSize: 20));
    } else {
      //notification = 0;
      return Text(time.toString() + ' min',
          style: TextStyle(color: AppColors.whiteColor, fontSize: 20));
    }
  }

  CircleAvatar busTypeIcon(String busType) {
    if (busType == 'DD') {
      return CircleAvatar(
        backgroundColor: AppColors.lightBlueColor.withOpacity(0.0),
        radius: 25,
        backgroundImage: ExactAssetImage('assets/double_decker1.png'),
      );
    } else
      return CircleAvatar(
        backgroundColor: AppColors.lightBlueColor.withOpacity(0.0),
        radius: 25,
        backgroundImage: ExactAssetImage('assets/bus2.png'),
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
        backgroundColor: AppColors.whiteColor,
        percent: 0.3,
      );
    } else if (load == 'SDA') {
      return LinearPercentIndicator(
        progressColor: Colors.yellow[800],
        backgroundColor: AppColors.whiteColor,
        percent: 0.6,
      );
    } else {
      return LinearPercentIndicator(
        progressColor: Colors.red[800],
        backgroundColor: AppColors.whiteColor,
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
