import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton database helper class for managing SQLite database operations
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// Get database instance, initialize if not already done
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database by copying from assets if not exists
  Future<Database> _initDatabase() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "jnu.db");
      final dbExists = await databaseExists(path);

      if (!dbExists) {
        debugPrint('Database not found, copying from assets...');
        final data = await rootBundle.load("assets/database/jnu.db");
        final bytes = data.buffer.asUint8List();
        await File(path).writeAsBytes(bytes, flush: true);
        debugPrint('Database copied successfully');
      }

      return await openDatabase(
        path,
        version: 1,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  /// Get list of all distinct places from database
  Future<List<String>> getPlaceList() async {
    try {
      final db = await database;
      const query = '''
        SELECT DISTINCT place.place_name
        FROM relation
        JOIN place ON relation.place_id = place.id
        WHERE relation.up_or_down = 1
        ORDER BY place.place_name ASC;
      ''';

      final result = await db.rawQuery(query);
      return result.map((row) => row['place_name'] as String).toList();
    } catch (e) {
      debugPrint('Error getting place list: $e');
      return [];
    }
  }

  /// Get bus details for a specific place
  Future<List<Map<String, dynamic>>> getPlaceDetails({
    required String? placeName,
  }) async {
    if (placeName == null || placeName.isEmpty) return [];

    try {
      final db = await database;
      const placeDetailsQuery = '''
        SELECT 
          bus.bus_name,
          bus.bus_type, 
          bus.last_stoppage, 
          bus.up_time, 
          bus.down_time
        FROM relation
        JOIN bus ON relation.bus_id = bus.id
        JOIN place ON relation.place_id = place.id
        WHERE place.place_name = ? AND relation.up_or_down = 1;
      ''';

      final result = await db.rawQuery(placeDetailsQuery, [placeName]);
      return result;
    } catch (e) {
      debugPrint('Error getting place details for $placeName: $e');
      return [];
    }
  }

  /// Get filtered place list based on starting letter
  Future<List<String>> getFilteredPlaceList(String filterLetter) async {
    if (filterLetter.isEmpty) return await getPlaceList();

    try {
      final db = await database;
      const query = '''
        SELECT DISTINCT place.place_name
        FROM relation
        JOIN place ON relation.place_id = place.id
        WHERE relation.up_or_down = 1
        AND LOWER(place.place_name) LIKE ?
        ORDER BY place.place_name ASC;
      ''';

      final result = await db.rawQuery(query, ['${filterLetter.toLowerCase()}%']);
      return result.map((row) => row['place_name'] as String).toList();
    } catch (e) {
      debugPrint('Error getting filtered place list for $filterLetter: $e');
      return [];
    }
  }

  /// Get filtered bus list based on starting letter
  Future<List<Map<String, dynamic>>> getFilteredBusList(String filterLetter) async {
    if (filterLetter.isEmpty) return await getBusInfo();

    try {
      final db = await database;
      const query = '''
        SELECT 
          bus_name, 
          bus_type, 
          last_stoppage, 
          up_time, 
          down_time
        FROM bus
        WHERE LOWER(bus_name) LIKE ?
        ORDER BY bus_name ASC;
      ''';

      final result = await db.rawQuery(query, ['${filterLetter.toLowerCase()}%']);
      return result;
    } catch (e) {
      debugPrint('Error getting filtered bus list for $filterLetter: $e');
      return [];
    }
  }

  /// Get bus information based on different criteria
  /// - If [placeName] is provided: returns buses that stop at that place
  /// - If [busName] and [busType] are provided: returns route details for that bus
  /// - Otherwise: returns all buses
  Future<List<Map<String, dynamic>>> getBusInfo({
    String? placeName,
    String? busName,
    int? busType,
  }) async {
    try {
      final db = await database;

      // Query for all buses
      const busListQuery = '''
        SELECT 
          bus_name, 
          bus_type, 
          last_stoppage, 
          up_time, 
          down_time
        FROM bus
        ORDER BY bus_name ASC;
      ''';

      // Query for buses at a specific place
      const busForASinglePlace = '''
        SELECT 
          bus.bus_name,
          bus.bus_type,
          bus.last_stoppage,
          bus.up_time,
          bus.down_time
        FROM relation
        JOIN bus ON relation.bus_id = bus.id
        JOIN place ON relation.place_id = place.id
        WHERE place.place_name = ? AND relation.up_or_down = 1;
      ''';

      // Query for detailed route of a specific bus
      const busDetails = '''
        SELECT 
          place.place_name,
          place.id
        FROM relation
        JOIN bus ON relation.bus_id = bus.id
        JOIN place ON relation.place_id = place.id
        WHERE bus.bus_name = ? AND relation.up_or_down = ?;
      ''';

      // Execute appropriate query based on parameters
      if (placeName != null && placeName.isNotEmpty) {
        final result = await db.rawQuery(busForASinglePlace, [placeName]);
        return result;
      } else if (busName != null && busName.isNotEmpty && busType != null) {
        final result = await db.rawQuery(busDetails, [busName, busType]);
        return result;
      } else {
        final result = await db.rawQuery(busListQuery);
        return result;
      }
    } catch (e) {
      debugPrint('Error getting bus info: $e');
      return [];
    }
  }

  /// Close database connection
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
