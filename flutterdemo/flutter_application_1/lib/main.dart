

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_application_1/searchUI.dart';

void main() {
  runApp(MaterialApp(
    //help with base layout
    //blue is property and green is the widget
    home : Home (),
         
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
        actions:[
          IconButton(onPressed: (){
            showSearch(context: context,
            delegate:MySearchDelegate(),);
            
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
        image: AssetImage("assets/icon_bus.png"),
        fit: BoxFit.cover),
  ),
  margin: EdgeInsets.fromLTRB(10, 100, 10, 50),
      ),

    );
  }
}

