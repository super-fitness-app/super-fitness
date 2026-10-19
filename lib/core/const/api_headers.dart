abstract final class ApiHeaders {
  // Header keys
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';

  // Auth schemes & prefixes
  static const String bearer = 'Bearer';
  static const String bearerPrefix = 'Bearer ';

  // Content types
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
}
