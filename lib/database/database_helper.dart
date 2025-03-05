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



//get place list....
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
          place.place_name ASC;
    ''';
      final List<Map<String, dynamic>> result = await db.rawQuery(query);
      return List.generate(result.length, (index) => result[index]['place_name'] as String);
    } catch (e) {
      rethrow;
    }
  }

  //get bus list on specific place....
  Future<List<Map<String,dynamic>>> getPlaceDetails({
    required String? placeName,
}) async {
    try {
      final db = await database;
      const placeDetailsQuery = '''
      SELECT 
          bus.bus_name,
          bus_type, 
          last_stoppage, 
          up_time, 
          down_time
      FROM 
          relation
      JOIN 
          bus ON relation.bus_id = bus.id
      JOIN 
          place ON relation.place_id = place.id
      WHERE 
          place.place_name = ? AND relation.up_or_down = 1;
    ''';
      final List<Map<String, dynamic>> result = await db.rawQuery(placeDetailsQuery);
      return result;

    } catch (e) {
      rethrow;
    }
  }




//get filtered place list....
  Future<List<String>> getFilteredPlaceList(String filterLetter) async {
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

      final List<Map<String, dynamic>> result = await db.rawQuery(query, ['$filterLetter%']);
      return result.map((row) => row['place_name'] as String).toList();
    } catch (e) {
      rethrow;
    }
  }





  Future<List<Map<String, dynamic>>> getBusInfo({
    String? placeName,
    String? busName,
    int? busType
}) async {
    try {
      final db = await database;


      const busListQuery = '''
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
      const busForASinglePlace = '''
      SELECT 
          bus.bus_name,
          bus.bus_type,
          bus.last_stoppage,
          bus.up_time,
          bus.down_time
      FROM 
          relation
      JOIN 
          bus ON relation.bus_id = bus.id
      JOIN 
          place ON relation.place_id = place.id
      WHERE 
          place.place_name = ? AND relation.up_or_down = 1;
    ''';


      const busDetails = '''
        SELECT 
            place.place_name,
            place.id
        FROM 
            relation
        JOIN 
            bus ON relation.bus_id = bus.id
        JOIN 
            place ON relation.place_id = place.id
        WHERE 
            bus.bus_name = ? AND relation.up_or_down = ?;
      ''';


      if(placeName != null){
        final List<Map<String, dynamic>> result = await db.rawQuery(busForASinglePlace, [placeName]);
        return result;
      } else {
        if(busName != null){
          final List<Map<String, dynamic>> result = await db.rawQuery(busDetails, [busName, busType]);
          return result;
        } else {
          final List<Map<String, dynamic>> result = await db.rawQuery(busListQuery);
          return result;
        }
      }

    } catch (e) {
      rethrow;
    }
  }





}

