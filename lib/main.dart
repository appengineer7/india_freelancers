import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'alerts/view/alerts_screen.dart';
import 'auth/bindings/auth_binding.dart';
import 'auth/view/auth_screen.dart';
import 'auth/view/profile_screen.dart';
import 'auth/view/settings_screen.dart';
import 'contracts/view/contracts_screen.dart';
import 'home/bindings/home_binding.dart';
import 'home/view/home_screen.dart';
import 'home/view/search_screen.dart';
import 'jobs/view/jobs_screen.dart';
import 'messages/view/messages_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/splash_screen.dart';
import 'pages/info_pages.dart'
    hide
        AlertsScreen,
        ContractsScreen,
        JobsScreen,
        MessagesScreen,
        ProposalsScreen;
import 'proposals/view/proposals_screen.dart';
import 'contracts/view/workroom_timesheet_screen.dart';
import 'jobs/view/job_search_screen.dart';

void main() {
  runApp(const IndiaFreelancersApp());
}

class IndiaFreelancersApp extends StatelessWidget {
  const IndiaFreelancersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final manrope = GoogleFonts.manropeTextTheme();

    return MaterialApp(
      title: 'IndiaFreelancers.com',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.saffron,
          primary: AppColors.saffron,
          secondary: AppColors.green,
          tertiary: AppColors.navy,
          surface: AppColors.cream50,
        ),
        scaffoldBackgroundColor: AppColors.cream50,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: manrope
            .copyWith(
              displayLarge: manrope.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
                height: 1.04,
              ),
              headlineMedium: manrope.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
                height: 1.12,
              ),
              titleLarge: manrope.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
              titleMedium: manrope.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
              bodyLarge: manrope.bodyLarge?.copyWith(height: 1.55),
              bodyMedium: manrope.bodyMedium?.copyWith(height: 1.55),
            )
            .apply(bodyColor: AppColors.ink700, displayColor: AppColors.navy),
      ),
      initialRoute: '/',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/': (_) => const HomeBinding(
              child: AuthBinding(
                child: HomeScreen(),
              ),
            ),
        '/search': (_) => const HomeBinding(child: SearchScreen()),
        '/login': (_) =>
            const HomeBinding(child: AuthBinding(child: LoginScreen())),
        '/register': (_) =>
            const HomeBinding(child: AuthBinding(child: RegisterScreen())),
        '/verify': (_) =>
            const HomeBinding(child: AuthBinding(child: VerifyScreen())),
        '/forgot-password': (_) =>
            const HomeBinding(child: ForgotPasswordScreen()),
        '/profile': (_) =>
            const HomeBinding(child: AuthBinding(child: ProfileScreen())),
        '/settings': (_) =>
            const HomeBinding(child: AuthBinding(child: SettingsScreen())),
        '/jobs': (_) => const HomeBinding(child: JobsScreen()),
        '/proposals': (_) => const HomeBinding(child: ProposalsScreen()),
        '/contracts': (_) => const HomeBinding(child: ContractsScreen()),
        '/workroom-timesheet': (_) => const HomeBinding(child: WorkroomTimesheetScreen()),
        '/job-search': (_) => const HomeBinding(child: JobSearchScreen()),
        '/messages': (_) => const HomeBinding(child: MessagesScreen()),
        '/alerts': (_) => const HomeBinding(child: AlertsScreen()),
        '/how-it-works': (_) => const HomeBinding(child: HowItWorksScreen()),
        '/pricing': (_) => const HomeBinding(child: PricingScreen()),
        '/trust': (_) => const HomeBinding(child: TrustScreen()),
        '/about': (_) => const HomeBinding(child: AboutScreen()),
        '/contact': (_) => const HomeBinding(child: ContactScreen()),
        '/help': (_) => const HomeBinding(child: HelpScreen()),
        '/legal/terms': (_) => const HomeBinding(child: TermsScreen()),
        '/legal/privacy': (_) => const HomeBinding(child: PrivacyScreen()),
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const IndiaFreelancersApp();
}
