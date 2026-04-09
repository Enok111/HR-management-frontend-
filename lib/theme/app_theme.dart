import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFE26145); // Warm coral
const Color secondaryColor = Color(0xFFF2A694); // Soft peach
const Color tertiaryColor = Color(0xFFC4B2EE); // Soft purple
const Color accentColor = Color(0xFF8ADAB1); // Soft green
const Color bgColor = Color(0xFFFCF9F8); // Soft warm white background
const Color cardColor = Colors.white;
const Color textPrimary = Color(0xFF1E2022); // Dark slate/almost black
const Color textSecondary = Color(0xFF8B929A); // Medium grey
const Color successColor = Color(0xFF8ADAB1); // Light green
const Color warningColor = Color(0xFFF0BD7E); // Warm yellow/orange
const Color dangerColor = Color(0xFFD9534F); // Soft red
const Color infoColor = Color(0xFF9DB2EA); // Soft blue

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: bgColor,
  primaryColor: primaryColor,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: tertiaryColor,
    surface: cardColor,
    error: dangerColor,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
    displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
    displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
    headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
    headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
    bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
    labelSmall: TextStyle(color: textSecondary, fontSize: 12),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: false,
    toolbarTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 4,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    prefixIconColor: WidgetStateColor.resolveWith(
      (states) => states.contains(WidgetState.focused) ? primaryColor : textSecondary,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: dangerColor),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    labelStyle: const TextStyle(color: textSecondary),
  ),
  tabBarTheme: const TabBarThemeData(
    labelColor: primaryColor,
    unselectedLabelColor: textSecondary,
    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    unselectedLabelStyle: TextStyle(fontSize: 14),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: primaryColor, width: 3),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: primaryColor.withValues(alpha: 0.1),
    labelStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ModernCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}
