import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:bus_app/Constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusMap extends StatefulWidget {
  const BusMap({super.key, required this.query});
  final String query;
  @override
  State<BusMap> createState() => BusMapState();
}

class BusMapState extends State<BusMap> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Set<Marker> markers = Set();
  //List<LatLng> polylineCoordinates = [];

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
      markers.add(marker);
      _busStopCoordinates.add(_busStopCoordinate);
    }
    return _busStopCoordinates;
  }

  Future<List<LatLng>> getPolyPoints(String query) async {
    List busStopCoordinates = await getBusStopCoordinates(query);

    PolylinePoints _polylinePoints = PolylinePoints();
    List<LatLng> _polylineCoordinates = [];

    for (int i = 0; i < busStopCoordinates.length; i++) {
      int nextIndex = i + 1;
      if (nextIndex == busStopCoordinates.length) {
        break;
      }

      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(busStopCoordinates[i]['latitude'],
              busStopCoordinates[i]['longitude']),
          PointLatLng(busStopCoordinates[nextIndex]['latitude'],
              busStopCoordinates[nextIndex]['longitude']),
          travelMode: TravelMode.transit);
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) => _polylineCoordinates.add(
              LatLng(point.latitude, point.longitude),
            ));
      }
    }
    return _polylineCoordinates;
  }

  void getCurrentLocation() async {
    Location location = Location();

    await location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
  }

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
    getCurrentLocation();
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
            future: getPolyPoints(widget.query),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ));
                } else if (snapshot.hasData) {
                  final polylineCoordinates = snapshot.data;
                  return polylineCoordinates == null
                      ? const Center(child: Text("No route"))
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                              zoom: 15.5),
                          myLocationEnabled: true,
                          polylines: {
                            Polyline(
                              polylineId: PolylineId("route"),
                              points: polylineCoordinates,
                              color: Colors.blue,
                              width: 4,
                            ),
                          },
                          onMapCreated: (mapController) {
                            _controller.complete(mapController);
                          },
                          markers: markers,
                        );
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
