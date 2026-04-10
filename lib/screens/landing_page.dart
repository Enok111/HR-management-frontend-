import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background subtle gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgColor, Color(0xFF161E27)],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.auto_awesome,
                            color: primaryColor, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'HR MANAGEMENT',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 48, height: 1.1),
                      children: const [
                        TextSpan(text: 'Elevate Your '),
                        TextSpan(
                          text: 'Workforce\n',
                          style: TextStyle(color: primaryColor),
                        ),
                        TextSpan(text: 'Management'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Experience the future of Human Resource Management with our modern, AI-powered platform. Streamline onboarding, attendance, and payroll in one sleek interface.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: textSecondary,
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Trusted by 500+ global enterprises',
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
