import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';
import '../bindings/auth_binding.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AuthBinding.of(context).clearAllAuthFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthBinding.of(context),
      builder: (context, _) {
        final controller = AuthBinding.of(context);
        return _AuthScaffold(
          currentRoute: '/login',
          child: _AuthCard(
            title: 'Welcome back',
            subtitle: 'Sign in to your account',
            children: [
              AuthTextField(
                label: 'Email address',
                controller: controller.loginEmailController,
                keyboardType: TextInputType.emailAddress,
                errorText: controller.loginError,
              ),
              const SizedBox(height: 22),
              AuthTextField(
                label: 'Password',
                controller: controller.loginPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: controller.rememberMe,
                    activeColor: AppColors.green,
                    onChanged: controller.toggleRemember,
                  ),
                  const Expanded(
                    child: Text(
                      'Remember me',
                      style: TextStyle(color: AppColors.ink500, fontSize: 15),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/forgot-password'),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Sign in',
                large: true,
                expanded: true,
                onTap: () => controller.submitLogin(context),
              ),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'New to IndiaFreelancers.com? ',
                      style: TextStyle(color: AppColors.ink500),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearAllAuthFields();
                        Navigator.of(context).pushNamed('/register');
                      },
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AuthBinding.of(context).clearAllAuthFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthBinding.of(context),
      builder: (context, _) {
        final controller = AuthBinding.of(context);
        return _AuthScaffold(
          currentRoute: '/register',
          child: _AuthCard(
            title: 'Create your account',
            subtitle: 'Free to join. Verify your email to get started.',
            children: [
              AuthTextField(
                label: 'Full name',
                controller: controller.registerNameController,
              ),
              const SizedBox(height: 22),
              AuthTextField(
                label: 'Email address',
                controller: controller.registerEmailController,
                keyboardType: TextInputType.emailAddress,
                errorText: controller.registerError,
              ),
              const SizedBox(height: 22),
              const _AuthLabel('I am joining as a'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: controller.accountType.isEmpty ? null : controller.accountType,
                items: const [
                  DropdownMenuItem(value: '', child: Text('Select one')),
                  DropdownMenuItem(
                    value: 'freelancer',
                    child: Text('Freelancer — I want to find work'),
                  ),
                  DropdownMenuItem(
                    value: 'client',
                    child: Text('Client — I want to hire'),
                  ),
                  DropdownMenuItem(value: 'both', child: Text('Both')),
                ],
                onChanged: controller.updateAccountType,
                decoration: authInputDecoration().copyWith(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: AppColors.green, width: 1.5),
                  ),
                ),
                style: const TextStyle(color: AppColors.navy, fontSize: 16),
              ),
              const SizedBox(height: 22),
              AuthTextField(
                label: 'Country code',
                hint: '(e.g. IN, US)',
                controller: controller.registerCountryController,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 22),
              AuthTextField(
                label: 'Password',
                controller: controller.registerPasswordController,
                obscureText: true,
                helperText:
                    'At least 10 characters, with a letter plus a number or symbol.',
              ),
              const SizedBox(height: 22),
              AuthTextField(
                label: 'Confirm password',
                controller: controller.registerConfirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.termsAccepted,
                    activeColor: AppColors.green,
                    onChanged: controller.toggleTerms,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/legal/terms'),
                                child: const Text(
                                  'Terms',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/legal/privacy'),
                                child: const Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                        style:
                            const TextStyle(color: AppColors.ink500, height: 1.4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Create account',
                large: true,
                expanded: true,
                onTap: () => controller.submitRegister(context),
              ),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.ink500),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.clearAllAuthFields();
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthScaffold(
      currentRoute: '/verify',
      child: _VerifyCard(
        onBack: () => Navigator.of(context).pushReplacementNamed('/login'),
      ),
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  const _AuthScaffold({
    required this.child,
    this.currentRoute = '/login',
  });

  final Widget child;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: currentRoute,
      showBottomNav: false,
      showBackButton: currentRoute != '/login',
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: child,
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: authCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BrandLockup(compact: true, showText: false)),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.ink500, fontSize: 15),
          ),
          const SizedBox(height: 28),
          ...children,
        ],
      ),
    );
  }
}

class _VerifyCard extends StatelessWidget {
  const _VerifyCard({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: authCardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(child: BrandLockup(compact: true, showText: false)),
          const SizedBox(height: 24),
          const Text(
            'Check your inbox',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "We've sent a verification link to your email address. Click it to activate your account, then sign in.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.ink500, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 28),
          AppButton(
            label: 'Back to sign in',
            variant: ButtonVariant.light,
            large: true,
            expanded: true,
            onTap: onBack,
          ),
        ],
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AuthLabel(label, hint: hint),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: const TextStyle(color: AppColors.navy, fontSize: 18),
          decoration: authInputDecoration(errorText: errorText),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(
            helperText!,
            style: const TextStyle(color: AppColors.ink500, fontSize: 14),
          ),
        ],
      ],
    );
  }
}

class _AuthLabel extends StatelessWidget {
  const _AuthLabel(this.label, {this.hint});

  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: label),
          if (hint != null)
            TextSpan(
              text: ' $hint',
              style: const TextStyle(
                color: AppColors.ink300,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

InputDecoration authInputDecoration({String? errorText}) {
  return InputDecoration(
    errorText: errorText,
    errorMaxLines: 3,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: AppColors.green, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: Color(0xffc5372e), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: const BorderSide(color: Color(0xffc5372e), width: 2),
    ),
  );
}

BoxDecoration authCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(color: AppColors.cardBorder),
    borderRadius: BorderRadius.circular(20),
  );
}
