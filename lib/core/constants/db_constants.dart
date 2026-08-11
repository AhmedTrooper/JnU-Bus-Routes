abstract class DbConstants {
  static const String dbName = 'jnu.db';
  static const String assetDbPath = 'assets/database/jnu.db';

  // Table Names
  static const String tableBus = 'bus';
  static const String tablePlace = 'place';
  static const String tableRelation = 'relation';

  // Bus Columns
  static const String colBusId = 'id';
  static const String colBusUpDir = 'up_dir';
  static const String colBusDownDir = 'down_dir';
  static const String colBusName = 'bus_name';
  static const String colBusUserType = 'user_type';
  static const String colBusType = 'bus_type';
  static const String colBusUpTime = 'up_time';
  static const String colBusDownTime = 'down_time';
  static const String colBusLastStoppage = 'last_stoppage';

  // Place Columns
  static const String colPlaceId = 'id';
  static const String colPlaceName = 'place_name';

  // Relation Columns
  static const String colRelId = 'id';
  static const String colRelBusId = 'bus_id';
  static const String colRelPlaceId = 'place_id';
  static const String colRelStoppageNo = 'stoppage_no';
  static const String colRelUpOrDown = 'up_or_down';
}
