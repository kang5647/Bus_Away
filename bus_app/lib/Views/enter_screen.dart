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
import 'package:flutter/services.dart' show rootBundle;

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String? _mapStyle;
  GoogleMapController? myMapController;

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
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              zoomControlsEnabled: false,
              compassEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);
              },
              initialCameraPosition: _kGooglePlex,
            ),
          ),
          // Bus route selection on top
          buildRouteSelection(),

          // GPS current location widget on bottom right
          buildCurrentLocationIcon(),

          // Bottom swipe up sheet
          buildBottomSheet(),
        ],
      ),
    );
  }
}

Widget buildRouteSelection() {
  return Positioned(
    top: 30,
    left: 10,
    right: 10,
    child: Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 2)
          ]),
      child: Row(
        children: [
          //write smth here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Select your ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Bus Route",
                      style: TextStyle(
                        color: AppColors.darkBlueColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "*ETA learning & optimising in progress.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bus),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(CupertinoIcons.bus),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(CupertinoIcons.bus),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildCurrentLocationIcon() {
  return const Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: EdgeInsets.only(bottom: 35.0, right: 12.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.darkBlueColor,
        child: Icon(
          Icons.my_location,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget buildBottomSheet() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: Get.width * 0.8,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2.0,
              blurRadius: 2.0)
        ],
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Center(
        child: Container(
          width: Get.width * 0.4,
          height: 4,
          color: Colors.black45.withOpacity(0.65),
        ),
      ),
    ),
  );
}
