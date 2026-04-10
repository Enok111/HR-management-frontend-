import 'package:flutter/material.dart';
import 'package:hr/models/user_role.dart';
import 'package:provider/provider.dart';
import 'package:hr/theme/app_theme.dart';
import 'package:hr/screens/dashboard/dashboard_screen.dart';
import 'package:hr/screens/onboarding/welcome_screen.dart';
import 'package:hr/providers/auth_provider.dart';
import 'package:hr/screens/landing_page.dart';

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
          // Loading state
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Not Logged In -> Show Landing Page
          if (authProvider.currentUser == null) {
            return const LandingPage();
          }

          // Onboarding check
          if (!authProvider.currentUser!.onboardingCompleted) {
            return const WelcomeScreen();
          }

          if (authProvider.currentUser!.role == UserRole.admin || authProvider.currentUser!.role == UserRole.hr || authProvider.currentUser!.role == UserRole.manager) {
            return const AdminDashboard();
          }
          return const EmployeeDashboard();
        },
      ),

    );
  }
}