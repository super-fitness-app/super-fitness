import 'dart:io';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

enum FitnessDatabase { meals, exercises }

@lazySingleton
class FitnessDatabaseManager {
  final Map<FitnessDatabase, Database> _databases = {};

  Future<Database> getDatabase(FitnessDatabase database) async {
    // Return the already opened database if it exists.
    final existingDatabase = _databases[database];

    if (existingDatabase != null && existingDatabase.isOpen) {
      return existingDatabase;
    }

    final databaseName = _getDatabaseName(database);

    final databasesPath = await getDatabasesPath();

    final String databasePath = path.join(databasesPath, databaseName);

    // Copy the database from assets to the device
    // if it doesn't already exist.
    await _copyDatabaseFromAssets(
      assetPath: 'assets/databases/$databaseName',
      databasePath: databasePath,
    );

    final Database db = await openDatabase(databasePath);

    _databases[database] = db;

    return db;
  }

  String _getDatabaseName(FitnessDatabase database) {
    return switch (database) {
      FitnessDatabase.meals => 'meals.db',
      FitnessDatabase.exercises => 'exercises.db',
    };
  }

  Future<void> _copyDatabaseFromAssets({
    required String assetPath,
    required String databasePath,
  }) async {
    final databaseFile = File(databasePath);

    if (await databaseFile.exists()) {
      return;
    }

    final databaseData = await rootBundle.load(assetPath);

    final bytes = databaseData.buffer.asUint8List(
      databaseData.offsetInBytes,
      databaseData.lengthInBytes,
    );

    await databaseFile.parent.create(recursive: true);

    await databaseFile.writeAsBytes(bytes, flush: true);
  }

  Future<void> closeDatabase(FitnessDatabase database) async {
    final db = _databases[database];

    if (db != null && db.isOpen) {
      await db.close();
    }

    _databases.remove(database);
  }

  Future<void> closeAll() async {
    for (final db in _databases.values) {
      if (db.isOpen) {
        await db.close();
      }
    }

    _databases.clear();
  }

  Future<bool> databaseExists(FitnessDatabase database) async {
    final databaseName = _getDatabaseName(database);

    final databasesPath = await getDatabasesPath();

    final databasePath = path.join(databasesPath, databaseName);

    return File(databasePath).exists();
  }
}
