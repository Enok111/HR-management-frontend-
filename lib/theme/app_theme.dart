import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF00E676); // Vibrant Green accent
const Color secondaryColor = Color(0xFF00B0FF); // Electric Blue accent
const Color tertiaryColor = Color(0xFF7C4DFF); // Deep Purple
const Color accentColor = Color(0xFF00E676);
const Color bgColor = Color(0xFF0B1118); // Deep black-blue background
const Color surfaceColor = Color(0xFF161E27); // Card/Surface background
const Color textPrimary = Color(0xFFFFFFFF);
const Color textSecondary = Color(0xFF94A3B8); // Muted slate text
const Color successColor = Color(0xFF00C853);
const Color warningColor = Color(0xFFFFAB00);
const Color dangerColor = Color(0xFFFF1744);
const Color infoColor = Color(0xFF2979FF);

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: bgColor,
  primaryColor: primaryColor,
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    surface: surfaceColor,
    onSurface: textPrimary,
    error: dangerColor,
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -1),
    displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 28, letterSpacing: -0.5),
    displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
    headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
    headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
    bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
    labelSmall: TextStyle(color: textSecondary, fontSize: 11, letterSpacing: 0.5),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: bgColor,
    elevation: 0,
    centerTitle: false,
    toolbarTextStyle: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
    titleTextStyle: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
    iconTheme: IconThemeData(color: textPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: textPrimary,
      side: BorderSide(color: textPrimary.withValues(alpha: 0.1), width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: surfaceColor,
    prefixIconColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused) ? primaryColor : textSecondary,
    ),
    suffixIconColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused) ? primaryColor : textSecondary,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: dangerColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    labelStyle: const TextStyle(color: textSecondary),
    hintStyle: const TextStyle(color: Color(0xFF4B5563)),
  ),
  cardTheme: CardThemeData(
    color: surfaceColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
  ),


  dividerTheme: DividerThemeData(
    color: Colors.white.withValues(alpha: 0.05),
    thickness: 1,
  ),
);

// Unified Modern Card Widget with Sleek Borders and Shadows
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradient;

  const ModernCard({super.key, required this.child, this.padding, this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        gradient: gradient != null ? LinearGradient(colors: gradient!) : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

