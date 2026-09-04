import 'package:flutter/material.dart';

abstract final class AppColors {
  static const black = Color(0xFF0A0A0B);
  static const blackSoft = Color(0xFF171719);
  static const red = Color(0xFFDF1717);
  static const redDark = Color(0xFFA90000);
  static const redSoft = Color(0xFFFFF0F0);
  static const white = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF4F4F5);
  static const line = Color(0xFFE7E7E9);
  static const muted = Color(0xFF77777E);
  static const text = Color(0xFF18181B);
}

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class AppRadii {
  static const small = 10.0;
  static const medium = 14.0;
  static const large = 20.0;
  static const hero = 28.0;
}

abstract final class AppMotion {
  static const micro = Duration(milliseconds: 140);
  static const standard = Duration(milliseconds: 240);
  static const emphasized = Duration(milliseconds: 360);
  static const curve = Curves.easeOutCubic;

  static Duration duration(BuildContext context, Duration preferred) =>
      MediaQuery.maybeOf(context)?.disableAnimations == true
      ? Duration.zero
      : preferred;
}

abstract final class AppTheme {
  static ThemeData get light => _build(_lightScheme, Brightness.light);
  static ThemeData get dark => _build(_darkScheme, Brightness.dark);

  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.red,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.redSoft,
    onPrimaryContainer: AppColors.redDark,
    secondary: AppColors.black,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.blackSoft,
    onSecondaryContainer: AppColors.white,
    tertiary: Color(0xFF4F4F56),
    onTertiary: AppColors.white,
    tertiaryContainer: Color(0xFFEDEDEF),
    onTertiaryContainer: AppColors.black,
    error: AppColors.redDark,
    onError: AppColors.white,
    errorContainer: AppColors.redSoft,
    onErrorContainer: Color(0xFF710000),
    surface: AppColors.white,
    onSurface: AppColors.text,
    surfaceContainerLowest: AppColors.white,
    surfaceContainerLow: Color(0xFFFAFAFA),
    surfaceContainer: AppColors.canvas,
    surfaceContainerHigh: Color(0xFFEDEDEF),
    surfaceContainerHighest: Color(0xFFE4E4E6),
    onSurfaceVariant: AppColors.muted,
    outline: Color(0xFFB7B7BC),
    outlineVariant: AppColors.line,
    shadow: Color(0x1A0A0A0B),
    scrim: Color(0x99000000),
    inverseSurface: AppColors.blackSoft,
    onInverseSurface: AppColors.white,
    inversePrimary: Color(0xFFFF7777),
  );

  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF4545),
    onPrimary: AppColors.black,
    primaryContainer: Color(0xFF580000),
    onPrimaryContainer: Color(0xFFFFDADA),
    secondary: AppColors.white,
    onSecondary: AppColors.black,
    secondaryContainer: Color(0xFF2A2A2D),
    onSecondaryContainer: AppColors.white,
    tertiary: Color(0xFFB9B9BD),
    onTertiary: AppColors.black,
    tertiaryContainer: Color(0xFF303034),
    onTertiaryContainer: AppColors.white,
    error: Color(0xFFFF6B6B),
    onError: AppColors.black,
    errorContainer: Color(0xFF5A0000),
    onErrorContainer: Color(0xFFFFDADA),
    surface: Color(0xFF101011),
    onSurface: Color(0xFFF4F4F5),
    surfaceContainerLowest: AppColors.black,
    surfaceContainerLow: Color(0xFF141416),
    surfaceContainer: AppColors.blackSoft,
    surfaceContainerHigh: Color(0xFF222225),
    surfaceContainerHighest: Color(0xFF2B2B2F),
    onSurfaceVariant: Color(0xFFB2B2B8),
    outline: Color(0xFF717177),
    outlineVariant: Color(0xFF303034),
    shadow: Colors.black,
    scrim: Color(0xCC000000),
    inverseSurface: Color(0xFFF0F0F1),
    onInverseSurface: AppColors.black,
    inversePrimary: AppColors.redDark,
  );

  static ThemeData _build(ColorScheme colors, Brightness brightness) {
    final base = ThemeData(useMaterial3: true, colorScheme: colors);
    final text = base.textTheme.copyWith(
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.02,
      ),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        height: 1.08,
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.35,
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
      ),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
      labelSmall: base.textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );

    final cardColor = colors.surfaceContainerLowest;
    return base.copyWith(
      brightness: brightness,
      textTheme: text,
      scaffoldBackgroundColor: colors.surfaceContainer,
      canvasColor: colors.surfaceContainer,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.surfaceContainer,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: colors.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.large),
          side: BorderSide(color: colors.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: colors.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: text.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.small),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        hintStyle: TextStyle(
          color: colors.onSurfaceVariant.withValues(alpha: .7),
        ),
        prefixIconColor: colors.onSurfaceVariant,
        suffixIconColor: colors.onSurfaceVariant,
        border: _inputBorder(colors.outlineVariant),
        enabledBorder: _inputBorder(colors.outlineVariant),
        focusedBorder: _inputBorder(colors.primary, width: 1.6),
        errorBorder: _inputBorder(colors.error),
        focusedErrorBorder: _inputBorder(colors.error, width: 1.6),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.primaryContainer,
        selectedColor: colors.primary,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: text.labelSmall?.copyWith(color: colors.onPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.black,
        indicatorColor: AppColors.red,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.white
                : const Color(0xFF99999F),
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.white
                : const Color(0xFF99999F),
            fontSize: 10,
            letterSpacing: 0,
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colors.onSurface,
        unselectedLabelColor: colors.onSurfaceVariant,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: colors.outlineVariant,
        labelStyle: text.labelLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.blackSoft,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.medium),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.hero),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.large),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.outlineVariant, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primary),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: WellsPageTransitionsBuilder(),
          TargetPlatform.iOS: WellsPageTransitionsBuilder(),
          TargetPlatform.windows: WellsPageTransitionsBuilder(),
          TargetPlatform.macOS: WellsPageTransitionsBuilder(),
          TargetPlatform.linux: WellsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        borderSide: BorderSide(color: color, width: width),
      );
}

class WellsPageTransitionsBuilder extends PageTransitionsBuilder {
  const WellsPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) return child;
    final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(.045, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
