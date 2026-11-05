import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/utils/video_player/youtube_video_utils.dart';

void main() {
  group('YoutubeVideoUtils Tests', () {
    const validVideoId = 'dQw4w9WgXcQ';

    test('extracts videoId from standard watch URL', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://www.youtube.com/watch?v=$validVideoId',
      );
      expect(id, validVideoId);
    });

    test('extracts videoId from watch URL with extra query parameters', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://www.youtube.com/watch?v=$validVideoId&t=42s&feature=shared',
      );
      expect(id, validVideoId);
    });

    test('extracts videoId from shortened youtu.be URL', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://youtu.be/$validVideoId',
      );
      expect(id, validVideoId);
    });

    test('extracts videoId from shorts URL', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://www.youtube.com/shorts/$validVideoId',
      );
      expect(id, validVideoId);
    });

    test('extracts videoId from embed URL', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://www.youtube.com/embed/$validVideoId',
      );
      expect(id, validVideoId);
    });

    test('extracts videoId from live URL', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://www.youtube.com/live/$validVideoId',
      );
      expect(id, validVideoId);
    });

    test('extracts videoId from m.youtube.com watch URL', () {
      final id = YoutubeVideoUtils.extractVideoId(
        'https://m.youtube.com/watch?v=$validVideoId',
      );
      expect(id, validVideoId);
    });

    test('returns null for empty or whitespace URL', () {
      expect(YoutubeVideoUtils.extractVideoId(''), isNull);
      expect(YoutubeVideoUtils.extractVideoId('   '), isNull);
    });

    test('returns null for non-youtube domains', () {
      expect(YoutubeVideoUtils.extractVideoId('https://vimeo.com/12345'), isNull);
      expect(YoutubeVideoUtils.extractVideoId('https://google.com'), isNull);
    });

    test('returns null for malformed or unknown youtube paths', () {
      expect(YoutubeVideoUtils.extractVideoId('https://www.youtube.com/feed'), isNull);
      expect(YoutubeVideoUtils.extractVideoId('invalid-url-string'), isNull);
    });

    test('getThumbnailUrl returns correct thumbnail for valid youtube URL', () {
      final thumb = YoutubeVideoUtils.getThumbnailUrl(
        'https://www.youtube.com/watch?v=$validVideoId',
      );
      expect(thumb, 'https://img.youtube.com/vi/$validVideoId/hqdefault.jpg');
    });

    test('getThumbnailUrl returns null for invalid URL', () {
      final thumb = YoutubeVideoUtils.getThumbnailUrl('https://example.com');
      expect(thumb, isNull);
    });
  });
}
