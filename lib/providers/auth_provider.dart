import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/services/auth_service.dart';
import '../core/app_state.dart';
import '../models/user_role.dart';
import '../core/api/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _authService.login(email: email, password: password);

      if (response.error == null && response.token != null) {
        UserRole mappedRole;
        final String roleStr = response.role?.toUpperCase() ?? 'EMPLOYEE';
        
        switch (roleStr) {
          case 'ADMIN':
            mappedRole = UserRole.admin;
            break;
          case 'HR':
            mappedRole = UserRole.hr;
            break;
          case 'MANAGER':
            mappedRole = UserRole.manager;
            break;
          case 'EMPLOYEE':
          default:
            mappedRole = UserRole.employee;
            break;
        }

        bool onboarded = true;
        if (mappedRole == UserRole.employee) {
          onboarded = await ApiService().getOnboardingStatus();
        }

        _currentUser = UserModel(
          id: response.email ?? email,
          name: response.email?.split('@').first ?? 'User',
          email: response.email ?? email,
          role: mappedRole,
          onboardingCompleted: onboarded,
        );

        appState.currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          password: '',
          role: mappedRole,
          isFirstLogin: !onboarded,
          onboardingCompleted: onboarded,
        );

        _isLoading = false;
        notifyListeners();
        return null;
      } else {
        _isLoading = false;
        notifyListeners();
        return response.error ?? "Authentication failed";
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Unexpected error: $e";
    }
  }

  void logout() {
    _currentUser = null;
    appState.logout(); 
    _authService.logout();
    notifyListeners();
  }

  Future<void> setOnboardingCompleted() async {
    if (_currentUser != null) {
      await ApiService().completeOnboarding();
      
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        role: _currentUser!.role,
        department: _currentUser!.department,
        joiningDate: _currentUser!.joiningDate,
        onboardingCompleted: true,
      );
      
      appState.completeOnboarding();
      notifyListeners();
    }
  }
}