import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/utils/video_player/app_video_player.dart';

void main() {
  group('AppVideoPlayer Widget Tests', () {
    testWidgets('renders error message when URL is invalid', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppVideoPlayer(
            videoUrl: 'https://invalid-url.com/video',
            title: 'Sample Video',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Sample Video'), findsOneWidget);
      expect(find.text('Invalid YouTube URL'), findsOneWidget);
    });

    testWidgets('renders title in AppBar when video URL is valid',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppVideoPlayer(
            videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
            title: 'Exercise Video',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Exercise Video'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
