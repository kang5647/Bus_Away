import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:bus_app/Constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusMap3 extends StatefulWidget {
  const BusMap3({super.key, required this.query});
  final String query;
  @override
  State<BusMap3> createState() => BusMapState();
}

class BusMapState extends State<BusMap3> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Set<Marker> _markers = Set();
  Set<Polyline> _polylines = Set();
  List _busStopCoordinates = [];

  Future<List> searchBusRouteFromFireBase(String query) async {
    List _busStops = [];
    final result = await FirebaseFirestore.instance
        .collection('busRoutes')
        .where('ServiceNo', isEqualTo: query)
        .where('Direction', isEqualTo: 1)
        .orderBy('Distance')
        .get();

    List busRoute = result.docs.map((e) => e.data()).toList();

    for (var element in busRoute) {
      String _busStop = element['BusStopCode'];
      _busStops.add(_busStop);
    }
    return _busStops;
  }

  Future<Map<String, dynamic>> seacrhBusStopFromFireBase(
      String busStopID) async {
    final result = await FirebaseFirestore.instance
        .collection('BusStops')
        .where('BusStopCode', isEqualTo: busStopID)
        .get();

    var busStop = result.docs.map((e) => e.data()).toList();
    var _busStopCoordinate = {
      'latitude': busStop[0]['Latitude'],
      'longitude': busStop[0]['Longitude']
    };
    return _busStopCoordinate;
  }

  Future<List> getBusStopCoordinates(String query) async {
    List _busStopCoordinates = [];
    List busStops = [];
    busStops = await searchBusRouteFromFireBase(query);
    for (var element in busStops) {
      var _busStopCoordinate = await seacrhBusStopFromFireBase(element);
      Marker marker = Marker(
        markerId: MarkerId(element),
        position: LatLng(
            _busStopCoordinate['latitude'], _busStopCoordinate['longitude']),
      );
      _markers.add(marker);
      _busStopCoordinates.add(_busStopCoordinate);
    }
    return _busStopCoordinates;
  }

  void getPolyPoints() async {
    Polyline polyline;
    PolylinePoints _polylinePoints = PolylinePoints();
    for (int i = 0; i < _busStopCoordinates.length; i++) {
      List<LatLng> polylineCoordinates = [];
      int nextIndex = i + 1;
      if (nextIndex == _busStopCoordinates.length) {
        break;
      }

      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(_busStopCoordinates[i]['latitude'],
              _busStopCoordinates[i]['longitude']),
          PointLatLng(_busStopCoordinates[nextIndex]['latitude'],
              _busStopCoordinates[nextIndex]['longitude']),
          travelMode: TravelMode.transit);

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) => polylineCoordinates.add(
              LatLng(point.latitude, point.longitude),
            ));
      }

      setState(() {
        polyline = Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
          geodesic: false,
        );
        _polylines.add(polyline);
      });
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    //getPolyPoints();
  }

  /* Future<LatLng> getCurrentLocation() async {
    Location location = Location();
    LatLng locationCoordinate;
    var locationData = await location.getLocation();

    locationCoordinate =
        LatLng(locationData.latitude!, locationData.longitude!);

    return locationCoordinate;
  }*/

  void setCustomMarkerIcon() {
    //used to set the icons for our markers in project (can custom markers)
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Pin_source.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "assets/mapmarker_icons/Pin_destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Badge.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Bus Away App",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
        body: FutureBuilder(
            future: getBusStopCoordinates(widget.query),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ));
                } else if (snapshot.hasData) {
                  _busStopCoordinates = snapshot.data!;
                  return _busStopCoordinates == null
                      ? const Center(
                          child: Text('No route'),
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(_busStopCoordinates[0]['latitude'],
                                  _busStopCoordinates[0]['longitude']),
                              zoom: 13.0),
                          myLocationButtonEnabled: true,
                          markers: _markers,
                          // polylines: _polylines,
                          onMapCreated: onMapCreated,
                        );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
