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

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the directory for storing the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jnu.db");

    // Check if the database already exists
    bool dbExists = await databaseExists(path);

    if (!dbExists) {
      // Copy the pre-populated database from assets
      ByteData data = await rootBundle.load("assets/database/jnu.db");
      List<int> bytes = data.buffer.asUint8List();

      // Write the database file to the app's document directory
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open the database
    return await openDatabase(path, version: 1);
  }

  // Function to fetch all bus names
  Future<List<String>> getBusList() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'bus', // Table name
      columns: ['bus_name'], // Only fetch the bus_name column
      orderBy: 'bus_name ASC',
    );

    // Extract bus names from the result
    return List.generate(result.length, (index) => result[index]['bus_name'] as String);
  }



  Future<List<Map<String, dynamic>>> getAllBusInfo() async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> result = await db.query(
        'bus', // Table name
        orderBy: 'bus_name ASC', // Sort by bus_name in ascending order
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
      print('Error fetching place names: $e');
      rethrow;
    }
  }

}