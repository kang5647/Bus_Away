class BusService {
  late List<String> route;
  late List<String> busStopName;
  late int start;
  late int end;
  late String startStop;
  late String endStop;

  BusService() {
    this.route = [
      '27291',
      '27311',
      '27061',
      '27211'
    ]; // test from hall2 to lee wee nam lib
    this.busStopName = [
      'Opp Hall 6',
      'Hall 2',
      'Opp Blk 41',
      'Lee Wee Name Lib'
    ];
    this.start = 0;
    this.end = 3;
    this.startStop = route[0];
    this.endStop = route[3];
  }

  setBoarding(String busStopCode) {
    this.startStop = busStopCode;
  }

  setAlighting(String busStopCode) {
    this.endStop = busStopCode;
  }
}
