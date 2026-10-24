import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  final String stepImage;
  final String title;
  final String? subtitle;

  const OnboardingHeader({
    super.key,
    required this.stepImage,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Image.asset(stepImage, height: 46)),
        const SizedBox(height: 18),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              color: Color(0xFFA7A7A7),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
