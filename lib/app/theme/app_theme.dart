import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static const _faFont = 'Vazirmatn';
  static const _enFont = 'SpaceGrotesk';
  static const _monoFont = 'JetBrainsMono';

  static ThemeData light({required bool isFa}) =>
      _build(PortfolioColors.light, Brightness.light, isFa);

  static ThemeData dark({required bool isFa}) =>
      _build(PortfolioColors.dark, Brightness.dark, isFa);

  static ThemeData _build(
    PortfolioColors colors,
    Brightness brightness,
    bool isFa,
  ) {
    final fontFamily = isFa ? _faFont : _enFont;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      fontFamilyFallback: const [_faFont, _enFont],
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accent,
        onPrimary: brightness == Brightness.dark
            ? const Color(0xFF1B2C2E)
            : Colors.white,
        secondary: colors.accentStrong,
        onSecondary: const Color(0xFF17383B),
        error: colors.danger,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.text,
        surfaceContainerHighest: colors.card,
        onSurfaceVariant: colors.muted,
        outline: colors.border,
        outlineVariant: colors.gridLine,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: colors.text,
        onInverseSurface: colors.background,
        inversePrimary: colors.accentStrong,
      ),
      extensions: [colors],
    );

    final textTheme = base.textTheme
        .apply(
          fontFamily: fontFamily,
          bodyColor: colors.text,
          displayColor: colors.text,
        )
        .copyWith(
          displayLarge: base.textTheme.displayLarge?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            letterSpacing: isFa ? 0 : -2.5,
            height: 1.05,
            color: colors.text,
          ),
          displayMedium: base.textTheme.displayMedium?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            letterSpacing: isFa ? 0 : -1.8,
            height: 1.1,
            color: colors.text,
          ),
          displaySmall: base.textTheme.displaySmall?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            letterSpacing: isFa ? 0 : -1.2,
            height: 1.15,
            color: colors.text,
          ),
          headlineMedium: base.textTheme.headlineMedium?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: colors.text,
          ),
          headlineSmall: base.textTheme.headlineSmall?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            height: 1.3,
            color: colors.text,
          ),
          titleLarge: base.textTheme.titleLarge?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            height: 1.35,
            color: colors.text,
          ),
          titleMedium: base.textTheme.titleMedium?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: colors.text,
          ),
          bodyLarge: base.textTheme.bodyLarge?.copyWith(
            fontFamily: fontFamily,
            height: 1.75,
            color: colors.text,
          ),
          bodyMedium: base.textTheme.bodyMedium?.copyWith(
            fontFamily: fontFamily,
            height: 1.7,
            color: colors.text,
          ),
          labelLarge: base.textTheme.labelLarge?.copyWith(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w600,
            letterSpacing: isFa ? 0 : 0.2,
          ),
        );

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.border),
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      dividerColor: colors.border,
      iconTheme: IconThemeData(color: colors.text, size: 22),
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: colors.border.withValues(alpha: 0.55)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: colors.surfaceAlt,
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.muted),
        labelStyle: textTheme.bodyMedium?.copyWith(color: colors.muted),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: colors.accent,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.accent, width: 1.6),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.danger),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.danger, width: 1.6),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colors.danger),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: brightness == Brightness.dark
              ? const Color(0xFF152426)
              : Colors.white,
          minimumSize: const Size(48, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.text,
          minimumSize: const Size(48, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accent,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(44, 44),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceAlt,
        selectedColor: colors.accent.withValues(alpha: 0.22),
        disabledColor: colors.surfaceAlt,
        labelStyle: textTheme.bodySmall?.copyWith(color: colors.text),
        secondaryLabelStyle: textTheme.bodySmall?.copyWith(color: colors.text),
        side: BorderSide(color: colors.border.withValues(alpha: 0.7)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        showCheckmark: false,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.text,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.background,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.text,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: colors.background),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          colors.accent.withValues(alpha: 0.45),
        ),
        radius: const Radius.circular(8),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextStyle mono({Color? color, double? size, FontWeight? weight}) {
    return TextStyle(
      fontFamily: _monoFont,
      fontSize: size ?? 13,
      height: 1.6,
      color: color,
      fontWeight: weight,
      letterSpacing: 0,
    );
  }
}
