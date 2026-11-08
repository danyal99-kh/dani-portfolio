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
    transitionDuration: Duration(milliseconds: caseStudy ? 300 : 260),
    reverseTransitionDuration: Duration(milliseconds: caseStudy ? 240 : 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
      final curved = animation.drive(CurveTween(curve: Curves.easeOutCubic));
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final begin = caseStudy
          ? Offset(isRtl ? -0.03 : 0.03, 0.012)
          : const Offset(0, 0.022);
      final scale = Tween<double>(
        begin: caseStudy ? 0.982 : 0.994,
        end: 1,
      ).animate(curved);

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: begin,
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(scale: scale, child: child),
        ),
      );
    },
  );
}
