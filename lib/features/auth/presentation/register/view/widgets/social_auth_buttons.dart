import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_strings.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  const SocialAuthButtons({
    super.key,
    this.onFacebookTap,
    this.onGoogleTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const OrDivider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(
              onTap: onFacebookTap,
              child: const CustomPaint(
                size: Size(18, 18),
                painter: _FacebookIconPainter(),
              ),
            ),
            const SizedBox(width: 18),
            SocialIconButton(
              onTap: onGoogleTap,
              child: const CustomPaint(
                size: Size(18, 18),
                painter: _GoogleIconPainter(),
              ),
            ),
            const SizedBox(width: 18),
            SocialIconButton(
              onTap: onAppleTap,
              child: const Icon(
                Icons.apple,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 80,
          child: Divider(
            color: AppColors.borderSubtle,
            thickness: 1,
            height: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              color: AppColors.borderSubtle,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          width: 80,
          child: Divider(
            color: AppColors.borderSubtle,
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const SocialIconButton({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Ink(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E), // solid dark grey background
          shape: BoxShape.circle, // perfectly circular
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _FacebookIconPainter extends CustomPainter {
  const _FacebookIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.65, h * 0.15);
    path.cubicTo(w * 0.55, h * 0.15, w * 0.48, h * 0.22, w * 0.48, h * 0.35);
    path.lineTo(w * 0.48, h * 0.45);
    path.lineTo(w * 0.35, h * 0.45);
    path.lineTo(w * 0.35, h * 0.58);
    path.lineTo(w * 0.48, h * 0.58);
    path.lineTo(w * 0.48, h * 0.90);
    path.lineTo(w * 0.62, h * 0.90);
    path.lineTo(w * 0.62, h * 0.58);
    path.lineTo(w * 0.75, h * 0.58);
    path.lineTo(w * 0.77, h * 0.45);
    path.lineTo(w * 0.62, h * 0.45);
    path.lineTo(w * 0.62, h * 0.37);
    path.cubicTo(w * 0.62, h * 0.32, w * 0.64, h * 0.28, w * 0.72, h * 0.28);
    path.lineTo(w * 0.78, h * 0.28);
    path.lineTo(w * 0.78, h * 0.15);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoogleIconPainter extends CustomPainter {
  const _GoogleIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, 0.4, 5.2, false, paint);

    final barPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final barRect = Rect.fromCenter(
      center: Offset(center.dx + radius * 0.35, center.dy),
      width: radius * 0.85,
      height: 2.0,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
