import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'youtube_video_utils.dart';

class AppVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final bool autoPlay;
  final bool showControls;
  final bool showFullscreenButton;
  final bool mute;

  const AppVideoPlayer({
    super.key,
    required this.videoUrl,
    this.title = 'Video Player',
    this.autoPlay = true,
    this.showControls = true,
    this.showFullscreenButton = true,
    this.mute = false,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  YoutubePlayerController? _controller;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = YoutubeVideoUtils.extractVideoId(widget.videoUrl);

    if (videoId == null) {
      _errorMessage = 'Invalid YouTube URL';
      return;
    }

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: widget.autoPlay,
      params: YoutubePlayerParams(
        showControls: widget.showControls,
        showFullscreenButton: widget.showFullscreenButton,
        mute: widget.mute,
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
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: controller == null
            ? Text(_errorMessage ?? 'Unable to load video')
            : YoutubePlayer(controller: controller, aspectRatio: 16 / 9),
      ),
    );
  }
}
