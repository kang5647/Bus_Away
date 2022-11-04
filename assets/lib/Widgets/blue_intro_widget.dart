/// Widget for building features of the login page

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget blueIntroWidget() {
  return Container(
    width: Get.width,
    height: Get.height * 0.59,
    // The backgournd image
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/backGround.png'), fit: BoxFit.cover)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Bus logo
        SvgPicture.asset(
          'assets/bus-15.svg',
          height: 150,
          width: 150,
          color: Colors.white,
        ),

        // Spaces seprator
        const SizedBox(
          height: 30,
        ),

        // Title of the app
        const Text(
          "BusAway",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),
        )
      ],
    ),
  );
}

Widget blueIntroWidgetWithoutLogos() {
  return Container(
    width: Get.width,
    decoration: const BoxDecoration(
        // The backgournd image
        image: DecorationImage(
            image: AssetImage('assets/backGround.png'), fit: BoxFit.fitHeight)),
    height: Get.height * 0.6,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text for the "Sign Up" title
        Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 35, fontWeight: FontWeight.w600, color: Colors.white),
        ),

        // Spaced seprator
        const SizedBox(
          height: 50,
        ),

        // Icon of the bus
        SvgPicture.asset(
          'assets/bus-15.svg',
          height: 130,
          width: 130,
          color: Colors.white,
        )
      ],
    ),
  );
}

Widget blueHeader() {
  return Container(
    width: Get.width,
    height: Get.height * 0.06,
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/backGround.png"), fit: BoxFit.cover)),
  );
}
