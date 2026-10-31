import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ExerciseVideoPlayer({super.key, required this.videoUrl});

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  YoutubePlayerController? _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    final videoId = extractYoutubeVideoId(widget.videoUrl);

    if (videoId == null || videoId.isEmpty) {
      _errorMessage = 'Invalid YouTube URL';
      return;
    }

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Video')),
      body: Center(
        child: controller == null
            ? Text(_errorMessage ?? 'Unable to load video')
            : YoutubePlayer(controller: controller, aspectRatio: 16 / 9),
      ),
    );
  }
}

String? extractYoutubeVideoId(String url) {
  final uri = Uri.tryParse(url.trim());

  if (uri == null) return null;

  if (uri.host == 'youtu.be' || uri.host == 'www.youtu.be') {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }

  if (uri.host == 'youtube.com' ||
      uri.host == 'www.youtube.com' ||
      uri.host == 'm.youtube.com') {
    if (uri.path == '/watch') {
      return uri.queryParameters['v'];
    }

    if (uri.pathSegments.length > 1 &&
        ['embed', 'shorts', 'live'].contains(uri.pathSegments.first)) {
      return uri.pathSegments[1];
    }
  }

  return null;
}
