import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PasswordGenerator {
  final String secretKey;
  final String prefix;

  const PasswordGenerator()
      : secretKey = const String.fromEnvironment('SOCIAL_AUTH_SECRET_KEY'),
        prefix = const String.fromEnvironment(
          'SOCIAL_AUTH_PASSWORD_PREFIX',
          defaultValue: 'SuperFit@2026#',
        );

  /// Constructor for testing or custom configuration.
  const PasswordGenerator.custom({
    required this.secretKey,
    required this.prefix,
  });

  /// Generates a deterministic password from user ID + secret key.
  /// Result: prefix + 10 alphanumeric characters from SHA-256 + Base64.
  String generate(String userId) {
    final bytes = utf8.encode('$userId$secretKey');
    final digest = sha256.convert(bytes);
    final base64String = base64Url
        .encode(digest.bytes)
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final hash10 = base64String.length >= 10
        ? base64String.substring(0, 10)
        : base64String.padRight(10, '0');
    return '$prefix$hash10';
  }
}
