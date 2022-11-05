/// A bus stops selection page which allows the user to set the desired boarding/alighting stop after a bus route is selected
/// Boarding and alighting at the same stop is not allowed, so does alighting before the stops of the boarding point

import 'package:bus_app/Control/arrival_manager.dart';
import 'package:bus_app/Views/bus_map.dart';
import 'package:bus_app/Widgets/blue_intro_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'enter_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bus_app/Utility/app_colors.dart';

import '../Widgets/text_widget.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Logo at top
          Container(
            height: Get.height * 0.4,
            child: blueSelectScreenWidget(),
          ),

          // Back button
          Positioned(
            top: 30,
            left: 20,
            child: InkWell(
              onTap: () {
                dispose();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EnterScreen()),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 15),
              ),
            ),
          ),

          // Space seprator
          const SizedBox(
            height: 80,
          ),

          FutureBuilder(
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
              }),
        ],
      ),
    );
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
          busStop['BusStopName'].toString().toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
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
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 330),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5, top: 10),
              child:

                  // Title for boarding and alighting
                  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget(
                      text: "Set Boarding and Alighting",
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),

            // Spaced seprator
            const SizedBox(
              height: 30,
            ),

            // Column for selecting boarding bus stop
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boarding Point text
                  Text(
                    'Boarding Point',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),

                  // Spaced seprator
                  const SizedBox(
                    height: 6,
                  ),

                  // Box for the boarding point
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    width: Get.width,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 2,
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 28,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: Get.width * 0.72,
                          height: 55,
                          padding: EdgeInsets.only(top: 5.0),
                          child: DropdownButton(
                            underline: Container(),
                            isExpanded: true,
                            value: firstSelectedValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: dropdownItems,
                            onChanged: (String? newValue) {
                              setState(() {
                                firstSelectedValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Spaced seprator
            const SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boarding Point text
                  Text(
                    'Alighting Point',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),

                  // Spaced seprator
                  const SizedBox(
                    height: 6,
                  ),

                  // Box for the boarding point
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    width: Get.width,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 2,
                              blurRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 28,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: Get.width * 0.72,
                          height: 55,
                          padding: EdgeInsets.only(top: 5.0),
                          child: DropdownButton(
                            underline: Container(),
                            isExpanded: true,
                            value: lastSelectedValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: dropdownItems,
                            onChanged: (String? newValue) {
                              setState(() {
                                lastSelectedValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Spcaed Seprator
            const SizedBox(
              height: 50,
            ),

            // Confirm button
            MaterialButton(
              minWidth: Get.width,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: AppColors.darkBlueColor,
              onPressed: () => {
                arrivalManager = ArrivalManager(widget.busStopList,
                    firstSelectedValue, lastSelectedValue, widget.busServiceNo),
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
                                        builder: (context) => Select_Bus_UI(
                                            query: widget.busServiceNo)));
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
              child: Text(
                'Confirm',
                style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),

            // Container(
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.only(top: 10),
            //   child: TextButton(
            //       onPressed: () => {
            //             arrivalManager = ArrivalManager(
            //                 widget.busStopList,
            //                 firstSelectedValue,
            //                 lastSelectedValue,
            //                 widget.busServiceNo),
            //             if (arrivalManager.curIndex >= arrivalManager.destIndex)
            //               {
            //                 showDialog(
            //                   context: context,
            //                   builder: (BuildContext context) {
            //                     return AlertDialog(
            //                       title: const Text("Error"),
            //                       content: const Text(
            //                           "Please enter an appropriate boarding point"),
            //                       actions: <Widget>[
            //                         TextButton(
            //                           child: const Text("PROCEED"),
            //                           onPressed: () {
            //                             Navigator.of(context).pop();
            //                             Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                     builder: (context) =>
            //                                         Select_Bus_UI(
            //                                             query: widget
            //                                                 .busServiceNo)));
            //                           },
            //                         ),
            //                       ],
            //                     );
            //                   },
            //                 )
            //               }
            //             else
            //               {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => BusMap(
            //                             serviceNo: widget.busServiceNo,
            //                             busStops: widget.busStopList,
            //                             boardingStop: firstSelectedValue,
            //                             alightingStop: lastSelectedValue)))
            //               }
            //           },
            //       child: Text(
            //         'Confirm',
            //         style: TextStyle(fontSize: 18),
            //       )),
            // ),
          ],
        ));
  }
}
