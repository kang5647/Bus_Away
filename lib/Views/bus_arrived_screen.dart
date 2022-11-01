import 'package:bus_app/Control/arrival_manager.dart';
import 'package:bus_app/Views/confirmed_bus_user_screen.dart';

import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:bus_app/Utility/app_colors.dart';

class busArrivedScreen extends StatefulWidget {
  const busArrivedScreen(
      {super.key,
      required this.busNo,
      required this.alighting,
      required this.boarding,
      required this.arrivalManager});
  final String busNo;
  final String boarding;
  final String alighting;
  final ArrivalManager arrivalManager;

  @override
  State<busArrivedScreen> createState() => _busArrivedScreenState();
}

class _busArrivedScreenState extends State<busArrivedScreen> {
  late int _stopsAway;
  late String _curStop;
  bool notify = false;

  void initState() {
    super.initState();
    //setArrivalManager();
    setState(() {
      _stopsAway = widget.arrivalManager.noOfStopsAway;
      _curStop = widget.arrivalManager
          .busStopList[widget.arrivalManager.curIndex]['BusStopName'];
    });
    Future.delayed(
        Duration(seconds: 5), widget.arrivalManager.arrivalAssistant);
    updateStopsAway(widget.arrivalManager);
    //widget.arrivalManager;
  }

  /*void setArrivalManager() {
    setState(() {
      final arrivalManager = widget.arrivalManager;
      _stopsAway = arrivalManager.noOfStopsAway;
      _curStop = arrivalManager.bus.busStopName[arrivalManager.curIndex];
      //arrivalManager.arrivalAssistant();
      //updateStopsAway(arrivalManager);
    });
  }*/

  void updateStopsAway(ArrivalManager arrivalManager) async {
    final int stopsAway = arrivalManager.getNoOfStopsAway();
    final String curStop = widget.arrivalManager
        .busStopList[widget.arrivalManager.curIndex]['BusStopName'];
    /*setState(() => {_stopsAway = stopsAway, _curStop = curStop});*/
    Future.delayed(const Duration(seconds: 2)).then((value) =>
        setState(() => {_stopsAway = stopsAway, _curStop = curStop}));
    print('No of Stops Away: ${stopsAway}\n');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.arrivalManager.noOfStopsAway == 1 && notify == false) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Notification", "You are arriving at your destination!",
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.lightColor,
            borderRadius: 20,
            margin: EdgeInsets.all(15),
            colorText: AppColors.blackColor);
      });
      /*SchedulerBinding.instance.addPostFrameCallback((_) {
        
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text("You are arriving at your destination!"),
              actions: [
                TextButton(
                  child: const Text("Noted"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              elevation: 24.0,
            );
          },
          barrierDismissible: false,
        );
      });*/
      notify = true;
    }

    if (_stopsAway != 0) updateStopsAway(widget.arrivalManager);

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("${widget.busNo}",
                  style: TextStyle(color: Colors.white, fontSize: 23)),
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
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Confirmed_info(
                                    busServiceNo: widget.busNo,
                                    arrivalManager: widget.arrivalManager,
                                  )));
                    },
                  );
                },
              ),
            ),
            //title: const Text('bus arrival'),
            body: Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.lightBlueColor.withOpacity(0.7),
              ),
              margin: const EdgeInsets.fromLTRB(10, 400, 10, 0),
              padding: EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                          '${widget.arrivalManager.getBusStopName(widget.arrivalManager.curIndex)} - ${widget.arrivalManager.getBusStopName(widget.arrivalManager.destIndex)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 350,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.darkBlueColor.withOpacity(1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Current bus stop: ${_curStop} ",
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 200),
                    //   child: Text("Current bus stop: ${_curStop}",
                    //       style: TextStyle(
                    //           color: AppColors.darkBlueColor, fontSize: 15)),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 350,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.darkBlueColor.withOpacity(1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("Number of stops away: ${_stopsAway} ",
                              style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 200),
                    //   child: Text("Number of stops away: ${_stopsAway}",
                    //       style: TextStyle(
                    //           color: AppColors.darkBlueColor, fontSize: 15)),
                    // ),
                  ]),
            )));
  }
}
