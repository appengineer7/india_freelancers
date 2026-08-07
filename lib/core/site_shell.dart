import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home/view/home_screen.dart';

/// App-style scaffold: compact top bar, scroll body, bottom navigation.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.currentRoute = '/',
    this.showBottomNav = true,
    this.showBackButton = false,
    this.title,
    this.isHome = false,
  });

  final Widget body;
  final String currentRoute;
  final bool showBottomNav;
  final bool showBackButton;
  final String? title;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBarWidget;
    if (currentRoute == '/jobs') {
      appBarWidget = const JobsAppBar();
    } else if (currentRoute == '/proposals') {
      appBarWidget = const ProposalsAppBar();
    } else if (currentRoute == '/contracts') {
      appBarWidget = const ContractsAppBar();
    } else if (currentRoute == '/messages') {
      appBarWidget = const MessagesAppBar();
    } else if (currentRoute == '/alerts') {
      appBarWidget = const AlertsAppBar();
    } else if (isHome) {
      appBarWidget = const HomeAppBar();
    } else {
      appBarWidget = AppAppBar(
        showBackButton: showBackButton,
        title: title,
        showNotification: !['/login', '/register', '/verify', '/forgot-password'].contains(currentRoute),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream50,
        appBar: appBarWidget,
        body: body,
        bottomNavigationBar: showBottomNav
            ? AppBottomNav(currentRoute: currentRoute)
            : null,
      ),
    );
  }
}

class JobsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const JobsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.navy,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                  fit: BoxFit.cover,
                  width: 36,
                  height: 36,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'IF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: 52,
      title: const Text(
        'Jobs',
        style: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, size: 24),
          color: AppColors.navy,
          onPressed: () => _openJobsMenu(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class ProposalsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProposalsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.navy,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                  fit: BoxFit.cover,
                  width: 36,
                  height: 36,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'IF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: 52,
      title: const Text(
        'My proposals',
        style: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_outlined, size: 18),
            color: AppColors.green,
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ),
      ],
    );
  }
}

class ContractsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContractsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.navy,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                  fit: BoxFit.cover,
                  width: 36,
                  height: 36,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'IF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: 52,
      title: const Text(
        'Contracts',
        style: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, size: 24),
          color: AppColors.navy,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessagesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.navy,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                  fit: BoxFit.cover,
                  width: 36,
                  height: 36,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'IF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: 52,
      title: const Text(
        'Messages',
        style: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            icon: const Icon(Icons.edit_square, size: 18),
            color: AppColors.green,
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class AlertsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AlertsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Center(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.navy,
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                  fit: BoxFit.cover,
                  width: 36,
                  height: 36,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'IF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: 52,
      title: const Text(
        'Alerts',
        style: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      actions: const [SizedBox(width: 52)],
    );
  }
}

void _openJobsMenu(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Job Options',
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.green,
                ),
                title: const Text(
                  'Job Feed Settings',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.green,
                ),
                title: const Text(
                  'View Profile',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pushNamed('/profile');
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.showBackButton = false,
    this.title,
    this.showNotification = true,
  });

  final bool showBackButton;
  final String? title;
  final bool showNotification;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: AppColors.navy,
              onPressed: () {
                final navigator = Navigator.of(context);
                if (navigator.canPop()) {
                  navigator.pop();
                } else {
                  navigator.pushReplacementNamed('/');
                }
              },
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            )
          : const BrandLockup(compact: true),
      actions: showNotification
          ? [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                color: AppColors.ink700,
                onPressed: () => Navigator.of(context).pushNamed('/alerts'),
              ),
              const SizedBox(width: 4),
            ]
          : null,
    );
  }
}

/// Home screen app bar: logo + app name + notification.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      titleSpacing: 16,
      title: const BrandLockup(compact: true),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, size: 24),
          color: AppColors.ink700,
          onPressed: () => Navigator.of(context).pushNamed('/alerts'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  static const _navItems = [
    _NavItem('/jobs', Icons.search_rounded, 'Jobs'),
    _NavItem('/proposals', Icons.description_rounded, 'Proposals'),
    _NavItem('/contracts', Icons.receipt_long_rounded, 'Contracts'),
    _NavItem('/messages', Icons.chat_bubble_rounded, 'Messages'),
    _NavItem('/alerts', Icons.notifications_rounded, 'Alerts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (final item in _navItems)
                Expanded(
                  child: _BottomNavItem(
                    icon: item.icon,
                    label: item.label,
                    selected: currentRoute == item.route,
                    onTap: () => _navigate(context, item.route),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (currentRoute == route) return;
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }
}

class _NavItem {
  const _NavItem(this.route, this.icon, this.label);
  final String route;
  final IconData icon;
  final String label;
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.saffron;
    final inactiveColor = AppColors.ink500;
    final color = selected ? activeColor : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: selected ? 20 : 0,
              height: selected ? 3 : 0,
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: AppColors.saffron,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared page chrome for info/detail pages.
class SiteShell extends StatelessWidget {
  const SiteShell({
    super.key,
    required this.body,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
    this.currentRoute = '/how-it-works',
    this.title,
  });

  final Widget body;
  final EdgeInsets padding;
  final String currentRoute;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: currentRoute,
      showBackButton: true,
      title: title,
      showBottomNav: false,
      body: SingleChildScrollView(padding: padding, child: body),
    );
  }
}

// Keep MobileDrawer for backward compatibility (unused in app mode).
class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class SiteNavBar extends StatelessWidget {
  const SiteNavBar({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class SiteConstrained extends StatelessWidget {
  const SiteConstrained({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}

/// Content column used on info pages.
class InfoPageContent extends StatelessWidget {
  const InfoPageContent({
    super.key,
    required this.child,
    this.maxWidth = 820,
    this.topPadding = 0,
  });

  final Widget child;
  final double maxWidth;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 24),
      child: child,
    );
  }
}

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoAlert extends StatelessWidget {
  const InfoAlert({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green100.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.25)),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: AppColors.ink700,
          fontSize: 14,
          height: 1.5,
        ),
        child: child,
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}
