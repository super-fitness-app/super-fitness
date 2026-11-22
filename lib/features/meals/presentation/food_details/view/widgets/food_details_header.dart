import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/utils/video_player/youtube_video_utils.dart';

class FoodDetailsHeader extends StatelessWidget {
  final String? imageUrl;
  final String? youtubeUrl;
  final String title;

  const FoodDetailsHeader({
    super.key,
    required this.imageUrl,
    required this.youtubeUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _HeaderImage(imageUrl: imageUrl),
          const _GradientOverlay(),
          _HeaderBackButton(onBack: () => context.pop()),
          if (_hasValidVideo(youtubeUrl))
            _PlayVideoButton(
              youtubeUrl: youtubeUrl!,
              title: title,
            ),
        ],
      ),
    );
  }

  bool _hasValidVideo(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    return YoutubeVideoUtils.extractVideoId(url) != null;
  }
}

class _HeaderImage extends StatelessWidget {
  final String? imageUrl;
  const _HeaderImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return Container(color: AppColors.surface);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: AppColors.surface),
      errorWidget: (_, _, _) => Container(color: AppColors.surface),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.35),
            Colors.black.withValues(alpha: 0.70),
            AppColors.background,
          ],
          stops: const [0.0, 0.65, 1.0],
        ),
      ),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  final VoidCallback onBack;
  const _HeaderBackButton({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(
              AppDimensions.headerBackButtonSize / 2,
            ),
            child: Container(
              width: AppDimensions.headerBackButtonSize,
              height: AppDimensions.headerBackButtonSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayVideoButton extends StatelessWidget {
  final String youtubeUrl;
  final String title;

  const _PlayVideoButton({
    required this.youtubeUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.appVideoPlayer,
          extra: {
            'videoUrl': youtubeUrl,
            'title': title,
          },
        ),
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.9),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: AppColors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
