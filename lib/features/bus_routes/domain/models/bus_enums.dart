/// Enum representing target user demographic for a bus
enum UserType {
  student(0, 'Student', 'ছাত্র-ছাত্রী'),
  teacherAndOfficer(1, 'Teacher & Officer', 'শিক্ষক ও কর্মকর্তা'),
  staff(2, 'Staff / Employee', 'কর্মচারী');

  final int code;
  final String englishLabel;
  final String bnLabel;

  const UserType(this.code, this.englishLabel, this.bnLabel);

  static UserType fromCode(int? code) {
    return UserType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => UserType.student,
    );
  }
}

/// Enum representing the vehicle type of the bus
enum BusType {
  singleDecker(0, 'Single Decker', 'একতলা বাস'),
  doubleDecker(1, 'Double Decker (BRTC)', 'দ্বিতল বাস'),
  acOrSpecial(2, 'AC / Special Service', 'এসি / বিশেষ সার্ভিস');

  final int code;
  final String englishLabel;
  final String bnLabel;

  const BusType(this.code, this.englishLabel, this.bnLabel);

  static BusType fromCode(int? code) {
    return BusType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => BusType.singleDecker,
    );
  }
}

/// Enum representing Up vs Down route trip direction
enum RouteDirection {
  up(0, 'Up Route (Morning Trip)', 'আপ ট্রিপ (সকাল)'),
  down(1, 'Down Route (Afternoon Trip)', 'ডাউন ট্রিপ (বিকাল)');

  final int code;
  final String englishLabel;
  final String bnLabel;

  const RouteDirection(this.code, this.englishLabel, this.bnLabel);

  static RouteDirection fromCode(int? code) {
    if (code == 1) return RouteDirection.down;
    return RouteDirection.up;
  }
}
