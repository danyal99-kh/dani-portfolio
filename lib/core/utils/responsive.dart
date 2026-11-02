import 'package:flutter/material.dart';

class Breakpoints {
  const Breakpoints._();

  static const double mobile = 700;
  static const double tablet = 1024;
  static const double desktop = 1280;
  static const double maxContentWidth = 1200;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  double get pageHorizontalPadding {
    if (isMobile) return 20;
    if (isTablet) return 32;
    return 48;
  }

  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: pageHorizontalPadding,
    vertical: isMobile ? 28 : 40,
  );

  double get sectionGap => isMobile ? 48 : 72;

  int gridColumns({
    double minItemWidth = 280,
    int maxColumns = 3,
    double spacing = 20,
  }) {
    final available = screenWidth - pageHorizontalPadding * 2;
    final columns = (available / minItemWidth).floor();
    return columns.clamp(1, maxColumns);
  }
}

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding ?? context.pagePadding, child: child),
      ),
    );
  }
}
