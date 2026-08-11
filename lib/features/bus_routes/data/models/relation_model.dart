import '../../domain/models/bus_enums.dart';

class RelationModel {
  final int id;
  final int busId;
  final int placeId;
  final int stoppageNo;
  final RouteDirection direction;

  RelationModel({
    required this.id,
    required this.busId,
    required this.placeId,
    required this.stoppageNo,
    required this.direction,
  });

  factory RelationModel.fromMap(Map<String, dynamic> map) {
    final rawUpOrDown = map['up_or_down'];
    final dirInt = (rawUpOrDown is bool)
        ? (rawUpOrDown ? 1 : 0)
        : (rawUpOrDown is int ? rawUpOrDown : 0);

    return RelationModel(
      id: map['id'] as int,
      busId: map['bus_id'] as int? ?? 0,
      placeId: map['place_id'] as int? ?? 0,
      stoppageNo: map['stoppage_no'] as int? ?? 0,
      direction: RouteDirection.fromCode(dirInt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bus_id': busId,
      'place_id': placeId,
      'stoppage_no': stoppageNo,
      'up_or_down': direction.code,
    };
  }
}
