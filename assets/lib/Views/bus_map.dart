/// Return Google map with boarding/alight busStop markers, together with the bus stops in between, in addition to the static markers

import 'dart:async';
import 'package:bus_app/Control/add_markers.dart';
import 'package:bus_app/Control/arrival_manager.dart';
import 'package:bus_app/Views/confirmed_bus_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class BusMap extends StatefulWidget {
  const BusMap(
      {super.key,
      required this.serviceNo,
      required this.busStops,
      required this.boardingStop,
      required this.alightingStop});
  final String serviceNo;
  final List busStops;
  final String boardingStop;
  final String alightingStop;

  @override
  State<BusMap> createState() => BusMapState();
}

class BusMapState extends State<BusMap> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController;
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

  int boardingIndex = 0;
  int alightingIndex = 0;
  bool isSetupReady = false;

  @override
  void initState() {
    super.initState();
  }

  /// Set the static markers and the bus stop markers
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

  /// Set the bus stop based on its designation
  /// For instance, bus Stop with [boardingIndex] is set with [boardingIcon]
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
            infoWindow: InfoWindow(title: busStop['BusStopName']),
            position: LatLng(busStop['Latitude'], busStop['Longitude']),
          )
        };
      } else if (i == alightingIndex) {
        MarkerId busMarkerID = MarkerId(busStop['BusStopName']);
        marker = {
          busMarkerID: Marker(
            icon: alightingIcon,
            markerId: busMarkerID,
            infoWindow: InfoWindow(title: busStop['BusStopName']),
            position: LatLng(busStop['Latitude'], busStop['Longitude']),
          )
        };
      } else {
        MarkerId busMarkerID = MarkerId(busStop['BusStopName']);
        marker = {
          busMarkerID: Marker(
            icon: busstopIcon,
            markerId: busMarkerID,
            infoWindow: InfoWindow(title: busStop['BusStopName']),
            position: LatLng(busStop['Latitude'], busStop['Longitude']),
          )
        };
      }
      markers.addAll(marker);
    }
  }

  /// Set the GoogleMapController
  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    _controller.complete(controller);
  }

  /// Display the map with all the markers after the markers are fully set
  /// Also set the camera to the [boardingStop]
  /// From [busArrivedScreen], upon arrival at the next bus stop, set the camera to it
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
          leading: Padding(
            padding: EdgeInsets.only(right: 0),
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      dispose();
                      Navigator.pop(context);
                    });
              },
            ),
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
                  ArrivalManager arrivalManager = ArrivalManager(
                      widget.busStops,
                      widget.boardingStop,
                      widget.alightingStop,
                      widget.serviceNo);
                  return Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                widget.busStops[boardingIndex]['Latitude'],
                                widget.busStops[boardingIndex]['Longitude']),
                            zoom: 15.0),
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        // polylines: _polylines,
                        onMapCreated: onMapCreated,
                        markers: markers.values.toSet(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Confirmed_info(
                          arrivalManager: arrivalManager,
                          busServiceNo: widget.serviceNo,
                          onBusStopChanged: (String busStopName) {
                            MarkerId markerId = MarkerId(busStopName);
                            var busStopMarker = markers[markerId];
                            googleMapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: busStopMarker!.position,
                                    zoom: 14)));
                          },
                        ),
                      ),
                    ],
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
