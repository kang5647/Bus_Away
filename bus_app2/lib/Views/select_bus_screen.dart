import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'enter_screen.dart';
import 'package:bus_app/Utility/app_colors.dart';
import 'package:bus_app/Control/bus_eta_model.dart';
import 'package:bus_app/Control/bus_service.dart';

class Select_Bus_UI extends StatefulWidget {
  const Select_Bus_UI({super.key});

  @override
  State<Select_Bus_UI> createState() => _Select_Bus_UIState();
}

class _Select_Bus_UIState extends State<Select_Bus_UI> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/backGround1.png'), fit: BoxFit.cover),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(right: 50),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            /*SizedBox(
              width: 35,
              child: Image(image: AssetImage('assets/city.png')),
            ),*/
            Text(
              '7',
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EnterScreen()));
                },
              );
            },
          ),
        ),
      ),
      body: SelectionList(),
    ));
  }
}

class SelectionList extends StatefulWidget {
  const SelectionList({super.key});
  //final List<BusEta> busServiceList;

  @override
  State<SelectionList> createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  @override
  static BusService bus = BusService();

  String dropdownvalue1 = bus.busStopName[0];
  String dropdownvalue2 = bus.busStopName.last;
  var items = bus.busStopName;

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
                      value: dropdownvalue1,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue1 = newValue!;
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
                      value: dropdownvalue2,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue2 = newValue!;
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
