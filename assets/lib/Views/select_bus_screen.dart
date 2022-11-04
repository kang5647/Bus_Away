/// A bus stops selection page which allows the user to set the desired boarding/alighting stop after a bus route is selected
/// Boarding and alighting at the same stop is not allowed, so does alighting before the stops of the boarding point

import 'package:bus_app/Control/arrival_manager.dart';
import 'package:bus_app/Views/bus_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'enter_screen.dart';
import 'package:bus_app/Utility/app_colors.dart';

class Select_Bus_UI extends StatefulWidget {
  const Select_Bus_UI({super.key, required this.query});
  final String query;
  @override
  State<Select_Bus_UI> createState() => _Select_Bus_UIState();
}

class _Select_Bus_UIState extends State<Select_Bus_UI> {
  ///Retrieve the list of bus stops from the bus route
  Future<List> getBusStopList(String query) async {
    /// List of bus stops objects, each contains the [BusStopName], [BusStopCode], [Latitude] and [Longitude]
    List busStops = [];

    ///Getting data from Firestore
    final result = await FirebaseFirestore.instance
        .collection('BusRoutes')
        .where('BusServiceNo', isEqualTo: query)
        .get();

    var resultList = result.docs.map((e) => e.data()).toList();
    var busServiceInfo = resultList[0];

    busStops.addAll(busServiceInfo['BusStops']);

    return busStops;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0.0),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/backGround1.png'),
                      fit: BoxFit.cover),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.query,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),

              /// A back button to navigate to the main page
              leading: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        dispose();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EnterScreen()));
                      },
                    );
                  },
                ),
              ),
            ),

            /// Display the dropdownlist after bus stops list is set
            body: FutureBuilder(
              future: getBusStopList(widget.query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    ));
                  } else if (snapshot.hasData) {
                    List busStopList = snapshot.data!;
                    return SelectionList(
                      busStopList: busStopList,
                      busServiceNo: widget.query,
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }
}

/// Builds the dropdownlist with the bus stops list
class SelectionList extends StatefulWidget {
  const SelectionList(
      {super.key, required this.busStopList, required this.busServiceNo});
  final List busStopList;
  final String busServiceNo;
  @override
  State<SelectionList> createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  /// The value of the first dropdownlist, which indicates the boarding stop
  late String firstSelectedValue;

  /// The value of the second dropdownlist, which indicates the alighting stop
  late String lastSelectedValue;

  /// A manager which helps with updating the current bus stop and stops away from the destination
  /// This class sets the [arrivalManager] for later use
  late ArrivalManager arrivalManager;

  late List<DropdownMenuItem<String>> dropdownItems;

  /// Builds the DropDownItems
  List<DropdownMenuItem<String>> getDropdownItems() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var busStop in widget.busStopList) {
      menuItems.add(DropdownMenuItem(
        child: Text(
          busStop['BusStopName'],
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.blackColor,
          ),
        ),
        value: busStop['BusStopName'],
      ));
    }
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    dropdownItems = getDropdownItems();
    firstSelectedValue = widget.busStopList[0]['BusStopName'];
    lastSelectedValue =
        widget.busStopList[widget.busStopList.length - 1]['BusStopName'];
  }

  ///Set the boarding and alighting points upon button [Submit] is pressed, navigate to the next page with relevant values
  ///Same busStops for boarding/alighting are not allowed, alighting before the boarding point is also prohibited
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.lightBlueColor.withOpacity(0.7),
        ),
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 330),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, top: 10),
              child: Text(
                'Select your Boarding and Alighting point',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                width: 400,
                //alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.blueColor,
                ),
                child: Row(
                  children: [
                    const Text(
                      textAlign: TextAlign.left,
                      'Boarding Point:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    DropdownButton(
                      value: firstSelectedValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          firstSelectedValue = newValue!;
                        });
                      },
                    )
                  ],
                )),
            Container(
                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                width: 400,
                //alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.blueColor,
                ),
                child: Row(
                  children: [
                    const Text(
                      textAlign: TextAlign.left,
                      'Alighting Point:  ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    DropdownButton(
                      value: lastSelectedValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropdownItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          lastSelectedValue = newValue!;
                        });
                      },
                    )
                  ],
                )),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                  onPressed: () => {
                        arrivalManager = ArrivalManager(
                            widget.busStopList,
                            firstSelectedValue,
                            lastSelectedValue,
                            widget.busServiceNo),
                        if (arrivalManager.curIndex >= arrivalManager.destIndex)
                          {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text(
                                      "Please enter an appropriate boarding point"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("PROCEED"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Select_Bus_UI(
                                                        query: widget
                                                            .busServiceNo)));
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          }
                        else
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BusMap(
                                        serviceNo: widget.busServiceNo,
                                        busStops: widget.busStopList,
                                        boardingStop: firstSelectedValue,
                                        alightingStop: lastSelectedValue)))
                          }
                      },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ],
        ));
  }
}
