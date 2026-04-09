import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hr/theme/app_theme.dart';
import 'package:hr/screens/auth/login_screen.dart';
import 'package:hr/screens/dashboard/dashboard_screen.dart';
import 'package:hr/screens/onboarding/welcome_screen.dart';
import 'package:hr/providers/auth_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const HRAdminApp(),
    ),
  );
}

class HRAdminApp extends StatelessWidget {
  const HRAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Modern HR System',
      theme: appTheme,

      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Loading state — API call நடக்கும் போது spinner காட்டு
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Login ஆகவில்லை → LoginScreen
          if (authProvider.currentUser == null) {
            return const LoginScreen();
          }

          // Onboarding complete ஆகவில்லை → WelcomeScreen
          if (!authProvider.currentUser!.onboardingCompleted) {
            return const WelcomeScreen();
          }

          if (authProvider.currentUser!.role == 'admin' || authProvider.currentUser!.role == 'hr') {
            return const AdminDashboard();
          }
          return const EmployeeDashboard();
        },
      ),
    );
  }
}