import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/view/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.people_alt_rounded,
      iconColor: AppColors.primaryBlue,
      iconBg: Color(0xffe8f1ff),
      title: 'Find the Best Freelancers',
      subtitle: 'Connect with verified professionals across India.',
    ),
    _OnboardingPageData(
      icon: Icons.verified_user_rounded,
      iconColor: AppColors.green,
      iconBg: AppColors.green100,
      title: 'Hire with Confidence',
      subtitle: 'Review ratings, portfolios and feedback before hiring.',
    ),
    _OnboardingPageData(
      icon: Icons.rocket_launch_rounded,
      iconColor: AppColors.saffron,
      iconBg: AppColors.saffron100,
      title: 'Get Work Done Faster',
      subtitle:
          'Communicate, collaborate and track progress in one place.',
    ),
    _OnboardingPageData(
      icon: Icons.handshake_rounded,
      iconColor: AppColors.navy700,
      iconBg: Color(0xffe8edf7),
      title: 'Ready to Get Started?',
      subtitle:
          'Join thousands of clients and freelancers building success together.',
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      _finishOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.ink500,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: page.iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 96,
                            color: page.iconColor,
                          ),
                        ),
                        const SizedBox(height: 44),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.ink500,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                final active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primaryBlue
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: isLast ? 'Get Started' : 'Next',
                  large: true,
                  onTap: _next,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
}
