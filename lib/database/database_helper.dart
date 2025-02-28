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
    );

    // Extract bus names from the result
    return List.generate(result.length, (index) => result[index]['bus_name'] as String);
  }
}