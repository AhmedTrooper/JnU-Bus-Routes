/// Model class for Place information
class Place {
  final String placeName;
  final int? id;

  const Place({
    required this.placeName,
    this.id,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeName: json['place_name'] as String? ?? json['name'] as String? ?? '',
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_name': placeName,
      if (id != null) 'id': id,
    };
  }

  @override
  String toString() {
    return 'Place(placeName: $placeName, id: $id)';
  }
}
