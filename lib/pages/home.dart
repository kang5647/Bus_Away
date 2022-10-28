import 'package:flutter/material.dart';
import 'package:test_app/arrival_notification/arrival_data.dart';
import 'package:test_app/arrival_notification/bus_service.dart';
import 'package:test_app/arrival_notification/checkArrival.dart';
import 'package:test_app/weather/get_weather_data.dart';
import 'package:test_app/weather/weather_data.dart';
import 'package:test_app/arrival_notification/get_bus_arrival_api.dart';
import 'search_bus.dart';
import 'dart:async';
import 'package:test_app/Utility/app_colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final weatherData = WeatherData();
  WeatherResponse _response =
      WeatherResponse(temperature: 0, description: 'loading', icon: '01d');

  // test case prevstop = 27061, leeweenam = 27211
  final arrivalData = ArrivalData();
  ArrivalResponse _arrivalResponse =
      ArrivalResponse(busStopCode: '27061', estimatedArrival: DateTime.now());
  final bus = BusService();

  Stream<int> getStopsAway(ArrivalManager arrivalManager) async* {
    while (true) {
      yield arrivalManager.getNoOfStopsAway();
      //await Future.delayed(Duration(seconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    updateWeather();
    final arrivalManager = ArrivalManager(bus, '27311', '27211');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bus Away',
          style: TextStyle(
            fontSize: 30,
            letterSpacing: 5,
            wordSpacing: 5,
            fontFamily: 'GemunuLibre',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          padding: const EdgeInsets.all(25),
          icon: Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        toolbarHeight: 80,
        actions: [
          if (_response != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  _response.iconUrl,
                  width: 50,
                ),
                Text(
                  '${_response.temperature}℃',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          // navigate to search/ screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              padding: const EdgeInsets.only(
                  left: 10, right: 25, top: 25, bottom: 25),
              icon: Icon(
                Icons.search,
                size: 30,
              )),
        ],
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
      ),
      body: Container(
          color: Colors.blueGrey[800],
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 350, 10, 0),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.lightBlueColor.withOpacity(0.7),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text('179'),
                    IconButton(
                      onPressed: () => {
                        arrivalManager.arrivalAssistant(),
                      },
                      icon: Image.asset('assets/icon_bus.png'),
                    ),
                  ]),
                  Text('Current Bus Stop: '),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        height: 100,
                        child: StreamBuilder<int>(
                          stream: getStopsAway(arrivalManager),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(children: <Widget>[
                                Text('No. of Stops Away: '),
                                Text(
                                  'loading',
                                ),
                              ]);
                            } else {
                              return Column(children: <Widget>[
                                Text('No. of Stops Away: '),
                                Text(
                                  '${snapshot.data}',
                                ),
                              ]);
                            }
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                      ),
                    ],
                  )
                ]),
          )),
    );
  }

  void updateWeather() async {
    final response = await weatherData.getWeather();
    Future.delayed(const Duration(seconds: 10))
        .then((value) => setState(() => _response = response));
    // print(response.temperature);
    // print(response.description);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final response = await weatherData.getWeather();
      setState(() => _response = response);
    });
  }
}
