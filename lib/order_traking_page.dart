import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'constants.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(1.36081, 103.83212); //Ai Tong Sch
  static const LatLng bus1stop01 = LatLng(1.34939, 103.83729);
  static const LatLng destination =
      LatLng(1.33082, 103.77801); //Opp Ngee Ann Poly

  static const LatLng naturalWNP =
      LatLng(1.359581, 103.826591); //Windsor Natural Park
  static const LatLng naturalBBC =
      LatLng(1.340248, 103.830781); //Bukit Brown Cemetery
  static const LatLng naturalMRC =
      LatLng(1.342354, 103.835833); //MacRitchie Reservoir
  static const LatLng naturalLBS = LatLng(1.341857, 103.830732); //LBS Memorial
  static const LatLng naturalKKG =
      LatLng(1.336683, 103.818498); //Kim Keat Garden
  static const LatLng naturalKHP =
      LatLng(1.330803, 103.818653); //Kheam Hock Park

  List<LatLng> polylineCoordinate = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                zoom: 15.5,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                )),
          ),
        );

        setState(() {});
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(bus1stop01.latitude, bus1stop01.longitude),
    );

    PolylineResult result2 = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(bus1stop01.latitude, bus1stop01.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result1.points.isNotEmpty || result2.points.isNotEmpty) {
      result1.points.forEach(
        (PointLatLng point) => polylineCoordinate.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      result2.points.forEach(
        (PointLatLng point) => polylineCoordinate.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(
          () {}); //go polylines to change the color of the connecting lines
    }
  }

  void setCustomMarkerIcon() {
    //used to set the icons for our markers in project (can custom markers)
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Badge.png")
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
    getPolyPoints();
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
      body: currentLocation == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 15.5),
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCoordinate,
                  color: Colors.blue,
                  width: 4,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon:
                      currentLocationIcon, //implementation of current location icon
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: MarkerId("source"),
                  icon: sourceIcon,
                  position: sourceLocation,
                ),
                Marker(
                  markerId: MarkerId("bus1stop01"),
                  icon: sourceIcon,
                  position: bus1stop01,
                ),
                Marker(
                  markerId: MarkerId("destination"),
                  icon: destinationIcon,
                  position: destination,
                ),
                const Marker(
                  markerId: MarkerId("naturalWNP"),
                  position: naturalWNP,
                ),
                const Marker(
                  markerId: MarkerId("naturalBBC"),
                  position: naturalBBC,
                ),
                const Marker(
                  markerId: MarkerId("naturalMRC"),
                  position: naturalMRC,
                ),
                const Marker(
                  markerId: MarkerId("naturalLBS"),
                  position: naturalLBS,
                ),
                const Marker(
                  markerId: MarkerId("naturalKKG"),
                  position: naturalKKG,
                ),
                const Marker(
                  markerId: MarkerId("naturalKHP"),
                  position: naturalKHP,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
