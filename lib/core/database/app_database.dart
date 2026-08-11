import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/db_constants.dart';

class AppDatabase {
  static AppDatabase? _instance;
  static Database? _database;

  AppDatabase._internal();

  factory AppDatabase() {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, DbConstants.dbName);

    final exists = await File(dbPath).exists();
    if (!exists) {
      // Copy from asset to application documents directory
      try {
        await Directory(dirname(dbPath)).create(recursive: true);
        final data = await rootBundle.load(DbConstants.assetDbPath);
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes, flush: true);
      } catch (e) {
        throw Exception('Failed to copy database asset: $e');
      }
    }

    return await openDatabase(dbPath, readOnly: true);
  }
}
