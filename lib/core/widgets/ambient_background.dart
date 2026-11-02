import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../utils/responsive.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.background,
                Color.lerp(colors.background, colors.surfaceAlt, 0.45)!,
                colors.background,
              ],
              stops: const [0, 0.45, 1],
            ),
          ),
        ),
        Positioned(
          top: -160,
          right: -110,
          child: IgnorePointer(
            child: _Glow(
              size: context.isMobile ? 280 : 460,
              color: colors.accent.withValues(alpha: 0.1),
            ),
          ),
        ),
        Positioned(
          bottom: -180,
          left: -130,
          child: IgnorePointer(
            child: _Glow(
              size: context.isMobile ? 300 : 520,
              color: colors.accentStrong.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(painter: _GridPainter(color: colors.gridLine)),
            ),
          ),
        ),
        if (!context.isMobile)
          Positioned(
            top: 150,
            left: 24,
            child: IgnorePointer(
              child: Text(
                '{ }',
                style: AppTheme.mono(
                  color: colors.accent.withValues(alpha: 0.13),
                  size: 42,
                ),
              ),
            ),
          ),
        if (!context.isMobile)
          Positioned(
            top: 320,
            right: 36,
            child: IgnorePointer(
              child: Text(
                '</>',
                style: AppTheme.mono(
                  color: colors.accentStrong.withValues(alpha: 0.12),
                  size: 34,
                ),
              ),
            ),
          ),
        if (!context.isTablet)
          Positioned(
            bottom: 160,
            right: 44,
            child: IgnorePointer(
              child: Text(
                '01',
                style: AppTheme.mono(
                  color: colors.accent.withValues(alpha: 0.1),
                  size: 30,
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 64.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.color != color;
}
