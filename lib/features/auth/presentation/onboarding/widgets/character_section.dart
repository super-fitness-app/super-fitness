import 'package:flutter/material.dart';

class CharacterSection extends StatelessWidget {
  final String imagePath;
  final int index;

  const CharacterSection({
    super.key,
    required this.imagePath,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 50;

    return PositionedDirectional(
      top: topPadding,
      start: 0,
      end: 0,
      bottom: 270,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Image.asset(
          imagePath,
          key: ValueKey<int>(index),
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
