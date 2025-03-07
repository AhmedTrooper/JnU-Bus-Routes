class Place {
  String placeName;

  Place(this.placeName);

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(json["name"]);
  }
}
