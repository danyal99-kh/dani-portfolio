import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/localization/app_localizations.dart';
import '../../app/theme/app_colors.dart';
import '../utils/responsive.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    super.key,
    required this.imageAsset,
    this.size = 320,
    this.borderRadius = 36,
  });

  final String imageAsset;
  final double size;
  final double borderRadius;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // اگر کاربر reduce motion را روشن کرده، حلقه ثابت می‌ماند.
    if (context.reduceMotion) {
      _spin.stop();
    } else if (!_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final outerRadius = BorderRadius.circular(widget.borderRadius + 8);

    final photo = Padding(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius + 4),
        child: Image.asset(
          widget.imageAsset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) {
            return _AvatarFallback(colors: colors);
          },
        ),
      ),
    );

    return Semantics(
      image: true,
      label: l10n.t('a11y.profileImage'),
      child: RepaintBoundary(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _spin,
                  child: photo,
                  builder: (context, child) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: outerRadius,
                        gradient: SweepGradient(
                          // اولین و آخرین رنگ یکی‌اند تا درز دیده نشود
                          colors: [
                            colors.accent,
                            colors.accentStrong,
                            colors.border.withValues(alpha: 0.25),
                            colors.accentStrong,
                            colors.accent,
                          ],
                          stops: const [0.0, 0.3, 0.55, 0.8, 1.0],
                          transform: GradientRotation(
                            _spin.value * 2 * math.pi,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.accent.withValues(alpha: 0.16),
                            blurRadius: 30,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.colors});

  final PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surfaceAlt,
      alignment: Alignment.center,
      child: Icon(Icons.person_outline_rounded, size: 88, color: colors.muted),
    );
  }
}
