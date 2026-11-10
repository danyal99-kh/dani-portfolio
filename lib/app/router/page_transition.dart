import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PageMotion { standard, caseStudy }

CustomTransitionPage<void> buildPortfolioPage({
  required GoRouterState state,
  required Widget child,
  PageMotion motion = PageMotion.standard,
}) {
  final caseStudy = motion == PageMotion.caseStudy;
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    // ورود کندتر، خروج خیلی سریع
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 140),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
      final isRtl = Directionality.of(context) == TextDirection.rtl;

      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final t = animation.value;
          final exiting = animation.status == AnimationStatus.reverse;

          double opacity;
          Offset shift = Offset.zero;

          if (exiting) {
            // صفحه قبلی: در نیمه اول زمان خروج کامل محو می‌شود، بدون حرکت
            opacity = ((t - 0.45) / 0.55).clamp(0.0, 1.0);
          } else {
            // صفحه جدید: کمی صبر می‌کند تا صفحه قبل محو شود
            final p = const Interval(
              0.3,
              1.0,
              curve: Curves.easeOutCubic,
            ).transform(t);
            opacity = p;
            final dist = (1 - p) * 18;
            shift = caseStudy
                ? Offset(isRtl ? -dist : dist, 0)
                : Offset(0, dist);
          }

          return IgnorePointer(
            ignoring: exiting || t < 0.6,
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(offset: shift, child: child),
            ),
          );
        },
      );
    },
  );
}
