import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerAdder {
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

  static const LatLng cbdION = LatLng(1.304581, 103.832120); //Orchard Ion
  static const LatLng cbdOT = LatLng(1.307236, 103.829392); //Orchard Towers
  static const LatLng cbd313 = LatLng(1.301333, 103.838695); //Somerset 313
  static const LatLng cbdDG = LatLng(1.299096, 103.845534); //Dhoby Ghaut
  static const LatLng cbdBB = LatLng(1.297654, 103.850659); //Bras Basah
  static const LatLng cbdCH = LatLng(1.293222, 103.851857); //City Hall
  static const LatLng cbdBP = LatLng(1.299372, 103.854623); //Bugis+
  static const LatLng cbdST = LatLng(1.296324, 103.856258); //Suntec
  static const LatLng cbdLV = LatLng(1.306954, 103.862549); //Lavender/ ICA

  static const LatLng museumFOM = LatLng(1.2942049, 103.8500893); //friends of M
  static const LatLng museumNM = LatLng(1.2969780, 103.8487761); //National M
  static const LatLng museumNG = LatLng(1.2912791, 103.850749); //National Gal
  static const LatLng museumSCDF = LatLng(1.291888, 103.849256); //Civil Defence
  static const LatLng museumAHG = LatLng(1.292826, 103.849048); //Armenian H G
  static const LatLng museumTFA =
      LatLng(1.2965127, 103.8534394); //Today FineArt
  static const LatLng museumBEA = LatLng(1.308510, 103.902871); //Black Earth

  Set<Marker> markers = Set();

  get getMarkers {
    return markers;
  }

  void setStaticMarkers(BitmapDescriptor busstopIcon, BitmapDescriptor cityIcon,
      BitmapDescriptor natureIcon, BitmapDescriptor culturalIcon) async {
    //Natural
    markers.add(Marker(
      markerId: MarkerId("naturalWNP"),
      icon: natureIcon,
      infoWindow: InfoWindow(title: "Windsor Natural Park"),
      position: naturalWNP,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalBBC"),
      icon: natureIcon,
      infoWindow: InfoWindow(title: "Bukit Brown Cemetery"),
      position: naturalBBC,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalMRC"),
      icon: natureIcon,
      infoWindow: InfoWindow(title: "MacRitchie Reservoir"),
      position: naturalMRC,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalLBS"),
      icon: natureIcon,
      infoWindow: InfoWindow(title: "LBS Memorial"),
      position: naturalLBS,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalKKG"),
      icon: natureIcon,
      infoWindow: InfoWindow(title: "Kim Keat Garden"),
      position: naturalKKG,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalKHP"),
      icon: natureIcon,
      infoWindow: InfoWindow(title: "Kheam Hock Park"),
      position: naturalKHP,
    ));

    //City
    markers.add(Marker(
      markerId: MarkerId("cbdION"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "ION Orchard"),
      position: cbdION,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdOT"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Orchard Towers"),
      position: cbdOT,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbd313"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Somerset 313"),
      position: cbd313,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdDG"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Dhoby Ghaut"),
      position: cbdDG,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdBB"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Bras Basah"),
      position: cbdBB,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdCH"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "City Hall"),
      position: cbdCH,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdBP"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Bugis+"),
      position: cbdBP,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdST"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Suntec City"),
      position: cbdST,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdLV"),
      icon: cityIcon,
      infoWindow: InfoWindow(title: "Lavender/ ICA Building"),
      position: cbdLV,
    ));

    //Cultural
    markers.add(Marker(
      markerId: MarkerId("museumFOM"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "Friends of Museum"),
      position: museumFOM,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumNM"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "National Museum"),
      position: museumNM,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumNG"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "National Gallery"),
      position: museumNG,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumSCDF"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "SCDF Museum"),
      position: museumSCDF,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumAHG"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "Armenian Heritage Gallery"),
      position: museumAHG,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumTFA"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "Today FineArt Museum"),
      position: museumTFA,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumBEA"),
      icon: culturalIcon,
      infoWindow: InfoWindow(title: "Black Earth Art Museum"),
      position: museumBEA,
    ));
  }
}
