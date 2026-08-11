import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jnu_bus_routes/core/utils/app_logger.dart';
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
        appLogger.i('Copying database from assets to: $dbPath');
        await Directory(dirname(dbPath)).create(recursive: true);
        final data = await rootBundle.load(DbConstants.assetDbPath);
        final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes, flush: true);
        appLogger.i('Database copied successfully.');
      } catch (e) {
        appLogger.e('Failed to copy database asset: $e');
        throw Exception('Failed to copy database asset: $e');
      }
    } else {
      appLogger.i('Database already exists at: $dbPath');
    }

    return await openDatabase(dbPath, readOnly: true);
  }
}
