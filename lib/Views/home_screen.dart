import 'package:bus_app/Views/bus_map.dart';
import 'package:bus_app/Views/enter_screen.dart';
import 'package:bus_app/Views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialise Firebase App
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            // If connection is successful, enter the login screen
            if (snapshot.connectionState == ConnectionState.done) {
              return EnterScreen();
            }

            // If connection is unsuccessful, load the progress indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
