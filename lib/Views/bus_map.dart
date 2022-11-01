import 'dart:async';

import 'package:bus_app/Control/add_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/animarker_controller_description.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:bus_app/Constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_animarker/flutter_map_marker_animation.dart';

import 'package:flutter_animarker/widgets/animarker.dart';

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

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

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
      var marker;
      if (i == boardingIndex) {
        MarkerId busMarkerID = MarkerId(busStop['BusStopName']);
        marker = {
          busMarkerID: Marker(
            markerId: busMarkerID,
            icon: boardingIcon,
            position: LatLng(busStop['Latitude'], busStop['Longitude']),
          )
        };
      } else if (i == alightingIndex) {
        MarkerId busMarkerID = MarkerId(busStop['BusStopName']);
        marker = {
          busMarkerID: Marker(
            icon: alightingIcon,
            markerId: busMarkerID,
            position: LatLng(busStop['Latitude'], busStop['Longitude']),
          )
        };
      } else {
        MarkerId busMarkerID = MarkerId(busStop['BusStopName']);
        marker = {
          busMarkerID: Marker(
            icon: busstopIcon,
            markerId: busMarkerID,
            position: LatLng(busStop['Latitude'], busStop['Longitude']),
          )
        };
      }
      markers.addAll(marker);
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
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == true) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            widget.busStops[boardingIndex]['Latitude'],
                            widget.busStops[alightingIndex]['Longitude']),
                        zoom: 13.0),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    // polylines: _polylines,
                    onMapCreated: onMapCreated,
                    markers: markers.values.toSet(),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
