/// Bus Service model class which stores the attributes of a bus service
/// Contains 2 methods: [toJson] and [fromJson]
/// [toJson]: convert an object list to json object
/// [fromJson]: convert json object to an object list
class BusEta {
  BusEta({
    //required this.odataMetadata,
    required this.busStopCode,
    required this.services,
  });

  //String odataMetadata;
  String busStopCode;
  List<Service> services;

  factory BusEta.fromJson(Map<String, dynamic> json) => BusEta(
        //odataMetadata: json["odata.metadata"],
        busStopCode: json["BusStopCode"],
        services: List<Service>.from(
            json["Services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        //"odata.metadata": odataMetadata,
        "BusStopCode": busStopCode,
        "Services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

class Service {
  Service({
    required this.serviceNo,
    required this.serviceOperator,
    required this.nextBus,
    required this.nextBus2,
    required this.nextBus3,
  });

  String serviceNo;
  String serviceOperator;
  NextBus nextBus;
  NextBus nextBus2;
  NextBus nextBus3;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceNo: json["ServiceNo"],
        serviceOperator: json["Operator"],
        nextBus: NextBus.fromJson(json["NextBus"]),
        nextBus2: NextBus.fromJson(json["NextBus2"]),
        nextBus3: NextBus.fromJson(json["NextBus3"]),
      );

  Map<String, dynamic> toJson() => {
        "ServiceNo": serviceNo,
        "Operator": serviceOperator,
        "NextBus": nextBus.toJson(),
        "NextBus2": nextBus2.toJson(),
        "NextBus3": nextBus3.toJson(),
      };
}

class NextBus {
  NextBus({
    required this.originCode,
    required this.destinationCode,
    required this.estimatedArrival,
    required this.latitude,
    required this.longitude,
    required this.visitNumber,
    required this.load,
    required this.feature,
    required this.type,
  });

  String originCode;
  String destinationCode;
  String estimatedArrival;
  String latitude;
  String longitude;
  String visitNumber;
  String load;
  String feature;
  String type;

  factory NextBus.fromJson(Map<String, dynamic> json) => NextBus(
        originCode: json["OriginCode"],
        destinationCode: json["DestinationCode"],
        estimatedArrival: (json["EstimatedArrival"]),
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        visitNumber: json["VisitNumber"],
        load: json["Load"],
        feature: json["Feature"],
        type: json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "OriginCode": originCode,
        "DestinationCode": destinationCode,
        "EstimatedArrival": estimatedArrival,
        "Latitude": latitude,
        "Longitude": longitude,
        "VisitNumber": visitNumber,
        "Load": load,
        "Feature": feature,
        "Type": type,
      };
}
