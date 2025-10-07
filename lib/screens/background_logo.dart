import 'package:flutter/material.dart';

class BackgroundLogo extends StatelessWidget {
  final Widget child;

  const BackgroundLogo({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background base color
        Container(
          color: isDark ? Colors.black : Colors.grey[100],
        ),

        // Fullscreen background logo (cover entire screen)
        Positioned.fill(
          child: Opacity(
            opacity: 0.06,
            child: Image.asset(
              'assets/images/logo.jpg',
              fit: BoxFit.cover,
              color: isDark ? Colors.white : null,
              colorBlendMode: isDark ? BlendMode.modulate : null,
            ),
          ),
        ),

        // Foreground content
        child,
      ],
    );
  }
}
