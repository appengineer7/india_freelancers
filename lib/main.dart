import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/bindings/auth_binding.dart';
import 'auth/view/auth_screen.dart';
import 'auth/view/profile_screen.dart';
import 'auth/view/settings_screen.dart';
import 'dashboard/models/dashboard_page_model.dart';
import 'dashboard/view/dashboard_screen.dart';
import 'home/bindings/home_binding.dart';
import 'home/view/home_screen.dart';
import 'home/view/search_screen.dart';
import 'jobs/view/jobs_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'onboarding/splash_screen.dart';
import 'pages/info_pages.dart'
    hide
        AlertsScreen,
        ContractsScreen,
        JobsScreen,
        MessagesScreen,
        ProposalsScreen;
import 'contracts/view/workroom_timesheet_screen.dart';
import 'jobs/view/job_search_screen.dart';
import 'services/job_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JobStore.instance.load();
  runApp(const IndiaFreelancersApp());
}

class IndiaFreelancersApp extends StatelessWidget {
  const IndiaFreelancersApp({super.key});

  @override
  Widget build(BuildContext context) {
    final manrope = GoogleFonts.manropeTextTheme();

    return AuthBinding(
      child: MaterialApp(
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
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _SoftPageTransitionsBuilder(),
              TargetPlatform.iOS: _SoftPageTransitionsBuilder(),
              TargetPlatform.macOS: _SoftPageTransitionsBuilder(),
              TargetPlatform.windows: _SoftPageTransitionsBuilder(),
              TargetPlatform.linux: _SoftPageTransitionsBuilder(),
            },
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
          '/': (_) =>
              const HomeBinding(child: AuthBinding(child: HomeScreen())),
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
          '/find-work': (_) =>
              const HomeBinding(child: AuthBinding(child: FindWorkScreen())),
          '/overview': (_) => const HomeBinding(
            child: AuthBinding(child: JobsScreen(currentRoute: '/overview')),
          ),
          '/jobs': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.myJobs),
              ),
            ),
          ),
          '/post-job': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.postJob),
              ),
            ),
          ),
          '/proposals': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.myProposals),
              ),
            ),
          ),
          '/invitations': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.invitations),
              ),
            ),
          ),
          '/offers-received': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.offersReceived),
              ),
            ),
          ),
          '/offers-sent': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.offersSent),
              ),
            ),
          ),
          '/contracts': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.contracts),
              ),
            ),
          ),
          '/workroom-timesheet': (_) =>
              const HomeBinding(child: WorkroomTimesheetScreen()),
          '/job-search': (_) => const HomeBinding(child: JobSearchScreen()),
          '/payouts': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.payouts),
              ),
            ),
          ),
          '/messages': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.messages),
              ),
            ),
          ),
          '/alerts': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.notifications),
              ),
            ),
          ),
          '/freelancer-profile': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(
                  DashboardPageKind.freelancerProfile,
                ),
              ),
            ),
          ),
          '/client-profile': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.clientProfile),
              ),
            ),
          ),
          '/security-sessions': (_) => HomeBinding(
            child: AuthBinding(
              child: DashboardScreen(
                page: DashboardPages.byKind(DashboardPageKind.securitySessions),
              ),
            ),
          ),
          '/how-it-works': (_) => const HomeBinding(child: HowItWorksScreen()),
          '/pricing': (_) => const HomeBinding(child: PricingScreen()),
          '/trust': (_) => const HomeBinding(child: TrustScreen()),
          '/about': (_) => const HomeBinding(child: AboutScreen()),
          '/contact': (_) => const HomeBinding(child: ContactScreen()),
          '/help': (_) => const HomeBinding(child: HelpScreen()),
          '/legal/terms': (_) => const HomeBinding(child: TermsScreen()),
          '/legal/privacy': (_) => const HomeBinding(child: PrivacyScreen()),
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const IndiaFreelancersApp();
}

class _SoftPageTransitionsBuilder extends PageTransitionsBuilder {
  const _SoftPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final offset = Tween<Offset>(
      begin: const Offset(0.025, 0),
      end: Offset.zero,
    ).animate(curved);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(position: offset, child: child),
    );
  }
}
