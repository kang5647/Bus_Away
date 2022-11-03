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

  //<Marker> markers = Set();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  get getMarkers {
    return markers;
  }

  void setStaticMarkers(BitmapDescriptor busstopIcon, BitmapDescriptor cityIcon,
      BitmapDescriptor natureIcon, BitmapDescriptor culturalIcon) async {
    //Natural
    var naturalMarker1 = {
      MarkerId("naturalWNP"): Marker(
          markerId: MarkerId("naturalWNP"),
          icon: natureIcon,
          infoWindow: InfoWindow(title: "Windsor Natural Park"),
          position: naturalWNP),
    };
    var naturalMarker2 = {
      MarkerId("naturalBBC"): Marker(
          markerId: MarkerId("naturalBBC"),
          icon: natureIcon,
          infoWindow: InfoWindow(title: "Bukit Brown Cemetery"),
          position: naturalBBC),
    };
    var naturalMarker3 = {
      MarkerId("naturalMRC"): Marker(
          markerId: MarkerId("naturalMRC"),
          icon: natureIcon,
          infoWindow: InfoWindow(title: "MacRitchie Reservoir"),
          position: naturalMRC),
    };
    var naturalMarker4 = {
      MarkerId("naturalLBS"): Marker(
          markerId: MarkerId("naturalLBS"),
          icon: natureIcon,
          infoWindow: InfoWindow(title: "LBS Memorial"),
          position: naturalLBS),
    };
    var naturalMarker5 = {
      MarkerId("naturalKKG"): Marker(
          markerId: MarkerId("naturalKKG"),
          icon: natureIcon,
          infoWindow: InfoWindow(title: "Kim Keat Garden"),
          position: naturalKKG),
    };
    var naturalMarker6 = {
      MarkerId("naturalKHP"): Marker(
          markerId: MarkerId("naturalKHP"),
          icon: natureIcon,
          infoWindow: InfoWindow(title: "Kheam Hock Park"),
          position: naturalKHP),
    };

    markers.addAll(naturalMarker1);
    markers.addAll(naturalMarker2);
    markers.addAll(naturalMarker3);
    markers.addAll(naturalMarker4);
    markers.addAll(naturalMarker5);
    markers.addAll(naturalMarker6);

    //City
    var cityMarker1 = {
      MarkerId("cbdION"): Marker(
          markerId: MarkerId("cbdION"),
          infoWindow: InfoWindow(title: "ION Orchard"),
          icon: cityIcon,
          position: cbdION),
    };
    var cityMarker2 = {
      MarkerId("cbdOT"): Marker(
          markerId: MarkerId("cbdOT"),
          infoWindow: InfoWindow(title: "Orchard Towers"),
          icon: cityIcon,
          position: cbdOT),
    };
    var cityMarker3 = {
      MarkerId("cbd313"): Marker(
          markerId: MarkerId("cbd313"),
          infoWindow: InfoWindow(title: "Somerset 313"),
          icon: cityIcon,
          position: cbd313),
    };
    var cityMarker4 = {
      MarkerId("cbdDG"): Marker(
          markerId: MarkerId("cbdDG"),
          infoWindow: InfoWindow(title: "Dhoby Ghaut"),
          icon: cityIcon,
          position: cbdDG),
    };
    var cityMarker5 = {
      MarkerId("cbdCH"): Marker(
          markerId: MarkerId("cbdCH"),
          infoWindow: InfoWindow(title: "City Hall"),
          icon: cityIcon,
          position: cbdCH),
    };
    var cityMarker6 = {
      MarkerId("cbdBP"): Marker(
          markerId: MarkerId("cbdBP"),
          infoWindow: InfoWindow(title: "Bugis+"),
          icon: cityIcon,
          position: cbdBP),
    };
    var cityMarker7 = {
      MarkerId("cbdST"): Marker(
          markerId: MarkerId("cbdST"),
          infoWindow: InfoWindow(title: "Suntec City"),
          icon: cityIcon,
          position: naturalWNP),
    };
    var cityMarker8 = {
      MarkerId("cbdLV"): Marker(
          markerId: MarkerId("cbdLV"),
          infoWindow: InfoWindow(title: "Lavender/ ICA Building"),
          icon: cityIcon,
          position: cbdLV),
    };
    var cityMarker9 = {
      MarkerId("cbdBB"): Marker(
          markerId: MarkerId("cbdBB"),
          infoWindow: InfoWindow(title: "Bras Basah"),
          icon: cityIcon,
          position: cbdLV),
    };

    markers.addAll(cityMarker1);
    markers.addAll(cityMarker2);
    markers.addAll(cityMarker3);
    markers.addAll(cityMarker4);
    markers.addAll(cityMarker5);
    markers.addAll(cityMarker6);
    markers.addAll(cityMarker7);
    markers.addAll(cityMarker8);
    markers.addAll(cityMarker9);

    //Cultural
    var museumMarker1 = {
      MarkerId("museumFOM"): Marker(
          markerId: MarkerId("museumFOM"),
          icon: culturalIcon,
          infoWindow: InfoWindow(title: "Friends of Museum"),
          position: museumFOM),
    };

    var museumMarker2 = {
      MarkerId("museumNM"): Marker(
          markerId: MarkerId("museumNM"),
          infoWindow: InfoWindow(title: "National Museum"),
          icon: culturalIcon,
          position: museumNM),
    };
    var museumMarker3 = {
      MarkerId("museumNG"): Marker(
          markerId: MarkerId("museumNG"),
          infoWindow: InfoWindow(title: "National Gallery"),
          icon: culturalIcon,
          position: museumNG),
    };
    var museumMarker4 = {
      MarkerId("museumSCDF"): Marker(
          markerId: MarkerId("museumSCDF"),
          icon: culturalIcon,
          infoWindow: InfoWindow(title: "SCDF Museum"),
          position: museumSCDF),
    };
    var museumMarker5 = {
      MarkerId("museumAHG"): Marker(
          markerId: MarkerId("museumAHG"),
          infoWindow: InfoWindow(title: "Armenian Heritage Gallery"),
          icon: culturalIcon,
          position: museumAHG),
    };
    var museumMarker6 = {
      MarkerId("museumTFA"): Marker(
          markerId: MarkerId("museumTFA"),
          infoWindow: InfoWindow(title: "Today FineArt Museum"),
          position: museumTFA),
    };
    var museumMarker7 = {
      MarkerId("museumBEA"): Marker(
          markerId: MarkerId("museumBEA"),
          infoWindow: InfoWindow(title: "Black Earth Art Museum"),
          icon: culturalIcon,
          position: museumBEA),
    };

    markers.addAll(museumMarker1);
    markers.addAll(museumMarker2);
    markers.addAll(museumMarker3);
    markers.addAll(museumMarker4);
    markers.addAll(museumMarker5);
    markers.addAll(museumMarker6);
    markers.addAll(museumMarker7);
  }
}
