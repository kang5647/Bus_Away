import 'dart:async';

import 'package:bus_app/Control/add_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:bus_app/Constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusMap extends StatefulWidget {
  const BusMap(
      {super.key,
      required this.busStops,
      required this.boardingStop,
      required this.alightingStop});
  final List busStops;
  final String boardingStop;
  final String alightingStop;

  @override
  State<BusMap> createState() => BusMapState();
}

class BusMapState extends State<BusMap> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  BitmapDescriptor boardingIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor alightingIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor busstopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor cityIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor natureIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor culturalIcon = BitmapDescriptor.defaultMarker;
  MarkerAdder staticMarkers = MarkerAdder();

  Set<Marker> markers = Set();
  Set<Polyline> _polylines = Set();
  List _busStopCoordinates = [];

  int boardingIndex = 0;
  int alightingIndex = 0;
  bool isSetupReady = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> setMarkers() async {
    boardingIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/mapmarker_icons/Pin_boarding.png");
    alightingIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/mapmarker_icons/Pin_alighting.png");
    busstopIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/mapmarker_icons/Pin_source.png");

    cityIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/mapmarker_icons/Pin_city.png");

    natureIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/mapmarker_icons/Pin_nature.png");

    culturalIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/mapmarker_icons/Pin_history.png");

    staticMarkers.setStaticMarkers(
        busstopIcon, cityIcon, natureIcon, culturalIcon);

    markers.addAll(staticMarkers.getMarkers);
    getBusStops(widget.busStops);

    return true;
  }

  void getBusStops(List busStops) {
    for (int i = 0; i < busStops.length; i++) {
      var busStop = busStops[i];
      if (busStop['BusStopName'] == widget.boardingStop) {
        boardingIndex = i;
      }
      if (busStop['BusStopName'] == widget.alightingStop) {
        alightingIndex = i;
        break;
      }
    }
    for (int i = boardingIndex; i < alightingIndex + 1; i++) {
      var busStop = busStops[i];
      Marker marker;
      if (i == boardingIndex) {
        marker = Marker(
          markerId: MarkerId(busStop['BusStopCode']),
          icon: boardingIcon,
          position: LatLng(busStop['Latitude'], busStop['Longitude']),
        );
      } else if (i == alightingIndex) {
        marker = Marker(
          icon: alightingIcon,
          markerId: MarkerId(busStop['BusStopCode']),
          position: LatLng(busStop['Latitude'], busStop['Longitude']),
        );
      } else {
        marker = Marker(
          icon: busstopIcon,
          markerId: MarkerId(busStop['BusStopCode']),
          infoWindow: InfoWindow(title: "no." + i.toString()),
          position: LatLng(busStop['Latitude'], busStop['Longitude']),
        );
      }
      markers.add(marker);
    }
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
            future: setMarkers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.data == true)
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            widget.busStops[boardingIndex]['Latitude'],
                            widget.busStops[alightingIndex]['Longitude']),
                        zoom: 13.0),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    markers: markers,
                    // polylines: _polylines,
                    onMapCreated: onMapCreated,
                  );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
