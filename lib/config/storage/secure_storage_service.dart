import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/storage/storage_service.dart';

@LazySingleton(as: StorageService)
class SecureStorageService implements StorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService(this._secureStorage);

  @override
  Future<void> save(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<String> get(String key) async {
    return await _secureStorage.read(key: key) ?? '';
  }
}
