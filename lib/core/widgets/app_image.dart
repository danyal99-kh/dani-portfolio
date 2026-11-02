import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.asset,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.borderRadius = 18,
    this.semanticLabel,
  });

  final String asset;
  final BoxFit fit;
  final double? height;
  final double? width;
  final double borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = semanticLabel ?? context.l10n.t('a11y.projectImage');
    return Semantics(
      image: true,
      label: label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          asset,
          fit: fit,
          height: height,
          width: width,
          filterQuality: FilterQuality.medium,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOut,
              child: child,
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              width: width,
              color: colors.surfaceAlt,
              alignment: Alignment.center,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: colors.muted,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }
}
