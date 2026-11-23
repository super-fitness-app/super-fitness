class YoutubeVideoUtils {
  static String? extractVideoId(String url) {
    final uri = Uri.tryParse(url.trim());

    if (uri == null) return null;

    if (uri.host == 'youtu.be' || uri.host == 'www.youtu.be') {
      return _getValidId(
        uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null,
      );
    }

    if ([
      'youtube.com',
      'www.youtube.com',
      'm.youtube.com',
    ].contains(uri.host)) {
      if (uri.path == '/watch') {
        return _getValidId(uri.queryParameters['v']);
      }

      if (uri.pathSegments.length > 1 &&
          ['embed', 'shorts', 'live'].contains(uri.pathSegments.first)) {
        return _getValidId(uri.pathSegments[1]);
      }
    }

    return null;
  }

  static String? _getValidId(String? id) {
    if (id == null || id.isEmpty) return null;
    return id;
  }

  static String? getThumbnailUrl(String url) {
    final videoId = extractVideoId(url);

    if (videoId == null) return null;

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
