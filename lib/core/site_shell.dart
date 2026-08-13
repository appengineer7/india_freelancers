import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/bindings/auth_binding.dart';
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
    if (![
      '/login',
      '/register',
      '/verify',
      '/forgot-password',
    ].contains(currentRoute)) {
      appBarWidget = const JobsAppBar();
    } else if (isHome) {
      appBarWidget = const HomeAppBar();
    } else {
      appBarWidget = AppAppBar(
        showBackButton: showBackButton,
        title: title,
        showNotification: ![
          '/login',
          '/register',
          '/verify',
          '/forgot-password',
        ].contains(currentRoute),
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
  Size get preferredSize => const Size.fromHeight(104);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream50,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Container(
            height: 74,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BrandLockup(compact: true),
                  ),
                ),
                _AppBarIconBox(
                  icon: Icons.notifications_rounded,
                  color: AppColors.saffron,
                  onTap: () => Navigator.of(context).pushNamed('/alerts'),
                ),
                const SizedBox(width: 12),
                _AppBarIconBox(
                  icon: Icons.menu_rounded,
                  color: AppColors.navy,
                  onTap: () => _openJobsMenu(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarIconBox extends StatelessWidget {
  const _AppBarIconBox({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 25),
        ),
      ),
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
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.62,
        minChildSize: 0.45,
        maxChildSize: 0.85,
        builder: (sheetContext, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      children: [
                        const Text(
                          'Dashboard menu',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._dashboardMenuItems.map(
                          (item) => ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            minLeadingWidth: 30,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                            leading: Icon(item.icon, color: item.color, size: 22),
                            title: Text(
                              item.label,
                              style: const TextStyle(
                                color: AppColors.ink700,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              Navigator.of(context).pushNamed(item.route);
                            },
                          ),
                        ),
                        const Divider(height: 18),
                        ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          minLeadingWidth: 30,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          leading: const Icon(
                            Icons.logout_rounded,
                            color: AppColors.green,
                            size: 22,
                          ),
                          title: const Text(
                            'Sign out',
                            style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(ctx);
                            AuthBinding.of(context).logout();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (_) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

const _dashboardMenuItems = [
  _MenuRoute(
    'Overview',
    '/overview',
    Icons.dashboard_customize_rounded,
    AppColors.green,
  ),
  _MenuRoute(
    'My jobs',
    '/jobs',
    Icons.business_center_outlined,
    Color(0xff1688d8),
  ),
  _MenuRoute('Post a job', '/post-job', Icons.edit_square, AppColors.green),
  _MenuRoute(
    'My proposals',
    '/proposals',
    Icons.article_outlined,
    Color(0xff9146d8),
  ),
  _MenuRoute(
    'Invitations',
    '/invitations',
    Icons.mail_outline_rounded,
    AppColors.saffron,
  ),
  _MenuRoute(
    'Offers received',
    '/offers-received',
    Icons.card_giftcard_rounded,
    Color(0xff1688d8),
  ),
  _MenuRoute(
    'Offers sent',
    '/offers-sent',
    Icons.near_me_outlined,
    AppColors.green,
  ),
  _MenuRoute(
    'Contracts',
    '/contracts',
    Icons.description_outlined,
    Color(0xff1688d8),
  ),
  _MenuRoute(
    'Payouts',
    '/payouts',
    Icons.account_balance_wallet_outlined,
    Color(0xff9146d8),
  ),
  _MenuRoute(
    'Messages',
    '/messages',
    Icons.chat_bubble_outline_rounded,
    AppColors.saffron,
  ),
  _MenuRoute('Settings', '/settings', Icons.settings_outlined, AppColors.green),
];

class _MenuRoute {
  const _MenuRoute(this.label, this.route, this.icon, this.color);

  final String label;
  final String route;
  final IconData icon;
  final Color color;
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
    _NavItem('/overview', Icons.home_rounded, 'Dashboard'),
    _NavItem('/jobs', Icons.business_center_outlined, 'My jobs'),
    _NavItem('/create', Icons.add_rounded, 'Post a job'),
    _NavItem('/messages', Icons.chat_bubble_rounded, 'Messages'),
    _NavItem('/settings', Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          height: 94,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppColors.border.withValues(alpha: 0.55)),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.12),
                blurRadius: 26,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final item in _navItems)
                Expanded(
                  child: _BottomNavItem(
                    route: item.route,
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
    if (route == '/create') {
      _openCreateMenu(context);
      return;
    }
    if (currentRoute == route) return;
    Navigator.of(context).pushReplacementNamed(route);
  }

  void _openCreateMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20 + MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Choose profile',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CreateMenuTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Freelancer profile',
                    subtitle: 'Edit your public work profile',
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/freelancer-profile');
                    },
                  ),
                  const SizedBox(height: 10),
                  _CreateMenuTile(
                    icon: Icons.apartment_rounded,
                    title: 'Client profile',
                    subtitle: 'Edit your hiring profile',
                    onTap: () {
                      Navigator.pop(ctx);
                      Navigator.of(
                        context,
                      ).pushReplacementNamed('/client-profile');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CreateMenuTile extends StatelessWidget {
  const _CreateMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream50,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: AppColors.green100,
                child: Icon(icon, color: AppColors.green, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.ink500,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
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
    required this.route,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String route;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.green;
    final inactiveColor = AppColors.ink500;
    final color = selected ? activeColor : inactiveColor;
    final isCreate = route == '/create';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            height: 78,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCreate) ...[
                  Transform.translate(
                    offset: const Offset(0, -8),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withValues(alpha: 0.24),
                            blurRadius: 22,
                            offset: const Offset(0, 9),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -6),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: selected ? 58 : 44,
                    height: selected ? 58 : 44,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.green100 : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: color, size: selected ? 31 : 27),
                  ),
                  const SizedBox(height: 3),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: selected
                            ? FontWeight.w900
                            : FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
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
