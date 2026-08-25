import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  const UserSession({
    required this.id,
    required this.ipAddress,
    required this.device,
    required this.createdAt,
    required this.lastActiveAt,
    this.isCurrent = false,
  });

  final String id;
  final String ipAddress;
  final String device;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final bool isCurrent;

  UserSession copyWith({bool? isCurrent, DateTime? lastActiveAt}) {
    return UserSession(
      id: id,
      ipAddress: ipAddress,
      device: device,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ipAddress': ipAddress,
      'device': device,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] as String? ?? '',
      ipAddress: json['ipAddress'] as String? ?? 'Local device',
      device: json['device'] as String? ?? 'Current browser or device',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      lastActiveAt:
          DateTime.tryParse(json['lastActiveAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class AuthController extends ChangeNotifier {
  AuthController() {
    _restoreStoredSession();
  }

  static const _nameKey = 'auth.currentName';
  static const _emailKey = 'auth.currentEmail';
  static const _accountTypeKey = 'auth.currentAccountType';
  static const _sessionIdKey = 'auth.currentSessionId';
  static const _sessionsKey = 'auth.sessions';

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerCountryController = TextEditingController(text: 'IN');
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  bool rememberMe = true;
  bool termsAccepted = false;
  String accountType = '';
  String? loginError;
  String? registerError;

  String? currentName;
  String? currentEmail;
  String? currentAccountType;
  String? currentSessionId;
  List<UserSession> sessions = [];
  bool notificationsEnabled = true;
  bool privacyModeEnabled = false;
  String language = 'English';

  bool get isLoggedIn => currentEmail != null || currentName != null;

  String get activeAccountMode {
    final value = currentAccountType?.trim().toLowerCase();
    if (value == 'client' || value == 'freelancer') return value!;

    final pendingValue = accountType.trim().toLowerCase();
    if (pendingValue == 'client' || pendingValue == 'freelancer') {
      return pendingValue;
    }

    return 'freelancer';
  }

  String get displayName {
    if (currentName != null && currentName!.isNotEmpty) {
      return currentName!;
    }
    if (currentEmail != null && currentEmail!.isNotEmpty) {
      return currentEmail!.split('@').first;
    }
    return 'Guest';
  }

  void toggleRemember(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  void toggleTerms(bool? value) {
    termsAccepted = value ?? false;
    notifyListeners();
  }

  void updateAccountType(String? value) {
    if (value == null) return;
    accountType = value;
    notifyListeners();
  }

  void activateAccountMode(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized != 'client' && normalized != 'freelancer') return;
    accountType = normalized;
    currentAccountType = normalized;
    _saveStoredSession();
    notifyListeners();
  }

  void setCurrentUserFromLogin() {
    currentEmail = loginEmailController.text.trim();
    currentName ??= '';
    currentAccountType ??= accountType;
    _upsertCurrentSession();
    if (rememberMe) {
      _saveStoredSession();
    } else {
      _clearStoredSession();
    }
    notifyListeners();
  }

  void setCurrentUserFromRegister() {
    currentName = registerNameController.text.trim();
    currentEmail = registerEmailController.text.trim();
    currentAccountType = accountType;
    _upsertCurrentSession();
    _saveStoredSession();
    notifyListeners();
  }

  void toggleNotifications(bool? value) {
    notificationsEnabled = value ?? false;
    notifyListeners();
  }

  void togglePrivacyMode(bool? value) {
    privacyModeEnabled = value ?? false;
    notifyListeners();
  }

  void setLanguage(String? value) {
    if (value == null) return;
    language = value;
    notifyListeners();
  }

  void clearAllAuthFields() {
    loginEmailController.clear();
    loginPasswordController.clear();
    registerNameController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
    accountType = '';
    termsAccepted = false;
    loginError = null;
    registerError = null;
    notifyListeners();
  }

  void submitLogin(BuildContext context) {
    if (loginEmailController.text.trim().isEmpty) {
      loginError = 'Please enter your email address.';
      notifyListeners();
      return;
    }
    loginError = null;
    setCurrentUserFromLogin();
    clearAllAuthFields();
    Navigator.of(context).pushNamedAndRemoveUntil('/overview', (_) => false);
  }

  void logout() {
    currentSessionId = null;
    currentEmail = null;
    currentName = null;
    currentAccountType = null;
    sessions = [];
    _clearStoredSession();
    clearAllAuthFields();
    notifyListeners();
  }

  void submitRegister(BuildContext context) {
    setCurrentUserFromRegister();
    registerError = null;
    clearAllAuthFields();
    Navigator.of(context).pushNamedAndRemoveUntil('/overview', (_) => false);
  }

  void revokeSession(String sessionId) {
    final wasCurrentSession = sessionId == currentSessionId;
    sessions = sessions.where((session) => session.id != sessionId).toList();

    if (wasCurrentSession) {
      currentSessionId = null;
      currentEmail = null;
      currentName = null;
      currentAccountType = null;
      _clearStoredSession();
    } else {
      _saveStoredSession();
    }

    notifyListeners();
  }

  void revokeOtherSessions() {
    if (currentSessionId == null) return;
    sessions = sessions
        .where((session) => session.id == currentSessionId)
        .toList();
    _saveStoredSession();
    notifyListeners();
  }

  Future<void> _restoreStoredSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedEmail = prefs.getString(_emailKey);
      final storedName = prefs.getString(_nameKey);
      final storedSessionId = prefs.getString(_sessionIdKey);

      if ((storedEmail == null || storedEmail.isEmpty) &&
          (storedName == null || storedName.isEmpty)) {
        return;
      }

      currentEmail = storedEmail;
      currentName = storedName;
      currentAccountType = prefs.getString(_accountTypeKey);
      currentSessionId = storedSessionId;

      final storedSessions = prefs.getString(_sessionsKey);
      sessions = _decodeSessions(storedSessions);
      if (currentSessionId != null) {
        _upsertCurrentSession();
      }

      notifyListeners();
    } catch (_) {
      // Local session restore is best-effort so widget tests and unsupported
      // platforms can still run without a preferences backend.
    }
  }

  Future<void> _saveStoredSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, currentEmail ?? '');
      await prefs.setString(_nameKey, currentName ?? '');
      await prefs.setString(_accountTypeKey, currentAccountType ?? '');
      await prefs.setString(_sessionIdKey, currentSessionId ?? '');
      await prefs.setString(
        _sessionsKey,
        jsonEncode(sessions.map((session) => session.toJson()).toList()),
      );
    } catch (_) {}
  }

  Future<void> _clearStoredSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_nameKey);
      await prefs.remove(_emailKey);
      await prefs.remove(_accountTypeKey);
      await prefs.remove(_sessionIdKey);
      await prefs.remove(_sessionsKey);
    } catch (_) {}
  }

  List<UserSession> _decodeSessions(String? value) {
    if (value == null || value.isEmpty) return [];
    final decoded = jsonDecode(value);
    if (decoded is! List) return [];

    return decoded
        .whereType<Map>()
        .map((item) => UserSession.fromJson(Map<String, dynamic>.from(item)))
        .where((session) => session.id.isNotEmpty)
        .map(
          (session) =>
              session.copyWith(isCurrent: session.id == currentSessionId),
        )
        .toList();
  }

  void _upsertCurrentSession() {
    final now = DateTime.now();
    currentSessionId ??= 'session-${now.microsecondsSinceEpoch}';
    final session = UserSession(
      id: currentSessionId!,
      ipAddress: 'Current network',
      device: 'This browser or device',
      createdAt: now,
      lastActiveAt: now,
      isCurrent: true,
    );

    final existingIndex = sessions.indexWhere(
      (item) => item.id == currentSessionId,
    );
    if (existingIndex == -1) {
      sessions = [
        session,
        ...sessions.map((item) => item.copyWith(isCurrent: false)),
      ];
    } else {
      sessions = [
        for (var i = 0; i < sessions.length; i++)
          if (i == existingIndex)
            sessions[i].copyWith(isCurrent: true, lastActiveAt: now)
          else
            sessions[i].copyWith(isCurrent: false),
      ];
    }
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerCountryController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.dispose();
  }
}
