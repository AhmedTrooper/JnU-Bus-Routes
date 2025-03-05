class BusModel {
  String busName;
  int upTime;
  int downTime;
  String lastStoppage;
  BusModel(this.busName, this.upTime, this.downTime, this.lastStoppage);
  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      json['busName'],
      json['upTime'],
      json['downTime'],
      json['lastStoppage'],
    );
  }
}