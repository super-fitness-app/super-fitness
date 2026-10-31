import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoThumbnail extends StatelessWidget {
  final String videoUrl;
  final VoidCallback? onTap;

  const VideoThumbnail({super.key, required this.videoUrl, this.onTap});

  String? get thumbnailUrl {
    final uri = Uri.tryParse(videoUrl);
    if (uri == null) return null;

    String? videoId;

    if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    } else if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'];

      if (videoId == null && uri.pathSegments.length >= 2) {
        if (uri.pathSegments.first == 'embed' ||
            uri.pathSegments.first == 'shorts') {
          videoId = uri.pathSegments[1];
        }
      }
    }

    if (videoId == null || videoId.isEmpty) return null;

    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = thumbnailUrl;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (thumbnail != null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, _, _) => const Icon(Icons.broken_image),
                ),
              )
            else
              const Center(child: Icon(Icons.video_library)),
          ],
        ),
      ),
    );
  }
}
