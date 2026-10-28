import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract final class PasswordGenerator {
  static const String _secretKey = 'SuperFitnessSecretKey2026#';
  static const String _prefix = 'SuperFit@2026#';

  /// Generates a deterministic password from user ID + secret key.
  /// Result: "SuperFit@2026#" + 10 alphanumeric characters from SHA-256 + Base64.
  static String generate(String userId) {
    final bytes = utf8.encode('$userId$_secretKey');
    final digest = sha256.convert(bytes);
    final base64String = base64Url
        .encode(digest.bytes)
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final hash10 = base64String.length >= 10
        ? base64String.substring(0, 10)
        : base64String.padRight(10, '0');
    return '$_prefix$hash10';
  }
}

