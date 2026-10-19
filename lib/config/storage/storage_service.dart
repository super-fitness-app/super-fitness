abstract interface class StorageService {
  Future<void> save(String key, String value);
  Future<void> delete(String key);
  Future<String> get(String key);
}
