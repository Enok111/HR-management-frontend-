import 'package:flutter/material.dart';
import '../models/user_role.dart';

class User {
  String id;
  String name;
  String email;
  String password;
  UserRole role;
  bool isFirstLogin;
  bool onboardingCompleted;
  String? phone;
  String? address;
  String? emergencyContact;
  List<String> uploadedDocuments;
  bool policiesAccepted;
  List<String> equipmentRequests;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.isFirstLogin = true,
    this.onboardingCompleted = false,
    this.phone,
    this.address,
    this.emergencyContact,
    List<String>? uploadedDocuments,
    this.policiesAccepted = false,
    List<String>? equipmentRequests,
  }) : uploadedDocuments = uploadedDocuments ?? [], equipmentRequests = equipmentRequests ?? [];
}

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _initializeUsers();
  }

  User? currentUser;
  List<User> users = [];
  List<Map<String, dynamic>> leaveRequests = [];
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> auditLogs = [];
  Map<String, Map<String, dynamic>> attendance = {}; // userId -> {date: {checkIn, checkOut}}

  void _initializeUsers() {
    users = [
      User(
        id: "E001",
        name: "Employee One",
        email: "employee@example.com",
        password: "pass123",
        role: UserRole.employee,
        isFirstLogin: false,
        onboardingCompleted: true,
      ),
      User(
        id: "H001",
        name: "HR One",
        email: "hr@example.com",
        password: "pass123",
        role: UserRole.hr,
        isFirstLogin: false,
        onboardingCompleted: true,
      ),
      User(
        id: "M001",
        name: "Manager One",
        email: "manager@example.com",
        password: "pass123",
        role: UserRole.manager,
        isFirstLogin: false,
        onboardingCompleted: true,
      ),
      User(
        id: "E002",
        name: "New Employee",
        email: "new@example.com",
        password: "pass123",
        role: UserRole.employee,
        isFirstLogin: true,
        onboardingCompleted: false,
      ),
    ];
  }

  List<User> get employees => users.where((u) => u.role == UserRole.employee).toList();

  bool login(String email, String password) {
    final user = users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(id: '', name: '', email: '', password: '', role: UserRole.employee),
    );
    if (user.id.isNotEmpty) {
      currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  void completeOnboarding() {
    if (currentUser != null) {
      currentUser!.onboardingCompleted = true;
      currentUser!.isFirstLogin = false;
      notifyListeners();
    }
  }

  void updateProfile({String? phone, String? address, String? emergencyContact}) {
    if (currentUser != null) {
      if (phone != null) currentUser!.phone = phone;
      if (address != null) currentUser!.address = address;
      if (emergencyContact != null) currentUser!.emergencyContact = emergencyContact;
      notifyListeners();
    }
  }

  void uploadDocument(String document) {
    if (currentUser != null) {
      currentUser!.uploadedDocuments.add(document);
      notifyListeners();
    }
  }

  void acceptPolicies() {
    if (currentUser != null) {
      currentUser!.policiesAccepted = true;
      notifyListeners();
    }
  }

  void requestEquipment(String equipment) {
    if (currentUser != null) {
      currentUser!.equipmentRequests.add(equipment);
      notifyListeners();
    }
  }

  bool _isClockedIn = false;
  bool get isClockedIn => _isClockedIn;

  void checkIn() async {
    if (currentUser != null) {
      // Simulate API call: /api/attendance/clockin
      final today = DateTime.now().toIso8601String().split('T')[0];
      attendance[currentUser!.id] ??= {};
      attendance[currentUser!.id]![today] = {'checkIn': DateTime.now().toIso8601String()};
      _isClockedIn = true;
      
      // Admin notification
      addNotification("${currentUser!.name} has clocked in.", true);
      
      notifyListeners();
    }
  }

  void checkOut() async {
    if (currentUser != null) {
      // Simulate API call: /api/attendance/clockout
      final today = DateTime.now().toIso8601String().split('T')[0];
      if (attendance[currentUser!.id]?[today] != null) {
        attendance[currentUser!.id]![today]['checkOut'] = DateTime.now().toIso8601String();
        _isClockedIn = false;
        notifyListeners();
      }
    }
  }

  void requestLeave(String type, String startDate, String endDate, String reason) async {
    // Simulate API call: /api/leave/request
    leaveRequests.add({
      'userId': currentUser!.id,
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': 'Pending',
      'requestedAt': DateTime.now().toIso8601String(),
    });
    addNotification("Leave request submitted by ${currentUser!.name}.", true);
    notifyListeners();
  }

  void submitFeedback(String message) async {
    // Simulate API call: /api/feedback
    addNotification("New feedback from ${currentUser!.name}: $message", true);
    notifyListeners();
  }


  void updateLeaveStatus(int index, String newStatus) {
    leaveRequests[index]["status"] = newStatus;
    final userId = leaveRequests[index]['userId'];
    final user = users.firstWhere((u) => u.id == userId);
    addNotification("Your leave request was $newStatus.", user.role == UserRole.employee);
    notifyListeners();
  }

  void addNotification(String msg, bool forAdmin) {
    notifications.insert(0, {"msg": msg, "forAdmin": forAdmin, "time": DateTime.now()});
    notifyListeners();
  }

  void addAuditLog(String action) {
    auditLogs.insert(0, {"action": action, "time": DateTime.now()});
    notifyListeners();
  }

  void addEmployee(String name, String email, String password, UserRole role) {
    final id = "${role == UserRole.employee ? 'E' : role == UserRole.hr ? 'H' : 'M'}${users.length + 1}";
    users.add(User(
      id: id,
      name: name,
      email: email,
      password: password,
      role: role,
    ));
    addAuditLog("Added new ${role.name}: $name");
    notifyListeners();
  }

  void deleteUser(int index) {
    users.removeAt(index);
    notifyListeners();
  }
}

final appState = AppState();
