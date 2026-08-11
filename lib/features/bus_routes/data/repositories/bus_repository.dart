import 'package:jnu_bus_routes/core/database/app_database.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/bus_enums.dart';
import 'package:jnu_bus_routes/features/bus_routes/domain/models/route_stoppage.dart';
import 'package:jnu_bus_routes/features/bus_routes/data/models/bus_model.dart';
import 'package:jnu_bus_routes/features/bus_routes/data/models/place_model.dart';

class BusRepository {
  final AppDatabase _dbHelper;

  BusRepository(this._dbHelper);

  Future<List<BusModel>> getAllBuses() async {
    final db = await _dbHelper.database;
    final maps = await db.query('bus', orderBy: 'id ASC');
    return maps.map((m) => BusModel.fromMap(m)).toList();
  }

  Future<BusModel?> getBusById(int busId) async {
    final db = await _dbHelper.database;
    final maps = await db.query('bus', where: 'id = ?', whereArgs: [busId], limit: 1);
    if (maps.isNotEmpty) {
      return BusModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<RouteStoppage>> getStoppagesForBus(
    int busId,
    RouteDirection direction,
  ) async {
    final db = await _dbHelper.database;
    final query = '''
      SELECT r.stoppage_no, p.id as place_id, p.place_name, r.up_or_down
      FROM relation r
      JOIN place p ON r.place_id = p.id
      WHERE r.bus_id = ? AND r.up_or_down = ?
      ORDER BY r.stoppage_no ASC
    ''';

    final maps = await db.rawQuery(query, [busId, direction.code]);
    return maps.map((m) {
      final rawDir = m['up_or_down'];
      final dirInt = (rawDir is bool) ? (rawDir ? 1 : 0) : (rawDir as int? ?? 0);

      return RouteStoppage(
        stoppageNo: m['stoppage_no'] as int? ?? 0,
        placeId: m['place_id'] as int? ?? 0,
        placeName: (m['place_name'] as String?)?.trim() ?? '',
        direction: RouteDirection.fromCode(dirInt),
      );
    }).toList();
  }

  Future<List<BusModel>> searchBuses(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return getAllBuses();

    final db = await _dbHelper.database;
    final sql = '''
      SELECT DISTINCT b.*
      FROM bus b
      LEFT JOIN relation r ON b.id = r.bus_id
      LEFT JOIN place p ON r.place_id = p.id
      WHERE b.bus_name LIKE ? OR p.place_name LIKE ? OR b.last_stoppage LIKE ?
      ORDER BY b.id ASC
    ''';

    final searchPattern = '%$trimmed%';
    final maps = await db.rawQuery(sql, [searchPattern, searchPattern, searchPattern]);
    return maps.map((m) => BusModel.fromMap(m)).toList();
  }

  Future<List<PlaceModel>> getAllPlaces() async {
    final db = await _dbHelper.database;
    final maps = await db.query('place', orderBy: 'place_name ASC');
    return maps.map((m) => PlaceModel.fromMap(m)).toList();
  }
}
