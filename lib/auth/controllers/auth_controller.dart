import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
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
  bool notificationsEnabled = true;
  bool privacyModeEnabled = false;
  String language = 'English';

  bool get isLoggedIn => currentEmail != null || currentName != null;

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

  void setCurrentUserFromLogin() {
    currentEmail = loginEmailController.text.trim();
    currentName ??= '';
    currentAccountType ??= accountType;
    notifyListeners();
  }

  void setCurrentUserFromRegister() {
    currentName = registerNameController.text.trim();
    currentEmail = registerEmailController.text.trim();
    currentAccountType = accountType;
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
    Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
  }

  void logout() {
    currentEmail = null;
    currentName = null;
    clearAllAuthFields();
    notifyListeners();
  }

  void submitRegister(BuildContext context) {
    setCurrentUserFromRegister();
    registerError = null;
    clearAllAuthFields();
    Navigator.of(context).pushNamed('/verify');
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
