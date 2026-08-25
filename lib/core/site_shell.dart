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
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.42),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return _JobsMenuPanel(
        onClose: () => Navigator.pop(ctx),
        onNavigate: (route) {
          Navigator.pop(ctx);
          Navigator.of(context).pushNamed(route);
        },
        onSignOut: () {
          Navigator.pop(ctx);
          AuthBinding.of(context).logout();
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
        },
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offset, child: child);
    },
  );
}

class _JobsMenuPanel extends StatelessWidget {
  const _JobsMenuPanel({
    required this.onClose,
    required this.onNavigate,
    required this.onSignOut,
  });

  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final panelWidth = width < 560 ? width * 0.86 : 380.0;
    final accountMode =
        AuthBinding.maybeOf(context)?.activeAccountMode ?? 'freelancer';

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: panelWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.16),
                blurRadius: 36,
                offset: const Offset(-12, 0),
              ),
            ],
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Dashboard menu',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    _AppBarIconBox(
                      icon: Icons.menu_open_rounded,
                      color: AppColors.navy,
                      onTap: onClose,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ..._dashboardMenuItemsForMode(accountMode).map(
                  (item) => _JobsMenuTile(
                    item: item,
                    onTap: () => onNavigate(item.route),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 22),
                _JobsMenuTile(
                  item: const _MenuRoute(
                    'Sign out',
                    '/login',
                    Icons.logout_rounded,
                    AppColors.green,
                  ),
                  emphasize: true,
                  onTap: onSignOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JobsMenuTile extends StatelessWidget {
  const _JobsMenuTile({
    required this.item,
    required this.onTap,
    this.emphasize = false,
  });

  final _MenuRoute item;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: item.color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: item.color.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: emphasize ? AppColors.green : AppColors.ink700,
                      fontWeight: emphasize ? FontWeight.w900 : FontWeight.w800,
                      fontSize: 17,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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

Iterable<_MenuRoute> _dashboardMenuItemsForMode(String accountMode) {
  final clientRoutes = {
    '/overview',
    '/jobs',
    '/post-job',
    '/offers-sent',
    '/contracts',
    '/messages',
    '/settings',
  };
  final freelancerRoutes = {
    '/overview',
    '/proposals',
    '/invitations',
    '/offers-received',
    '/contracts',
    '/payouts',
    '/messages',
    '/settings',
  };
  final visibleRoutes = accountMode == 'client'
      ? freelancerRoutes
      : clientRoutes;
  return _dashboardMenuItems.where(
    (item) => visibleRoutes.contains(item.route),
  );
}

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

  static const _clientNavItems = [
    _NavItem('/overview', Icons.home_rounded, 'Dashboard'),
    _NavItem('/jobs', Icons.business_center_outlined, 'My jobs'),
    _NavItem('/post-job', Icons.add_rounded, 'Post a job'),
    _NavItem('/messages', Icons.chat_bubble_rounded, 'Messages'),
    _NavItem('/settings', Icons.settings_rounded, 'Settings'),
  ];

  static const _freelancerNavItems = [
    _NavItem('/overview', Icons.home_rounded, 'Dashboard'),
    _NavItem('/proposals', Icons.article_outlined, 'My proposals'),
    _NavItem('/messages', Icons.chat_bubble_rounded, 'Messages'),
    _NavItem('/settings', Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final accountMode =
        AuthBinding.maybeOf(context)?.activeAccountMode ?? 'freelancer';
    final navItems = accountMode == 'client'
        ? _freelancerNavItems
        : _clientNavItems;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Container(
          height: 72,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
              top: BorderSide(color: AppColors.border.withValues(alpha: 0.55)),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.1),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final item in navItems)
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
    if (currentRoute == route) return;
    Navigator.of(context).pushReplacementNamed(route);
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
    final isCreate = route == '/post-job';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            height: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCreate) ...[
                  Transform.translate(
                    offset: const Offset(0, -4),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green.withValues(alpha: 0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -3),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    width: selected ? 42 : 36,
                    height: selected ? 36 : 34,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.green100 : Colors.transparent,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: color, size: selected ? 23 : 21),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: color,
                        fontSize: 10.5,
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
