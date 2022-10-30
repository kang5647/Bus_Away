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

  BitmapDescriptor busstopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor cityIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor natureIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor culturalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor boardingIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor alightingIcon = BitmapDescriptor.defaultMarker;

  Set<Marker> markers = Set();

  void setCustomMarkerIcon() {
    //used to set the icons for our markers in project (can custom markers)
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Pin_source.png")
        .then(
      (icon) {
        this.busstopIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Pin_city.png")
        .then(
      (icon) {
        this.cityIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Pin_nature.png")
        .then(
      (icon) {
        this.natureIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Pin_history.png")
        .then(
      (icon) {
        this.culturalIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/mapmarker_icons/Pin_boarding.png")
        .then(
      (icon) {
        this.boardingIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "assets/mapmarker_icons/Pin_alighting.png")
        .then(
      (icon) {
        this.alightingIcon = icon;
      },
    );
  }

  get getMarkers {
    return markers;
  }

  void setMarkers() {
    //setCustomMarkerIcon();

    //Natural
    markers.add(Marker(
      markerId: MarkerId("naturalWNP"),
      icon: natureIcon,
      position: naturalWNP,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalBBC"),
      icon: natureIcon,
      position: naturalBBC,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalMRC"),
      icon: natureIcon,
      position: naturalMRC,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalLBS"),
      icon: natureIcon,
      position: naturalLBS,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalKKG"),
      icon: natureIcon,
      position: naturalKKG,
    ));
    markers.add(Marker(
      markerId: MarkerId("naturalKHP"),
      icon: natureIcon,
      position: naturalKHP,
    ));

    //City
    markers.add(Marker(
      markerId: MarkerId("cbdION"),
      icon: cityIcon,
      position: cbdION,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdOT"),
      icon: cityIcon,
      position: cbdOT,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbd313"),
      icon: cityIcon,
      position: cbd313,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdDG"),
      icon: cityIcon,
      position: cbdDG,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdBB"),
      icon: cityIcon,
      position: cbdBB,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdCH"),
      icon: cityIcon,
      position: cbdCH,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdBP"),
      icon: cityIcon,
      position: cbdBP,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdST"),
      icon: cityIcon,
      position: cbdST,
    ));
    markers.add(Marker(
      markerId: MarkerId("cbdLV"),
      icon: cityIcon,
      position: cbdLV,
    ));

    //Cultural
    markers.add(Marker(
      markerId: MarkerId("museumFOM"),
      icon: culturalIcon,
      position: museumFOM,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumNM"),
      icon: culturalIcon,
      position: museumNM,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumNG"),
      icon: culturalIcon,
      position: museumNG,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumSCDF"),
      icon: culturalIcon,
      position: museumSCDF,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumAHG"),
      icon: culturalIcon,
      position: museumAHG,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumTFA"),
      icon: culturalIcon,
      position: museumTFA,
    ));
    markers.add(Marker(
      markerId: MarkerId("museumBEA"),
      icon: culturalIcon,
      position: museumBEA,
    ));
  }
}
