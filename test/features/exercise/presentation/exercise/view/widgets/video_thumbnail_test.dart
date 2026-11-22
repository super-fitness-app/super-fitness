import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/video_thumbnail.dart';

void main() {
  group('VideoThumbnail URL Tests', () {
    test('should extract video ID from youtube.com URL', () {
      // Arrange
      const videoUrl = 'https://www.youtube.com/watch?v=ABC123';

      // Act
      const widget = VideoThumbnail(videoUrl: videoUrl);

      // Assert
      expect(
        widget.thumbnailUrl,
        'https://img.youtube.com/vi/ABC123/hqdefault.jpg',
      );
    });

    test('should extract video ID from youtu.be URL', () {
      // Arrange
      const videoUrl = 'https://youtu.be/ABC123';

      // Act
      const widget = VideoThumbnail(videoUrl: videoUrl);

      // Assert
      expect(
        widget.thumbnailUrl,
        'https://img.youtube.com/vi/ABC123/hqdefault.jpg',
      );
    });

    test('should extract video ID from youtube shorts URL', () {
      // Arrange
      const videoUrl = 'https://www.youtube.com/shorts/ABC123';

      // Act
      const widget = VideoThumbnail(videoUrl: videoUrl);

      // Assert
      expect(
        widget.thumbnailUrl,
        'https://img.youtube.com/vi/ABC123/hqdefault.jpg',
      );
    });

    test('should extract video ID from youtube embed URL', () {
      // Arrange
      const videoUrl = 'https://www.youtube.com/embed/ABC123';

      // Act
      const widget = VideoThumbnail(videoUrl: videoUrl);

      // Assert
      expect(
        widget.thumbnailUrl,
        'https://img.youtube.com/vi/ABC123/hqdefault.jpg',
      );
    });

    test('should return null when URL is invalid', () {
      // Arrange
      const widget = VideoThumbnail(videoUrl: 'invalid-url');

      // Assert
      expect(widget.thumbnailUrl, isNull);
    });

    test('should return null when video ID is missing', () {
      // Arrange
      const widget = VideoThumbnail(videoUrl: 'https://www.youtube.com/');

      // Assert
      expect(widget.thumbnailUrl, isNull);
    });
  });
}
