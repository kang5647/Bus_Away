import 'dart:async';

import 'package:bus_app/Control/weather_control.dart';
import 'package:bus_app/Utility/app_colors.dart';
import 'package:bus_app/Utility/app_constants.dart';
import 'package:bus_app/Views/bus_map2.dart';
import 'package:bus_app/Views/bus_map3.dart';
import 'package:bus_app/Views/home_screen.dart';
import 'package:bus_app/Views/login_screen.dart';
import 'package:bus_app/Views/select_bus_screen.dart';
import 'package:bus_app/Widgets/blue_intro_widget.dart';
import 'package:bus_app/Widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bus_app/Views/eta_screen.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  // Initial camera position for Google Maps
  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  String? _mapStyle;
  late GoogleMapController googleMapController;
  WeatherApiClient client = WeatherApiClient();
  Weather? data;
  Timer? _timer;
  Set<Marker> markers = {};

  // Function to determine the live location of the user
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location services is disabled!");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied!");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission permanetly deined!");
    }

    print("Success!");
    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  Future<void> getData() async {
    data = await client.getCurrentWeather();
    print(data!.temp);
    print(data!.cityName);
  }

  @override
  void initState() {
    super.initState();
    client.getCurrentWeather();
    _timer =
        new Timer.periodic(const Duration(minutes: 10), (Timer t) => getData());
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child:
                // Creating the first instance of the Google Map layer
                GoogleMap(
              initialCameraPosition: initialCameraPosition,
              zoomControlsEnabled: false,
              compassEnabled: false,
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
                googleMapController.setMapStyle(_mapStyle);
              },
            ),
          ),

          // Background image
          blueHeader(),

          // Greeting text
          FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              /*
              if (snapshot.connectionState == ConnectionState.done) {
                return buildTextField(data!.temp, data!.mainDesc);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }*/
              return buildTextField(20.0, "Clear");
            },
          ),

          // Bus routes
          buildRouteSelection(),

          // GPS current location widget on bottom right
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 35.0, right: 12.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.blueColor,
                child: InkWell(
                  onTap: () async {
                    Position myPosition = await _determinePosition();
                    print(myPosition);

                    googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(
                                myPosition.latitude, myPosition.longitude),
                            zoom: 14)));

                    markers.clear();
                    markers.add(Marker(
                        markerId: const MarkerId('currentLocation'),
                        position:
                            LatLng(myPosition.latitude, myPosition.longitude)));

                    setState(() {});
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Bottom swipe up sheet
          buildBottomSheet(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// The code for the route selection bar as well as the circles and icons
Widget buildRouteSelection() {
  return Positioned(
    top: 100,
    left: 10,
    right: 10,
    child: Container(
      width: Get.width,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    busRouteIcon(route: "City", picPath: "assets/city.png"),
                    SizedBox(
                      width: 8,
                    ),

                    busRouteIcon(
                        route: "Heartland", picPath: "assets/house.png"),
                    //busRouteIcon("Heartland", "assets/house.png"),
                    SizedBox(
                      width: 8,
                    ),
                    busRouteIcon(route: "Nature", picPath: "assets/nature.png"),
                    //busRouteIcon("Nature", "assets/nature.png"),
                    SizedBox(
                      width: 8,
                    ),
                    busRouteIcon(
                        route: "Cultural", picPath: "assets/history.png"),
                    //busRouteIcon("Cultural", "assets/history.png"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Code for the bottom sheet, where the log out function lies as well
Widget buildBottomSheet() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: InkWell(
      child: Container(
        width: Get.width * 0.9,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 3.0,
                blurRadius: 3.0)
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12)),
        ),
        child: Center(
          child: Container(
            width: Get.width * 0.4,
            height: 4,
            color: Colors.black45.withOpacity(0.25),
          ),
        ),
      ),
      onTap: () async {
        Get.bottomSheet(
          bottomSheetControl(),
        );
      },
    ),
  );
}

class busRouteIcon extends StatefulWidget {
  const busRouteIcon({super.key, required this.route, required this.picPath});
  final String route;
  final String picPath;
  @override
  State<busRouteIcon> createState() => _busRouteIconState();
}

class _busRouteIconState extends State<busRouteIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          if (widget.route == "City") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Select_Bus_UI(query: "7")));
            //bus_eta_ui(busStopCode: "83139", busServiceNo: "15");
            print("clicked");
          } else if (widget.route == "Heartland") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BusMap3(query: "168")));
            //bus_eta_ui(busStopCode: "83139", busServiceNo: "15");
            print("clicked");
          } else if (widget.route == "Nature") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        bus_eta_ui(busStopCode: "22009", busServiceNo: "179")));
            //bus_eta_ui(busStopCode: "83139", busServiceNo: "15");
            print("clicked");
          } else if (widget.route == "Cultural") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        bus_eta_ui(busStopCode: "22009", busServiceNo: "179")));
            //bus_eta_ui(busStopCode: "83139", busServiceNo: "15");

            print("clicked");
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightBlueColor.withOpacity(1.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.whiteColor.withOpacity(0.7),
              radius: 23,
              backgroundImage: ExactAssetImage(widget.picPath),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.route,
                style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// General code to build the different bus route icons used in the buildRouteSelection function
// Widget busRouteIcon(String route, String picPath) {
//   bool _iconIsClicked = false;
//   return SizedBox(
//     width: 82,
//     height: 70,
//     child: ElevatedButton(
//       onPressed: () {
//         //bus_eta_ui(busStopCode: "83139", busServiceNo: "15");
//         print("clicked");
//       },
//       style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.lightBlueColor.withOpacity(1.0)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           CircleAvatar(
//             backgroundColor: AppColors.whiteColor.withOpacity(0.7),
//             radius: 20,
//             backgroundImage: ExactAssetImage(picPath),
//           ),
//           const SizedBox(
//             height: 5.0,
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               route,
//               style: GoogleFonts.poppins(
//                   fontSize: 9,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }

// Code to build the greeting text at the top of the page
Widget buildTextField(double? temp, String? mainDesc) {
  return Positioned(
    top: 30,
    left: 20,
    right: 20,
    child: Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 5,
                blurRadius: 5)
          ]),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                // Weather Icon
                buildWeatherIcon(temp, mainDesc),

                // Spaced Seprator
                const SizedBox(
                  width: 30,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                  child: Text(
                    "Hello there! Select a Bus Route",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Code to show the inside of the bottomSheet when it is pressed
Widget bottomSheetControl() {
  return Container(
    width: Get.width,
    height: Get.height * 0.3,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Logins",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 4,
                      blurRadius: 10),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Get.to(() => HomeScreen());
                },
                child: Row(
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ]),
    ),
  );
}

Widget buildWeatherIcon(double? temp, String? mainDesc) {
  IconData myIcon;
  Color myColor;
  if (mainDesc == "Thunderstorm") {
    myIcon = Icons.thunderstorm;
    myColor = Colors.grey;
  } else if (mainDesc == "Drizzle") {
    myIcon = CupertinoIcons.cloud_drizzle_fill;
    myColor = AppColors.blueColor;
  } else if (mainDesc == "Rain") {
    myIcon = CupertinoIcons.cloud_rain_fill;
    myColor = AppColors.blueColor;
  } else if (mainDesc == "Snow") {
    myIcon = CupertinoIcons.snow;
    myColor = Colors.lightBlue;
  } else if (mainDesc == "Clouds") {
    myIcon = Icons.wb_cloudy;
    myColor = AppColors.greyColor;
  } else {
    myIcon = Icons.sunny;
    myColor = Colors.orange;
  }
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Icon(
            myIcon,
            size: 20,
            color: myColor,
          ),
          const SizedBox(
            height: 3.0,
          ),
          Text(
            "${temp!.toPrecision(1)}°",
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
          )
        ],
      ),
    ),
  );
}
