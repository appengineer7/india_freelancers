import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';
import '../bindings/auth_binding.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthBinding.of(context);

    return AppScaffold(
      currentRoute: '/profile',
      showBackButton: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Profile',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.cardBorder),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.green100,
                    child: Text(
                      controller.displayName.isNotEmpty
                          ? controller.displayName[0].toUpperCase()
                          : 'I',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    controller.displayName,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.currentEmail ?? 'No signed-in account',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.ink500,
                      fontSize: 15,
                    ),
                  ),
                  if (controller.currentAccountType != null &&
                      controller.currentAccountType!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Joining as ${controller.currentAccountType}',
                      style: const TextStyle(
                        color: AppColors.ink300,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Open settings',
              large: true,
              expanded: true,
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
            if (controller.isLoggedIn) ...[
              const SizedBox(height: 12),
              AppButton(
                label: 'Sign out',
                variant: ButtonVariant.light,
                large: true,
                expanded: true,
                onTap: () {
                  controller.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
                },
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
