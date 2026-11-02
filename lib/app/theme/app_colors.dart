import 'package:flutter/material.dart';

/// Central colour tokens for the whole portfolio.
///
/// Light and dark palettes are based on the brand colours supplied in the
/// project brief. Additional tokens (muted, border, success...) are derived
/// carefully to keep readable contrast in both themes.
@immutable
class PortfolioColors extends ThemeExtension<PortfolioColors> {
  const PortfolioColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.card,
    required this.accent,
    required this.accentStrong,
    required this.text,
    required this.muted,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.gridLine,
    required this.codeBackground,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color card;
  final Color accent;
  final Color accentStrong;
  final Color text;
  final Color muted;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;
  final Color gridLine;
  final Color codeBackground;

  static const light = PortfolioColors(
    background: Color(0xFFE3FDFD),
    surface: Color(0xFFCBF1F5),
    surfaceAlt: Color(0xFFDDF7F9),
    card: Color(0xFFA6E3E9),
    accent: Color(0xFF3E8E93),
    accentStrong: Color(0xFF71C9CE),
    text: Color(0xFF17383B),
    muted: Color(0xFF4B6E72),
    border: Color(0xFF9AD9DE),
    success: Color(0xFF2E7D63),
    warning: Color(0xFF9A6B12),
    danger: Color(0xFFB3413E),
    gridLine: Color(0x1A3E8E93),
    codeBackground: Color(0xFFF4FEFE),
  );

  static const dark = PortfolioColors(
    background: Color(0xFF2C3333),
    surface: Color(0xFF395B64),
    surfaceAlt: Color(0xFF324A52),
    card: Color(0xFF416B76),
    accent: Color(0xFFA5C9CA),
    accentStrong: Color(0xFF71C9CE),
    text: Color(0xFFE7F6F2),
    muted: Color(0xFFA9C2C4),
    border: Color(0xFF527E88),
    success: Color(0xFF7BD8B4),
    warning: Color(0xFFF2C86B),
    danger: Color(0xFFF08C88),
    gridLine: Color(0x1FA5C9CA),
    codeBackground: Color(0xFF24302F),
  );

  @override
  PortfolioColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? card,
    Color? accent,
    Color? accentStrong,
    Color? text,
    Color? muted,
    Color? border,
    Color? success,
    Color? warning,
    Color? danger,
    Color? gridLine,
    Color? codeBackground,
  }) {
    return PortfolioColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      card: card ?? this.card,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      gridLine: gridLine ?? this.gridLine,
      codeBackground: codeBackground ?? this.codeBackground,
    );
  }

  @override
  PortfolioColors lerp(ThemeExtension<PortfolioColors>? other, double t) {
    if (other is! PortfolioColors) return this;
    return PortfolioColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      card: Color.lerp(card, other.card, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentStrong: Color.lerp(accentStrong, other.accentStrong, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      gridLine: Color.lerp(gridLine, other.gridLine, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
    );
  }
}

extension PortfolioColorsContext on BuildContext {
  PortfolioColors get colors =>
      Theme.of(this).extension<PortfolioColors>() ?? PortfolioColors.dark;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
