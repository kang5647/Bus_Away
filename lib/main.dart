import 'package:flutter/material.dart';
import 'package:bus_away_firestore/searchUI.dart';
import 'firebase setup/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      //help with base layout
      //blue is property and green is the widget
      home: Home(),
    ),
  );
}

//stateless widget cannot change over time
//stateful widget can change over time (eg increasing counts)
//enable hot reload
class Home extends StatelessWidget {
  //String busNo = "unknown";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                );
              },
              icon: const Icon(Icons.search)),
        ],
        backgroundColor: Colors.cyan[900],
        //Color.fromARGB(255, 3, 120, 116),
        toolbarHeight: 80.0,
      ),
      //anything undder the app bar
      body: Container(
        height: 200,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon_bus.png"), fit: BoxFit.cover),
        ),
        margin: EdgeInsets.fromLTRB(10, 100, 10, 50),
      ),
    );
  }
}
