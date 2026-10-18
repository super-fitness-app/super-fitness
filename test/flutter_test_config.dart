import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  final fontLoader = FontLoader('Baloo Thambi 2');
  fontLoader.addFont(Future.value(Uint8List(0).buffer.asByteData()));
  try {
    await fontLoader.load();
  } catch (_) {}

  final completer = Completer<void>();

  runZonedGuarded(
    () async {
      try {
        await testMain();
        completer.complete();
      } catch (error, stack) {
        completer.completeError(error, stack);
      }
    },
    (error, stack) {
      if (!completer.isCompleted) {
        completer.completeError(error, stack);
      }
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        if (line.contains('google_fonts was unable to load font') ||
            line.contains('packages/google_fonts') ||
            line.contains('github.com/flutter/flutter/issues/new/choose') ||
            line.contains('BalooThambi2') ||
            line.contains('Baloo Thambi 2')) {
          return;
        }
        parent.print(zone, line);
      },
    ),
  );

  await completer.future;
}
