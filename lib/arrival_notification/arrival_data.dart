class ArrivalResponse {
  late final String busStopCode;
  late final DateTime estimatedArrival;

  ArrivalResponse({required this.busStopCode, required this.estimatedArrival});

  factory ArrivalResponse.fromJson(Map<String, dynamic> json) {
    final estimatedArrival =
        DateTime.parse(json['Services'][0]['NextBus']['EstimatedArrival'])
            .toLocal();
    final busStopCode = json['BusStopCode'];

    return ArrivalResponse(
        busStopCode: busStopCode, estimatedArrival: estimatedArrival);
  }
}
