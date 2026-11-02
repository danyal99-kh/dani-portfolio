import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';

class CodeLine {
  const CodeLine(this.text, {this.color, this.dim = false});

  final String text;
  final Color? color;
  final bool dim;
}

class CodePanel extends StatelessWidget {
  const CodePanel({
    super.key,
    required this.title,
    required this.lines,
    this.showLineNumbers = true,
  });

  final String title;
  final List<CodeLine> lines;
  final bool showLineNumbers;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.codeBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(color: colors.border.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              children: [
                _Dot(color: colors.danger),
                const SizedBox(width: 6),
                _Dot(color: colors.warning),
                const SizedBox(width: 6),
                _Dot(color: colors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.mono(color: colors.muted, size: 11.5),
                  ),
                ),
                Icon(
                  Icons.code_rounded,
                  size: 15,
                  color: colors.muted.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showLineNumbers) ...[
                          SizedBox(
                            width: 22,
                            child: Text(
                              '${i + 1}',
                              textAlign: TextAlign.right,
                              style: AppTheme.mono(
                                color: colors.muted.withValues(alpha: 0.45),
                                size: 11.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                        Text(
                          lines[i].text,
                          style: AppTheme.mono(
                            color:
                                lines[i].color ??
                                (lines[i].dim ? colors.muted : colors.text),
                            size: 12.5,
                            weight: lines[i].dim
                                ? FontWeight.w400
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
