class PlaceModel {
  final int id;
  final String placeName;

  PlaceModel({
    required this.id,
    required this.placeName,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map['id'] as int,
      placeName: (map['place_name'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place_name': placeName,
    };
  }
}
