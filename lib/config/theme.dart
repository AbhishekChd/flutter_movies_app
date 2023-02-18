import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  /// Seed Color: #2196F3
  static const primary = Color(0xFF0061A4);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFD1E4FF);
  static const onPrimaryContainer = Color(0xFF001D36);

  static const secondary = Color(0xFF535F70);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD7E3F7);
  static const onSecondaryContainer = Color(0xFF101C2B);

  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF410002);

  static const background = Color(0xFFFDFCFF);
  static const onBackground = Color(0xFF1A1C1E);
  static const surface = background;
  static const onSurface = onBackground;

  static const outline = Color(0x6673777F);
  static const shadow = Color(0xFF000000);

  static const inverseSurface = Color(0xFFE2E2E6);
  static const onInverseSurface = Color(0xFF2F3033);
  static const inversePrimary = Color(0xFF9ECAFF);
}

abstract class AppColorsDark {
  /// Seed Color: #2196F3
  static const primary = Color(0xFF9ECAFF);
  static const onPrimary = Color(0xFF003258);
  static const primaryContainer = Color(0xFF00497D);
  static const onPrimaryContainer = Color(0xFFD1E4FF);

  static const secondary = Color(0xFFBBC7DB);
  static const onSecondary = Color(0xFF253140);
  static const secondaryContainer = Color(0xFF3B4858);
  static const onSecondaryContainer = Color(0xFFD7E3F7);

  static const error = Color(0xFFFFB4AB);
  static const onError = Color(0xFF690005);
  static const errorContainer = Color(0xFF93000A);
  static const onErrorContainer = Color(0xFFFFB4AB);

  static const background = Color(0xFF1A1C1E);
  static const onBackground = Color(0xFFE2E2E6);
  static const surface = background;
  static const onSurface = onBackground;

  static const outline = Color(0xFF8D9199);
  static const shadow = Color(0xFF000000);

  static const inverseSurface = Color(0xFFE2E2E6);
  static const onInverseSurface = Color(0xFF2F3033);
  static const inversePrimary = Color(0xFF0061A4);
}

abstract class AppTheme {
  static bool isMaterial = true;

  static ThemeData light() => ThemeData(
        useMaterial3: isMaterial,
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
          fontSize: 24,
          color: AppColors.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.ibmPlexMono().fontFamily,
        )),
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          error: AppColors.error,
          onError: AppColors.onError,
          errorContainer: AppColors.errorContainer,
          onErrorContainer: AppColors.onErrorContainer,
          background: AppColors.background,
          onBackground: AppColors.onBackground,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          outline: AppColors.outline,
          shadow: AppColors.shadow,
          inversePrimary: AppColors.inversePrimary,
          onInverseSurface: AppColors.onInverseSurface,
          inverseSurface: AppColors.inverseSurface,
        ),
        dividerTheme: const DividerThemeData(color: AppColors.outline),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: isMaterial,
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
          fontSize: 24,
          color: AppColorsDark.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.ibmPlexMono().fontFamily,
        )),
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColorsDark.primary,
          onPrimary: AppColorsDark.onPrimary,
          primaryContainer: AppColorsDark.primaryContainer,
          onPrimaryContainer: AppColorsDark.onPrimaryContainer,
          secondary: AppColorsDark.secondary,
          onSecondary: AppColorsDark.onSecondary,
          secondaryContainer: AppColorsDark.secondaryContainer,
          onSecondaryContainer: AppColorsDark.onSecondaryContainer,
          error: AppColorsDark.error,
          onError: AppColorsDark.onError,
          errorContainer: AppColorsDark.errorContainer,
          onErrorContainer: AppColorsDark.onErrorContainer,
          background: AppColorsDark.background,
          onBackground: AppColorsDark.onBackground,
          surface: AppColorsDark.surface,
          onSurface: AppColorsDark.onSurface,
          outline: AppColorsDark.outline,
          shadow: AppColorsDark.shadow,
          inversePrimary: AppColorsDark.inversePrimary,
          onInverseSurface: AppColorsDark.onInverseSurface,
          inverseSurface: AppColorsDark.inverseSurface,
        ),
        dividerTheme: const DividerThemeData(color: AppColorsDark.outline),
      );
}

/// [ModelTheme] is a theme modification system for the app which uses [ChangeNotifier] to
/// send change notifications when [ChangeNotifier.notifyListeners] is called
class ModelTheme extends ChangeNotifier {
  final String themeKey = "is_dark";
  final String systemThemeKey = "is_system_default";
  static bool _isDark = true;
  static bool _isSystemDefault = true;

  ThemeMode currentTheme() {
    return _isSystemDefault ? ThemeMode.system : (_isDark ? ThemeMode.dark : ThemeMode.light);
  }

  bool isDark() {
    return _isDark;
  }

  bool isSystemDefault() {
    return _isSystemDefault;
  }

  switchThemeMode() {
    _isDark = !_isDark;
    box.put(themeKey, _isDark);
    notifyListeners();
  }

  switchToSystemMode() {
    _isSystemDefault = !_isSystemDefault;
    box.put(systemThemeKey, _isSystemDefault);
    notifyListeners();
  }

  ModelTheme() {
    _isDark = box.get(themeKey, defaultValue: true);
    _isSystemDefault = box.get(systemThemeKey, defaultValue: true);
  }
}
