import 'package:injectable/injectable.dart';

@lazySingleton
class FitnessDatabaseManager {
  const FitnessDatabaseManager();

  Future<void> initDatabase() async {}

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    return [];
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    return 0;
  }

  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    return 0;
  }
}
