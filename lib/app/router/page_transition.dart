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
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 140),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
      final isRtl = Directionality.of(context) == TextDirection.rtl;

      return AnimatedBuilder(
        // هر دو انیمیشن را گوش می‌دهیم
        animation: Listenable.merge([animation, secondaryAnimation]),
        child: child,
        builder: (context, child) {
          final t = animation.value;
          final covered =
              secondaryAnimation.value; // وقتی صفحه جدید روی این می‌آید
          final leaving = animation.status == AnimationStatus.reverse;
          final outgoing = leaving || covered > 0;

          double opacity;
          Offset shift = Offset.zero;

          if (leaving) {
            // خروج با pop: محو سریع
            opacity = ((t - 0.45) / 0.55).clamp(0.0, 1.0);
          } else if (covered > 0) {
            // صفحه قبل وقتی صفحه جدید آمد: در ۳۰٪ اول محو می‌شود
            final p = const Interval(
              0.0,
              0.3,
              curve: Curves.easeOut,
            ).transform(covered);
            opacity = 1 - p;
          } else {
            // صفحه جدید: بعد از محو شدن صفحه قبل شروع می‌شود
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
            ignoring: outgoing || t < 0.6,
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: shift,
                // صفحه خروجی از چیدمان کنار می‌رود تا ارتفاع/فوتر را خراب نکند.
                // Align همیشه در درخت هست تا state صفحه از بین نرود.
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: outgoing ? 0 : null,
                  child: child,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
