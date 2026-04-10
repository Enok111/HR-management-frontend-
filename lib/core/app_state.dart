import 'package:flutter/material.dart';
import '../models/user_role.dart';
import 'api/api_service.dart';

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
    // Initialized with empty state, data will be fetched via services
  }

  User? currentUser;
  List<User> users = [];
  List<Map<String, dynamic>> leaveRequests = [];
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> auditLogs = [];
  Map<String, Map<String, dynamic>> attendance = {}; // userId -> {date: {checkIn, checkOut}}

  List<User> get employees => users.where((u) => u.role == UserRole.employee).toList();

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
  bool _isInitialDataFetched = false;

  Future<void> fetchInitialData() async {
    if (_isInitialDataFetched) return;
    
    if (currentUser?.role == UserRole.employee) {
      final myAttendance = await ApiService().getMyAttendance();
      if (myAttendance.isNotEmpty) {
        final lastRecord = myAttendance.last;
        _isClockedIn = lastRecord['clockOutTime'] == null;
        
        attendance[currentUser!.id] = {};
        for (var record in myAttendance) {
          final String date = record['date'].toString().split('T')[0];
          attendance[currentUser!.id]![date] = {
             'checkIn': record['clockInTime'],
             'checkOut': record['clockOutTime']
          };
        }
      }
      
      final leaves = await ApiService().getMyLeaves();
      leaveRequests = leaves.map((apiLeave) => {
        'userId': currentUser!.id,
        'type': apiLeave['leaveType'],
        'startDate': apiLeave['startDate']?.toString().split('T')[0],
        'endDate': apiLeave['endDate']?.toString().split('T')[0],
        'reason': apiLeave['reason'],
        'status': apiLeave['status'] ?? 'Pending',
      }).toList();
      
    } else if (currentUser != null) {
      final allLeaves = await ApiService().getAllLeaves();
      leaveRequests = allLeaves.map((apiLeave) => {
        'id': apiLeave['id'],
        'userId': apiLeave['employeeId'].toString(),
        'type': apiLeave['leaveType'],
        'startDate': apiLeave['startDate']?.toString().split('T')[0],
        'endDate': apiLeave['endDate']?.toString().split('T')[0],
        'reason': apiLeave['reason'],
        'status': apiLeave['status'] ?? 'Pending',
      }).toList();

      final emps = await ApiService().getEmployees();
      users = emps.map((e) => User(
        id: e['id']?.toString() ?? '',
        name: e['firstName'] != null && e['lastName'] != null ? '${e['firstName']} ${e['lastName']}' : (e['username'] ?? 'Employee'),
        email: e['email'] ?? '',
        password: '',
        role: UserRole.employee, // Admins manage employees
      )).toList();
    }
    
    _isInitialDataFetched = true;
    notifyListeners();
  }

  void checkIn() async {
    if (currentUser != null) {
      final success = await ApiService().clockIn();
      if (success) {
        _isInitialDataFetched = false;
        await fetchInitialData();
        addNotification("${currentUser!.name} has clocked in.", true);
      }
    }
  }

  void checkOut() async {
    if (currentUser != null) {
      final success = await ApiService().clockOut();
      if (success) {
        _isInitialDataFetched = false;
        await fetchInitialData();
      }
    }
  }

  void requestLeave(String type, String startDate, String endDate, String reason) async {
    final success = await ApiService().submitLeave({
      "leaveType": type,
      "startDate": startDate,
      "endDate": endDate,
      "reason": reason
    });
    
    if (success) {
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
  }

  void submitFeedback(String message) async {
    // Simulate API call: /api/feedback
    addNotification("New feedback from ${currentUser!.name}: $message", true);
    notifyListeners();
  }


  void updateLeaveStatus(int index, String newStatus) async {
    final leaveId = leaveRequests[index]['id'];
    if (leaveId != null) {
      final success = await ApiService().actionLeave(leaveId, newStatus);
      if (success) {
        leaveRequests[index]["status"] = newStatus;
        notifyListeners();
      }
    }
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
