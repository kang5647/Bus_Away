import 'dart:ui';

import 'package:bus_app/Utility/app_colors.dart';
import 'package:bus_app/Utility/app_constants.dart';
import 'package:bus_app/Views/home_screen.dart';
import 'package:bus_app/Views/login_screen.dart';
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

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  String? _mapStyle;
  late GoogleMapController googleMapController;

  Set<Marker> markers = {};

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

  @override
  void initState() {
    super.initState();
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
            child: GoogleMap(
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
          buildTextField(),

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
                  child: Icon(
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
}

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
                  children: [
                    busRouteIcon("City", "assets/city.png"),
                    const SizedBox(
                      width: 45,
                    ),
                    busRouteIcon("Heartland", "assets/house.png"),
                    const SizedBox(
                      width: 45,
                    ),
                    busRouteIcon("Nature", "assets/nature.png"),
                    const SizedBox(
                      width: 45,
                    ),
                    busRouteIcon("Cultural", "assets/history.png"),
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

Widget busRouteIcon(String route, String picPath) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.lightBlueColor.withOpacity(0.4),
          radius: 26,
          backgroundImage: ExactAssetImage(picPath),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          route,
          style: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
        )
      ],
    ),
  );
}

Widget buildTextField() {
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
                // Bus icon
                Icon(
                  CupertinoIcons.bus,
                  color: AppColors.greyColor,
                  size: 30.0,
                ),

                // Spaced Seprator
                const SizedBox(
                  width: 30,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
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
