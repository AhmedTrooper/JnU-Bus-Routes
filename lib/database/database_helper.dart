import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jnu.db");
    bool dbExists = await databaseExists(path);
    if (!dbExists) {
      ByteData data = await rootBundle.load("assets/database/jnu.db");
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 1);
  }

  // Future<List<String>> getBusList() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> result = await db.query(
  //     'bus',
  //     columns: ['bus_name'],
  //     orderBy: 'bus_name ASC',
  //   );
  //   return List.generate(result.length, (index) => result[index]['bus_name'] as String);
  // }


  // Function to fetch all bus information (bus_name, bus_type, last_stoppage, up_time, down_time)
  Future<List<Map<String, dynamic>>> getBusList() async {
    try {
      final db = await database;

      // Query to fetch all bus details
      const query = '''
      SELECT 
          bus_name, 
          bus_type, 
          last_stoppage, 
          up_time, 
          down_time
      FROM 
          bus
      ORDER BY 
          bus_name ASC;
    ''';

      final List<Map<String, dynamic>> result = await db.rawQuery(query);
      return result;
    } catch (e) {
      rethrow;
    }
  }



  Future<List<Map<String, dynamic>>> getAllBusInfo() async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> result = await db.query(
        'bus',
        orderBy: 'bus_name ASC',
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Fetch detailed route information for a specific bus
  Future<dynamic> getBusRouteDetails(String busName, int upOrDown) async {
    try {
      final db = await database;
      const query = '''
        SELECT 
            place.place_name,
        FROM 
            relation
        JOIN 
            bus ON relation.bus_id = bus.id
        JOIN 
            place ON relation.place_id = place.id
        WHERE 
            bus.bus_name = ? AND relation.up_or_down = ?;
      ''';
      final result = await db.rawQuery(query, [busName, upOrDown]);
      return result;
    } catch (e) {
      rethrow;
    }
  }


  Future<List<String>> getPlaceNamesForBus(String busName, int upOrDown) async {
    try {
      final db = await database;
      const query = '''
      SELECT 
          place.place_name
      FROM 
          relation
      JOIN 
          bus ON relation.bus_id = bus.id
      JOIN 
          place ON relation.place_id = place.id
      WHERE 
          bus.bus_name = ? AND relation.up_or_down = ?;
    ''';
      final List<Map<String, dynamic>> result = await db.rawQuery(query, [busName, upOrDown]);
      return List.generate(result.length, (index) => result[index]['place_name'] as String);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getBusNamesForPlace(String placeName) async {
    try {
      final db = await database;
      const query = '''
      SELECT 
          bus.bus_name
      FROM 
          relation
      JOIN 
          bus ON relation.bus_id = bus.id
      JOIN 
          place ON relation.place_id = place.id
      WHERE 
          place.place_name = ? AND relation.up_or_down = 1;
    ''';
      final List<Map<String, dynamic>> result = await db.rawQuery(query, [placeName]);
      return List.generate(result.length, (index) => result[index]['bus_name'] as String);
    } catch (e) {
      rethrow;
    }
  }








  Future<List<String>> getPlaceList() async {
    try {
      final db = await database;
      const query = '''
      SELECT DISTINCT 
          place.place_name
      FROM 
          relation
      JOIN 
          place ON relation.place_id = place.id
      WHERE 
          relation.up_or_down = 1
      ORDER BY 
          place.place_name ASC; -- Sort in ascending order
    ''';
      final List<Map<String, dynamic>> result = await db.rawQuery(query);
      return List.generate(result.length, (index) => result[index]['place_name'] as String);
    } catch (e) {
      rethrow;
    }
  }

}