import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';

/// Resolves the intrinsic size of an asset image once and caches it.
class _ImageSizeCache {
  static final Map<String, Size> _sizes = {};
  static final Map<String, Future<Size?>> _pending = {};

  static Size? peek(String asset) => _sizes[asset];

  static Future<Size?> resolve(String asset) {
    final cached = _sizes[asset];
    if (cached != null) return Future.value(cached);
    return _pending.putIfAbsent(asset, () {
      final completer = Completer<Size?>();
      final stream = AssetImage(asset).resolve(ImageConfiguration.empty);
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          final size = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
          _sizes[asset] = size;
          completer.complete(size);
          stream.removeListener(listener);
        },
        onError: (_, __) {
          completer.complete(null);
          stream.removeListener(listener);
        },
      );
      stream.addListener(listener);
      return completer.future;
    });
  }
}

/// Shows an image fully (never cropped), inside a frame that follows the
/// image's own aspect ratio, clamped between [minAspect] and [maxAspect]
/// so very tall / very wide images don't break the layout.
class AdaptiveImage extends StatelessWidget {
  const AdaptiveImage({
    super.key,
    required this.asset,
    this.borderRadius = 18,
    this.minAspect = 0.6,
    this.maxAspect = 2.0,
    this.fallbackAspect = 16 / 10,
    this.maxHeight,
    this.semanticLabel,
  });

  final String asset;
  final double borderRadius;
  final double minAspect; // width / height (lowest = tallest allowed)
  final double maxAspect; // width / height (highest = widest allowed)
  final double fallbackAspect;
  final double? maxHeight;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = semanticLabel ?? context.l10n.t('a11y.projectImage');

    return FutureBuilder<Size?>(
      initialData: _ImageSizeCache.peek(asset),
      future: _ImageSizeCache.resolve(asset),
      builder: (context, snapshot) {
        final size = snapshot.data;
        final aspect = size == null || size.height == 0
            ? fallbackAspect
            : (size.width / size.height).clamp(minAspect, maxAspect);

        Widget frame = AspectRatio(
          aspectRatio: aspect,
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.surfaceAlt),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: colors.muted,
                  size: 32,
                ),
              ),
            ),
          ),
        );

        if (maxHeight != null) {
          frame = ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight!),
            child: Center(child: frame),
          );
        }

        return Semantics(
          image: true,
          label: label,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: frame,
          ),
        );
      },
    );
  }
}
