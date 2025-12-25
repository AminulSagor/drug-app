import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final Color? overlayColor;
  final double overlayOpacity;

  const AuthBackground({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.overlayColor,
    this.overlayOpacity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(assetPath, fit: fit),
          if (overlayColor != null && overlayOpacity > 0)
            Container(color: overlayColor!.withOpacity(overlayOpacity)),
        ],
      ),
    );
  }
}
