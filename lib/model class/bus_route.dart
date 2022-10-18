class BusRoute {
  final String serviceNo;
  final String operator;
  final int direction;
  final int stopSequence;
  final String busStopCode;
  final num distance;
  final String wdFirstBus;
  final String wdLastBus;
  final String satFirstBus;
  final String satLastBus;
  final String sunFirstBus;
  final String sunLastBus;

  const BusRoute(
      {required this.serviceNo,
      required this.operator,
      required this.direction,
      required this.stopSequence,
      required this.busStopCode,
      required this.distance,
      required this.wdFirstBus,
      required this.wdLastBus,
      required this.satFirstBus,
      required this.satLastBus,
      required this.sunFirstBus,
      required this.sunLastBus});

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      serviceNo: json['ServiceNo'] as String,
      operator: json['Operator'] as String,
      direction: json['Direction'] as int,
      stopSequence: json['StopSequence'] as int,
      busStopCode: json['BusStopCode'] as String,
      distance: json['Distance'] as num,
      wdFirstBus: json['WD_FirstBus'] as String,
      wdLastBus: json['WD_LastBus'] as String,
      satFirstBus: json['SAT_FirstBus'] as String,
      satLastBus: json['SAT_LastBus'] as String,
      sunFirstBus: json['SUN_FirstBus'] as String,
      sunLastBus: json['SUN_LastBus'] as String,
    );
  }
}
