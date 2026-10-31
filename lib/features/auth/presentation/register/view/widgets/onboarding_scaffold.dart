import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'onboarding_header.dart';
import 'onboarding_top_bar.dart';

class OnboardingScaffold extends StatefulWidget {
  final String stepImage;
  final String title;
  final String? subtitle;
  final Widget content;
  final Widget bottomButton;
  final VoidCallback? onBackTap;

  const OnboardingScaffold({
    super.key,
    required this.stepImage,
    required this.title,
    this.subtitle,
    required this.content,
    required this.bottomButton,
    this.onBackTap,
  });

  @override
  State<OnboardingScaffold> createState() => _OnboardingScaffoldState();
}

class _OnboardingScaffoldState extends State<OnboardingScaffold> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(AppImages.authBackground), context);
    precacheImage(AssetImage(widget.stepImage), context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topGap = (screenHeight * 0.08).clamp(32.0, 72.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RepaintBoundary(
            child: Image(
              image: AssetImage(AppImages.authBackground),
              fit: BoxFit.cover,
            ),
          ),
          Container(color: AppColors.onboardingOverlay),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OnboardingTopBar(onBackTap: widget.onBackTap),
                    SizedBox(height: topGap),
                    OnboardingHeader(
                      stepImage: widget.stepImage,
                      title: widget.title,
                      subtitle: widget.subtitle,
                    ),
                    const SizedBox(height: 20),
                    _BlurredContentCard(
                      content: widget.content,
                      bottomButton: widget.bottomButton,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurredContentCard extends StatelessWidget {
  final Widget content;
  final Widget bottomButton;

  const _BlurredContentCard({
    required this.content,
    required this.bottomButton,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: AppColors.onboardingCard,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              content,
              const SizedBox(height: 20),
              bottomButton,
            ],
          ),
        ),
      ),
    );
  }
}
