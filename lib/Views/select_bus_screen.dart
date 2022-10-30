import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'enter_screen.dart';
import 'package:bus_app/Utility/app_colors.dart';
import 'package:bus_app/Control/bus_eta_model.dart';

class Select_Bus_UI extends StatefulWidget {
  const Select_Bus_UI({super.key, required this.query});
  final String query;
  @override
  State<Select_Bus_UI> createState() => _Select_Bus_UIState();
}

class _Select_Bus_UIState extends State<Select_Bus_UI> {
  Future<List> seacrhBusStopsFromFireBase(List busStopsCode) async {
    List busStops = [];
    for (String element in busStopsCode) {
      final result = await FirebaseFirestore.instance
          .collection('BusStops')
          .where('BusStopCode', isEqualTo: element)
          .get();
      var busStop = result.docs.map((e) => e.data()).toList()[0];
      busStops.add(busStop);
    }

    return busStops;
  }

  Future<List> getBusStopList(String query) async {
    List busStops = [];
    List busStopsCode = [];
    final result = await FirebaseFirestore.instance
        .collection('busRoutes')
        .where('ServiceNo', isEqualTo: query)
        .where('Direction', isEqualTo: 1)
        .orderBy('Distance')
        .get();

    List busRoute = result.docs.map((e) => e.data()).toList();

    for (var element in busRoute) {
      String busStopCode = element['BusStopCode'];
      busStopsCode.add(busStopCode);
    }
    busStops = await seacrhBusStopsFromFireBase(busStopsCode);
    return busStops;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white.withOpacity(0.0),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/backGround1.png'),
                      fit: BoxFit.cover),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(right: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /*SizedBox(
              width: 35,
              child: Image(image: AssetImage('assets/city.png')),
            ),*/
                      Text(
                        widget.query,
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Bedok Int - Clementi Int", // change to parameters ltr
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
              leading: Padding(
                padding: EdgeInsets.only(right: 0),
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
                                builder: (context) => EnterScreen()));
                      },
                    );
                  },
                ),
              ),
            ),
            body: FutureBuilder(
              future: getBusStopList(widget.query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18),
                    ));
                  } else if (snapshot.hasData) {
                    List busStopList = snapshot.data!;
                    return SelectionList(
                      busStopList: busStopList,
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }
}

class SelectionList extends StatefulWidget {
  const SelectionList({super.key, required this.busStopList});
  final List busStopList;

  @override
  State<SelectionList> createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  late String firstSelectedValue;
  late String lastSelectedValue;
  late List<DropdownMenuItem<String>> dropdownItems;
  List<DropdownMenuItem<String>> getDropdownItems() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var busStop in widget.busStopList) {
      menuItems.add(DropdownMenuItem(
        child: Text(
          busStop['Description'],
          style: TextStyle(
            fontSize: 12,
            color: AppColors.blackColor,
          ),
        ),
        value: busStop['Description'],
      ));
    }
    return menuItems;
  }

  @override
  void initState() {
    super.initState();
    dropdownItems = getDropdownItems();
    firstSelectedValue = widget.busStopList[0]['Description'];
    lastSelectedValue =
        widget.busStopList[widget.busStopList.length - 1]['Description'];
  }

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
            Padding(
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
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                width: 400,
                //alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.blueColor,
                ),
                child: Row(
                  children: [
                    Text(
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
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                width: 400,
                //alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.blueColor,
                ),
                child: Row(
                  children: [
                    Text(
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
              padding: EdgeInsets.only(top: 10),
              child: TextButton(
                  onPressed: () => {},
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontSize: 18),
                  )),
            ),
          ],
        ));
  }
}
