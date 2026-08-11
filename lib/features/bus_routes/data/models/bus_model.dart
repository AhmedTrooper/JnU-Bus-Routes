import '../../domain/models/bus_enums.dart';

class BusModel {
  final int id;
  final String busName;
  final UserType userType;
  final BusType busType;
  final String upTime;
  final String downTime;
  final String lastStoppage;
  final String? upDirUrl;
  final String? downDirUrl;

  BusModel({
    required this.id,
    required this.busName,
    required this.userType,
    required this.busType,
    required this.upTime,
    required this.downTime,
    required this.lastStoppage,
    this.upDirUrl,
    this.downDirUrl,
  });

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      id: map['id'] as int,
      busName: (map['bus_name'] as String?)?.trim() ?? 'Unknown Bus',
      userType: UserType.fromCode(map['user_type'] as int?),
      busType: BusType.fromCode(map['bus_type'] as int?),
      upTime: (map['up_time'] as String?)?.trim() ?? 'N/A',
      downTime: (map['down_time'] as String?)?.trim() ?? 'N/A',
      lastStoppage: (map['last_stoppage'] as String?)?.trim() ?? 'Unknown',
      upDirUrl: map['up_dir'] as String?,
      downDirUrl: map['down_dir'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bus_name': busName,
      'user_type': userType.code,
      'bus_type': busType.code,
      'up_time': upTime,
      'down_time': downTime,
      'last_stoppage': lastStoppage,
      'up_dir': upDirUrl,
      'down_dir': downDirUrl,
    };
  }
}
