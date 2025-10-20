/// Model class for Bus information
class BusModel {
  final String busName;
  final int busType;
  final int upTime;
  final int downTime;
  final String lastStoppage;

  const BusModel({
    required this.busName,
    required this.busType,
    required this.upTime,
    required this.downTime,
    required this.lastStoppage,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      busName: json['bus_name'] as String? ?? json['busName'] as String? ?? '',
      busType: json['bus_type'] as int? ?? 0,
      upTime: json['up_time'] as int? ?? json['upTime'] as int? ?? 0,
      downTime: json['down_time'] as int? ?? json['downTime'] as int? ?? 0,
      lastStoppage: json['last_stoppage'] as String? ?? json['lastStoppage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_name': busName,
      'bus_type': busType,
      'up_time': upTime,
      'down_time': downTime,
      'last_stoppage': lastStoppage,
    };
  }

  @override
  String toString() {
    return 'BusModel(busName: $busName, busType: $busType, upTime: $upTime, downTime: $downTime, lastStoppage: $lastStoppage)';
  }
}
