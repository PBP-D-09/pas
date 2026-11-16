import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _primary = Color(0xFF29A0B7); // --color-primary-60
  static const _onPrimary = Colors.white;
  static const _primaryContainer = Color(0xFFB4E5EE); // --color-primary-20
  static const _onPrimaryContainer = Color(0xFF0C2F36); // --color-primary-100

  static const _secondary = Color(0xFF28B9AE); // --color-secondary-60
  static const _onSecondary = Colors.white;
  static const _secondaryContainer = Color(0xFFB3EFE9); // --color-secondary-20
  static const _onSecondaryContainer = Color(
    0xFF0C3733,
  ); // --color-secondary-100

  static const _tertiary = Color(0xFF538D5B); // --color-tertiary-60
  static const _onTertiary = Colors.white;
  static const _tertiaryContainer = Color(0xFFC5DDC9); // --color-tertiary-20
  static const _onTertiaryContainer = Color(
    0xFF192A1B,
  ); // --color-tertiary-100

  static const _error = Color(0xFFFF383C); // --color-red-70
  static const _onError = Colors.white;
  static const _errorContainer = Color(0xFFFFB3B3); // --color-red-10
  static const _onErrorContainer = Color(0xFF410002);

  static const _surface = Color(0xFFF4F7F2); // --color-surface-canvas
  static const _surfaceVariant = Color(0xFFEDF7F0); // --color-surface-subtle
  static const _onSurface = Color(0xFF333333); // --color-neutral-100
  static const _onSurfaceVariant = Color(0xFF777777); // --color-neutral-70
  static const _outline = Color(0xFFA4A4A4); // --color-neutral-50
  static const _outlineVariant = Color(0xFFDCE6DF); // --color-border-subtle

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: _primary,
      onPrimary: _onPrimary,
      primaryContainer: _primaryContainer,
      onPrimaryContainer: _onPrimaryContainer,
      secondary: _secondary,
      onSecondary: _onSecondary,
      secondaryContainer: _secondaryContainer,
      onSecondaryContainer: _onSecondaryContainer,
      tertiary: _tertiary,
      onTertiary: _onTertiary,
      tertiaryContainer: _tertiaryContainer,
      onTertiaryContainer: _onTertiaryContainer,
      error: _error,
      onError: _onError,
      errorContainer: _errorContainer,
      onErrorContainer: _onErrorContainer,
      surface: _surface,
      onSurface: _onSurface,
      surfaceContainerHighest: _surfaceVariant,
      onSurfaceVariant: _onSurfaceVariant,
      outline: _outline,
      outlineVariant: _outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }
}
