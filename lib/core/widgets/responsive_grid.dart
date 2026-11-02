import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 280,
    this.maxColumns = 3,
    this.spacing = 20,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final rawColumns = ((available + spacing) / (minItemWidth + spacing))
            .floor();
        final columns = rawColumns.clamp(1, maxColumns);
        final itemWidth = (available - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
