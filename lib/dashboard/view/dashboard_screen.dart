import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../auth/bindings/auth_binding.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../core/site_shell.dart';
import '../../services/job_store.dart';
import '../../home/view/home_screen.dart';
import '../bindings/dashboard_binding.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_page_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.page});

  final DashboardPageModel page;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardPageModel _activePage;

  @override
  void initState() {
    super.initState();
    _activePage = widget.page;
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.kind != widget.page.kind) {
      _activePage = widget.page;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: media.textScaler.clamp(
          minScaleFactor: 0.9,
          maxScaleFactor: 1.0,
        ),
      ),
      child: DashboardBinding(
        key: ValueKey(_activePage.kind),
        page: _activePage,
        child: Builder(
          builder: (context) {
            final controller = DashboardBinding.of(context);
            return ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                final authController = AuthBinding.of(context);
                return Scaffold(
                  backgroundColor: AppColors.cream50,
                  bottomNavigationBar: AppBottomNav(
                    currentRoute: _bottomNavRouteFor(_activePage.kind),
                  ),
                  body: SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                      children: [
                        _TopBar(
                          onSignOut: () => _signOut(context),
                          onNotifications: () =>
                              _selectPage(DashboardPageKind.notifications),
                          accountMode: authController.activeAccountMode,
                        ),
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 260),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final offset = Tween<Offset>(
                              begin: const Offset(0.035, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: offset,
                                child: child,
                              ),
                            );
                          },
                          child: _DashboardBody(
                            key: ValueKey(_activePage.kind),
                            controller: controller,
                            onSelectPage: _selectPage,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _selectPage(DashboardPageKind kind) {
    if (_activePage.kind == kind) return;
    final route = DashboardPages.byKind(kind).route;
    Navigator.of(context).pushNamed(route);
  }

  String _bottomNavRouteFor(DashboardPageKind kind) {
    return switch (kind) {
      DashboardPageKind.overview => '/overview',
      DashboardPageKind.myJobs ||
      DashboardPageKind.offersSent ||
      DashboardPageKind.notifications ||
      DashboardPageKind.securitySessions => '/jobs',
      DashboardPageKind.myProposals ||
      DashboardPageKind.invitations ||
      DashboardPageKind.offersReceived ||
      DashboardPageKind.contracts ||
      DashboardPageKind.payouts => '/proposals',
      DashboardPageKind.freelancerProfile ||
      DashboardPageKind.clientProfile => '/settings',
      DashboardPageKind.postJob => '/post-job',
      DashboardPageKind.messages => '/messages',
    };
  }

  void _signOut(BuildContext context) {
    final controller = AuthBinding.maybeOf(context);
    controller?.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }
}

class DashboardPages {
  static const navItems = [
    DashboardNavItem(
      label: 'Overview',
      route: '/overview',
      kind: DashboardPageKind.overview,
    ),
    DashboardNavItem(
      label: 'My jobs',
      route: '/jobs',
      kind: DashboardPageKind.myJobs,
    ),
    DashboardNavItem(
      label: 'Post a job',
      route: '/post-job',
      kind: DashboardPageKind.postJob,
    ),
    DashboardNavItem(
      label: 'My proposals',
      route: '/proposals',
      kind: DashboardPageKind.myProposals,
    ),
    DashboardNavItem(
      label: 'Invitations',
      route: '/invitations',
      kind: DashboardPageKind.invitations,
    ),
    DashboardNavItem(
      label: 'Offers received',
      route: '/offers-received',
      kind: DashboardPageKind.offersReceived,
    ),
    DashboardNavItem(
      label: 'Offers sent',
      route: '/offers-sent',
      kind: DashboardPageKind.offersSent,
    ),
    DashboardNavItem(
      label: 'Contracts',
      route: '/contracts',
      kind: DashboardPageKind.contracts,
    ),
    DashboardNavItem(
      label: 'Payouts',
      route: '/payouts',
      kind: DashboardPageKind.payouts,
    ),
    DashboardNavItem(
      label: 'Messages',
      route: '/messages',
      kind: DashboardPageKind.messages,
    ),
    DashboardNavItem(
      label: 'Notifications',
      route: '/alerts',
      kind: DashboardPageKind.notifications,
    ),
    DashboardNavItem(
      label: 'Freelancer profile',
      route: '/freelancer-profile',
      kind: DashboardPageKind.freelancerProfile,
    ),
    DashboardNavItem(
      label: 'Client profile',
      route: '/client-profile',
      kind: DashboardPageKind.clientProfile,
    ),
    DashboardNavItem(
      label: 'Security & sessions',
      route: '/security-sessions',
      kind: DashboardPageKind.securitySessions,
    ),
  ];

  static Iterable<DashboardNavItem> navItemsForMode(String accountMode) {
    final clientKinds = {
      DashboardPageKind.overview,
      DashboardPageKind.myJobs,
      DashboardPageKind.postJob,
      DashboardPageKind.offersSent,
      DashboardPageKind.contracts,
      DashboardPageKind.messages,
      DashboardPageKind.notifications,
      DashboardPageKind.clientProfile,
      DashboardPageKind.securitySessions,
    };
    final freelancerKinds = {
      DashboardPageKind.overview,
      DashboardPageKind.myProposals,
      DashboardPageKind.invitations,
      DashboardPageKind.offersReceived,
      DashboardPageKind.contracts,
      DashboardPageKind.payouts,
      DashboardPageKind.messages,
      DashboardPageKind.notifications,
      DashboardPageKind.freelancerProfile,
      DashboardPageKind.securitySessions,
    };
    final visibleKinds = accountMode == 'client'
        ? freelancerKinds
        : clientKinds;
    return navItems.where((item) => visibleKinds.contains(item.kind));
  }

  static DashboardPageModel byKind(DashboardPageKind kind) {
    return switch (kind) {
      DashboardPageKind.overview => const DashboardPageModel(
        kind: DashboardPageKind.overview,
        title: 'Dashboard',
        route: '/overview',
        description: 'Your hiring and freelance workspace at a glance.',
        emptyIcon: Icons.dashboard_outlined,
        emptyTitle: 'Nothing to review yet',
        emptyBody:
            'Your jobs, proposals, contracts, and messages will show up here.',
      ),
      DashboardPageKind.myJobs => const DashboardPageModel(
        kind: DashboardPageKind.myJobs,
        title: 'My jobs',
        route: '/jobs',
        emptyIcon: Icons.assignment_outlined,
        emptyTitle: 'No jobs posted yet',
        emptyBody:
            'Post your first job to start receiving proposals from freelancers.',
        primaryActionLabel: 'Post a job',
      ),
      DashboardPageKind.postJob => const DashboardPageModel(
        kind: DashboardPageKind.postJob,
        title: 'Post a job',
        route: '/post-job',
      ),
      DashboardPageKind.myProposals => const DashboardPageModel(
        kind: DashboardPageKind.myProposals,
        title: 'My proposals',
        route: '/proposals',
        description: "Track the status of every proposal you've submitted.",
        emptyIcon: Icons.edit_note_rounded,
        emptyTitle: 'No proposals yet',
        emptyBody: 'Browse open jobs and submit your first proposal.',
        primaryActionLabel: 'Find work',
      ),
      DashboardPageKind.invitations => const DashboardPageModel(
        kind: DashboardPageKind.invitations,
        title: 'Invitations',
        route: '/invitations',
        description: "Clients who've invited you to apply for their jobs.",
        emptyIcon: Icons.mark_email_unread_outlined,
        emptyTitle: 'No invitations yet',
        emptyBody:
            'Complete your freelancer profile to improve your chances of being invited to jobs.',
        primaryActionLabel: 'Edit profile',
      ),
      DashboardPageKind.offersReceived => const DashboardPageModel(
        kind: DashboardPageKind.offersReceived,
        title: 'Offers received',
        route: '/offers-received',
        emptyIcon: Icons.description_outlined,
        emptyTitle: 'No offers yet',
        emptyBody: 'When a client sends you an offer, it will show up here.',
      ),
      DashboardPageKind.offersSent => const DashboardPageModel(
        kind: DashboardPageKind.offersSent,
        title: 'Offers sent',
        route: '/offers-sent',
        emptyIcon: Icons.description_outlined,
        emptyTitle: 'No offers sent yet',
        emptyBody:
            'Send an offer to a freelancer from their proposal on one of your jobs.',
      ),
      DashboardPageKind.contracts => const DashboardPageModel(
        kind: DashboardPageKind.contracts,
        title: 'Contracts',
        route: '/contracts',
        emptyIcon: Icons.description_outlined,
        emptyTitle: 'No contracts yet',
        emptyBody: 'Contracts are created once an offer is accepted.',
      ),
      DashboardPageKind.payouts => const DashboardPageModel(
        kind: DashboardPageKind.payouts,
        title: 'Payouts',
        route: '/payouts',
        description:
            'Connect a Stripe account so you can be paid when a client releases a milestone.',
      ),
      DashboardPageKind.messages => const DashboardPageModel(
        kind: DashboardPageKind.messages,
        title: 'Messages',
        route: '/messages',
        emptyIcon: Icons.chat_bubble_outline_rounded,
        emptyTitle: 'No conversations yet',
        emptyBody:
            'Conversations start once you connect with a client or freelancer over a proposal or invitation.',
      ),
      DashboardPageKind.notifications => const DashboardPageModel(
        kind: DashboardPageKind.notifications,
        title: 'Notifications',
        route: '/alerts',
        emptyIcon: Icons.notifications_none_rounded,
        emptyTitle: 'Nothing yet',
        emptyBody:
            'Proposal updates, invitations, and new messages will show up here.',
      ),
      DashboardPageKind.freelancerProfile => const DashboardPageModel(
        kind: DashboardPageKind.freelancerProfile,
        title: 'Freelancer profile',
        route: '/freelancer-profile',
        description:
            'This is what clients see when they view your public profile and proposals.',
      ),
      DashboardPageKind.clientProfile => const DashboardPageModel(
        kind: DashboardPageKind.clientProfile,
        title: 'Client profile',
        route: '/client-profile',
      ),
      DashboardPageKind.securitySessions => const DashboardPageModel(
        kind: DashboardPageKind.securitySessions,
        title: 'Security & sessions',
        route: '/security-sessions',
        description:
            "Devices and browsers currently signed in to your account. Revoke anything you don't recognize.",
      ),
    };
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onSignOut,
    required this.onNotifications,
    required this.accountMode,
  });

  final VoidCallback onSignOut;
  final VoidCallback onNotifications;
  final String accountMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final iconSize = compact ? 48.0 : 58.0;
        final horizontal = compact ? 18.0 : 28.0;
        final canPop = Navigator.of(context).canPop();
        return Container(
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
          padding: EdgeInsets.fromLTRB(
            horizontal,
            compact ? 14 : 18,
            horizontal,
            compact ? 14 : 18,
          ),
          child: Row(
            children: [
              if (canPop) ...[
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                    color: AppColors.navy,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              const Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: BrandLockup(compact: true),
                ),
              ),
              _IconBox(
                icon: Icons.notifications_rounded,
                color: AppColors.saffron,
                size: iconSize,
                onTap: onNotifications,
              ),
              SizedBox(width: compact ? 12 : 14),
              _IconBox(
                icon: Icons.menu_rounded,
                color: AppColors.navy,
                size: iconSize,
                onTap: () => _openMenu(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMenu(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return _DashboardMenuPanel(
          accountMode: accountMode,
          onClose: () => Navigator.pop(ctx),
          onNavigate: (route) {
            Navigator.pop(ctx);
            Navigator.of(context).pushNamed(route);
          },
          onSignOut: () {
            Navigator.pop(ctx);
            onSignOut();
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offset =
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}

class _DashboardMenuPanel extends StatelessWidget {
  const _DashboardMenuPanel({
    required this.accountMode,
    required this.onClose,
    required this.onNavigate,
    required this.onSignOut,
  });

  final String accountMode;
  final VoidCallback onClose;
  final ValueChanged<String> onNavigate;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final panelWidth = width < 560 ? width * 0.86 : 380.0;

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
                    _IconBox(
                      icon: Icons.menu_open_rounded,
                      color: AppColors.navy,
                      size: 46,
                      onTap: onClose,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ...DashboardPages.navItemsForMode(accountMode).map((item) {
                  final spec = _iconSpec(item.kind);
                  return _DashboardMenuTile(
                    icon: spec.icon,
                    color: spec.color,
                    label: item.label,
                    onTap: () => onNavigate(item.route),
                  );
                }),
                const SizedBox(height: 10),
                const Divider(height: 22),
                _DashboardMenuTile(
                  icon: Icons.logout_rounded,
                  color: AppColors.green,
                  label: 'Sign out',
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

class _DashboardMenuTile extends StatelessWidget {
  const _DashboardMenuTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
    this.emphasize = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: color.withValues(alpha: 0.06),
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
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
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

class _DashboardIconSpec {
  const _DashboardIconSpec({
    required this.icon,
    required this.color,
    required this.tint,
  });

  final IconData icon;
  final Color color;
  final Color tint;
}

_DashboardIconSpec _iconSpec(DashboardPageKind kind) {
  return switch (kind) {
    DashboardPageKind.overview => const _DashboardIconSpec(
      icon: Icons.dashboard_customize_rounded,
      color: Color(0xff12a848),
      tint: Color(0xffe7f8ee),
    ),
    DashboardPageKind.myJobs => const _DashboardIconSpec(
      icon: Icons.business_center_outlined,
      color: Color(0xff1688d8),
      tint: Color(0xffe5f2ff),
    ),
    DashboardPageKind.postJob => const _DashboardIconSpec(
      icon: Icons.edit_square,
      color: Color(0xff16a653),
      tint: Color(0xffe4f6ea),
    ),
    DashboardPageKind.myProposals => const _DashboardIconSpec(
      icon: Icons.article_outlined,
      color: Color(0xff9146d8),
      tint: Color(0xfff2e6ff),
    ),
    DashboardPageKind.invitations => const _DashboardIconSpec(
      icon: Icons.mail_outline_rounded,
      color: Color(0xfff47b00),
      tint: Color(0xffffeedc),
    ),
    DashboardPageKind.offersReceived => const _DashboardIconSpec(
      icon: Icons.card_giftcard_rounded,
      color: Color(0xff2196df),
      tint: Color(0xffe5f3ff),
    ),
    DashboardPageKind.offersSent => const _DashboardIconSpec(
      icon: Icons.near_me_outlined,
      color: Color(0xff13a456),
      tint: Color(0xffe3f7ec),
    ),
    DashboardPageKind.contracts => const _DashboardIconSpec(
      icon: Icons.description_outlined,
      color: Color(0xff1688d8),
      tint: Color(0xffe5f2ff),
    ),
    DashboardPageKind.payouts => const _DashboardIconSpec(
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xff9146d8),
      tint: Color(0xfff3e7ff),
    ),
    DashboardPageKind.messages => const _DashboardIconSpec(
      icon: Icons.chat_bubble_outline_rounded,
      color: Color(0xfff47b00),
      tint: Color(0xffffefdf),
    ),
    DashboardPageKind.notifications => const _DashboardIconSpec(
      icon: Icons.notifications_none_rounded,
      color: Color(0xffef4662),
      tint: Color(0xffffe8ed),
    ),
    DashboardPageKind.freelancerProfile => const _DashboardIconSpec(
      icon: Icons.person_outline_rounded,
      color: Color(0xff11a9a5),
      tint: Color(0xffe4f7f6),
    ),
    DashboardPageKind.clientProfile => const _DashboardIconSpec(
      icon: Icons.apartment_rounded,
      color: Color(0xff13aaa4),
      tint: Color(0xffe2f7f5),
    ),
    DashboardPageKind.securitySessions => const _DashboardIconSpec(
      icon: Icons.shield_outlined,
      color: Color(0xff9146d8),
      tint: Color(0xfff3e7ff),
    ),
  };
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    super.key,
    required this.controller,
    required this.onSelectPage,
  });

  final DashboardController controller;
  final ValueChanged<DashboardPageKind> onSelectPage;

  @override
  Widget build(BuildContext context) {
    final page = controller.page;
    final compact = MediaQuery.sizeOf(context).width < 560;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageHero(page: page, onSelectPage: onSelectPage),
        SizedBox(height: compact ? 14 : 26),
        switch (page.kind) {
          DashboardPageKind.myJobs => _MyJobsList(),
          DashboardPageKind.postJob => _PostJobForm(controller: controller),
          DashboardPageKind.payouts => const _PayoutsPanel(),
          DashboardPageKind.freelancerProfile => _FreelancerProfileForm(
            controller: controller,
          ),
          DashboardPageKind.clientProfile => _ClientProfileForm(
            controller: controller,
          ),
          DashboardPageKind.securitySessions => const _SecurityPanel(),
          _ => _EmptyState(page: page, onSelectPage: onSelectPage),
        },
      ],
    );

    if (compact) return content;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
      child: content,
    );
  }
}

class _PageHero extends StatelessWidget {
  const _PageHero({required this.page, required this.onSelectPage});

  final DashboardPageModel page;
  final ValueChanged<DashboardPageKind> onSelectPage;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;

    if (page.kind == DashboardPageKind.payouts) {
      final spec = _iconSpec(page.kind);
      return _DashboardPageHeading(page: page, spec: spec);
    }

    final spec = _iconSpec(page.kind);
    if (compact) {
      return _DashboardPageHeading(page: page, spec: spec);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [spec.tint.withValues(alpha: 0.72), Colors.white],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: spec.color.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 24, 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleRow(page: page, onSelectPage: onSelectPage),
                  if (page.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      page.description!,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 20,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 18),
            _HeroIllustration(spec: spec),
          ],
        ),
      ),
    );
  }
}

class _DashboardPageHeading extends StatelessWidget {
  const _DashboardPageHeading({required this.page, required this.spec});

  final DashboardPageModel page;
  final _DashboardIconSpec spec;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 18,
        vertical: compact ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 14 : 18),
        border: Border.all(color: spec.color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 34 : 40,
            height: compact ? 34 : 40,
            decoration: BoxDecoration(
              color: spec.tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(spec.icon, color: spec.color, size: compact ? 18 : 22),
          ),
          SizedBox(width: compact ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: compact ? 18 : 22,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (page.description != null && !compact) ...[
                  const SizedBox(height: 6),
                  Text(
                    page.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink500,
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.spec});

  final _DashboardIconSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142,
      height: 102,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 18,
            bottom: 16,
            child: Icon(
              Icons.bar_chart_rounded,
              size: 48,
              color: spec.color.withValues(alpha: 0.62),
            ),
          ),
          Positioned(
            left: 22,
            top: 22,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: spec.color,
              child: const Icon(
                Icons.pie_chart_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 18,
            child: Icon(
              Icons.spa_rounded,
              size: 30,
              color: AppColors.green.withValues(alpha: 0.38),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.page, required this.onSelectPage});

  final DashboardPageModel page;
  final ValueChanged<DashboardPageKind> onSelectPage;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          page.title,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: compact ? 18 : 26,
            height: 1.05,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.page, required this.onSelectPage});

  final DashboardPageModel page;
  final ValueChanged<DashboardPageKind> onSelectPage;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: compact ? 34 : 72),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              _SoftIcon(icon: page.emptyIcon ?? Icons.inbox_outlined),
              SizedBox(height: compact ? 20 : 28),
              Text(
                page.emptyTitle ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: compact ? 18 : 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: compact ? 14 : 18),
              Text(
                page.emptyBody ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ink500,
                  fontSize: compact ? 15 : 16,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (page.primaryActionLabel != null) ...[
                SizedBox(height: compact ? 30 : 42),
                _GreenButton(
                  label: page.primaryActionLabel!,
                  large: true,
                  compact: compact,
                  onTap: () {
                    if (page.primaryActionLabel == 'Post a job') {
                      onSelectPage(DashboardPageKind.postJob);
                    } else if (page.primaryActionLabel == 'Edit profile') {
                      onSelectPage(DashboardPageKind.freelancerProfile);
                    } else {
                      onSelectPage(DashboardPageKind.myJobs);
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PayoutsPanel extends StatelessWidget {
  const _PayoutsPanel();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You haven't connected a payout account yet.",
            style: TextStyle(
              color: AppColors.ink700,
              fontSize: compact ? 17 : 20,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: compact ? 14 : 18),
          // compact connect button but ensure full text fits by scaling down if needed
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(12),
              elevation: 6,
              shadowColor: AppColors.green.withValues(alpha: 0.28),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 18 : 22,
                    vertical: compact ? 10 : 12,
                  ),
                  constraints: BoxConstraints(minWidth: compact ? 160 : 200),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Connect with Stripe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 16 : 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityPanel extends StatelessWidget {
  const _SecurityPanel();

  @override
  Widget build(BuildContext context) {
    final authController = AuthBinding.of(context);
    final compact = MediaQuery.sizeOf(context).width < 560;
    final sessions = authController.sessions;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active sessions',
            style: TextStyle(
              color: AppColors.ink700,
              fontSize: compact ? 20 : 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sessions.isEmpty
                ? 'Sign in to create a device session for this account.'
                : 'Review browsers and devices currently signed in to your account.',
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: compact ? 15 : 17,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          if (sessions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cream50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Text(
                'No active sessions found.',
                style: TextStyle(
                  color: AppColors.ink500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else ...[
            for (final session in sessions) ...[
              _SessionTile(
                session: session,
                onRevoke: () {
                  authController.revokeSession(session.id);
                  if (!authController.isLoggedIn && context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (_) => false);
                  }
                },
              ),
              if (session != sessions.last) const SizedBox(height: 14),
            ],
            if (sessions.length > 1) ...[
              const SizedBox(height: 22),
              _OutlineButton(
                label: 'Revoke other sessions',
                onTap: authController.revokeOtherSessions,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session, required this.onRevoke});

  final UserSession session;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 16 : 20),
      decoration: BoxDecoration(
        color: session.isCurrent ? AppColors.green100 : AppColors.cream50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: session.isCurrent
              ? AppColors.green.withValues(alpha: 0.28)
              : AppColors.cardBorder,
        ),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SessionTileDetails(session: session),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _OutlineButton(
                    label: session.isCurrent ? 'Sign out' : 'Revoke',
                    onTap: onRevoke,
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _SessionTileDetails(session: session)),
                const SizedBox(width: 20),
                _OutlineButton(
                  label: session.isCurrent ? 'Sign out' : 'Revoke',
                  onTap: onRevoke,
                ),
              ],
            ),
    );
  }
}

class _SessionTileDetails extends StatelessWidget {
  const _SessionTileDetails({required this.session});

  final UserSession session;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              session.device,
              style: TextStyle(
                color: AppColors.navy,
                fontSize: compact ? 17 : 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (session.isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.25),
                  ),
                ),
                child: const Text(
                  'Current',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          session.ipAddress,
          style: TextStyle(
            color: AppColors.ink500,
            fontSize: compact ? 14 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Last active ${_formatSessionTime(session.lastActiveAt)}',
          style: TextStyle(
            color: AppColors.ink500,
            fontSize: compact ? 13 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

String _formatSessionTime(DateTime value) {
  String twoDigits(int number) => number.toString().padLeft(2, '0');
  return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
      '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
}

class _PostJobForm extends StatelessWidget {
  const _PostJobForm({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: 'Job title',
            hint: 'e.g. Build a responsive React dashboard',
            controller: controller.jobTitleController,
          ),
          _SelectField(
            label: 'Category',
            value: controller.jobCategory,
            values: const [
              'Select a category',
              'Development & IT',
              'Design & Creative',
              'Writing',
              'Business Consulting',
            ],
            onChanged: (value) => controller.setValue('jobCategory', value),
          ),
          _Field(
            label: 'Description',
            hint:
                'Describe the work, goals, and any context a freelancer needs to scope it accurately.',
            controller: controller.jobDescriptionController,
            lines: 5,
          ),
          _Field(
            label: 'Deliverables',
            optional: true,
            hint:
                'What should be handed over when the work is done? What would you consider a completed project?',
            controller: controller.deliverablesController,
            lines: 3,
          ),
          const _SectionLabel('Project type'),
          Wrap(
            spacing: 22,
            runSpacing: 10,
            children: [
              _RadioChoice(
                label: 'Fixed price',
                value: 'Fixed price',
                groupValue: controller.projectType,
                onChanged: controller.setProjectType,
              ),
              _RadioChoice(
                label: 'Hourly',
                value: 'Hourly',
                groupValue: controller.projectType,
                onChanged: controller.setProjectType,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Field(
            label: 'Fixed budget',
            suffix: 'USD - if fixed price',
            hint: 'e.g. 500',
            controller: controller.fixedBudgetController,
            digitsOnly: true,
          ),
          if (compact) ...[
            _Field(
              label: 'Hourly rate min',
              suffix: 'if hourly',
              hint: 'e.g. 800',
              controller: controller.hourlyMinController,
              digitsOnly: true,
            ),
            _Field(
              label: 'Hourly rate max',
              suffix: 'if hourly',
              hint: 'e.g. 1500',
              controller: controller.hourlyMaxController,
              digitsOnly: true,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Hourly rate min',
                    suffix: 'if hourly',
                    hint: 'e.g. 800',
                    controller: controller.hourlyMinController,
                    digitsOnly: true,
                  ),
                ),
                const SizedBox(width: 28),
                Expanded(
                  child: _Field(
                    label: 'Hourly rate max',
                    suffix: 'if hourly',
                    hint: 'e.g. 1500',
                    controller: controller.hourlyMaxController,
                    digitsOnly: true,
                  ),
                ),
              ],
            ),
          _SelectField(
            label: 'Experience level',
            value: controller.experienceLevel,
            values: const ['Entry level', 'Intermediate', 'Expert'],
            onChanged: (value) => controller.setValue('experienceLevel', value),
          ),
          _SelectField(
            label: 'Expected duration',
            optional: true,
            value: controller.expectedDuration,
            values: const [
              'Not sure yet',
              'Less than 1 month',
              '1-3 months',
              '3-6 months',
            ],
            onChanged: (value) =>
                controller.setValue('expectedDuration', value),
          ),
          _Field(
            label: 'Weekly hours',
            optional: true,
            hint: 'e.g. 20',
            controller: controller.weeklyHoursController,
            digitsOnly: true,
          ),
          _SelectField(
            label: 'Freelancer location',
            value: controller.freelancerLocation,
            values: const ['Anywhere', 'India', 'United States', 'Remote only'],
            onChanged: (value) =>
                controller.setValue('freelancerLocation', value),
          ),
          _Field(
            label: 'Timezone requirement',
            suffix: 'if applicable',
            hint: 'e.g. IST +/- 2 hours',
            controller: controller.timezoneController,
          ),
          _SelectField(
            label: 'Visibility',
            value: controller.visibility,
            values: const [
              'Public - listed in search',
              'Private - invite only',
            ],
            onChanged: (value) => controller.setValue('visibility', value),
          ),
          _SkillsBox(
            title: 'Skills needed',
            skills: _allSkills,
            selected: controller.selectedJobSkills,
            onChanged: controller.toggleJobSkill,
          ),
          const SizedBox(height: 18),
          _Field(
            label: 'Screening questions',
            suffix: 'optional - up to 3',
            hint: 'Question 1',
            controller: controller.questionOneController,
          ),
          _BareField(
            hint: 'Question 2',
            controller: controller.questionTwoController,
          ),
          _BareField(
            hint: 'Question 3',
            controller: controller.questionThreeController,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _OutlineButton(label: 'Save as draft', large: true, onTap: () {}),
              _GreenButton(
                label: 'Publish job',
                large: true,
                compact: compact,
                onTap: () {
                  final title = controller.jobTitleController.text.trim();
                  final desc = controller.jobDescriptionController.text.trim();
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a job title')),
                    );
                    return;
                  }
                  final id = DateTime.now().millisecondsSinceEpoch;
                  final job = PostedJob(
                    id: id,
                    title: title,
                    description: desc,
                    deliverables: controller.deliverablesController.text.trim(),
                    timeAgo: 'Just now',
                    location: controller.freelancerLocation,
                    category: controller.jobCategory,
                    projectType: controller.projectType,
                    fixedBudget: controller.fixedBudgetController.text.trim(),
                    hourlyMin: controller.hourlyMinController.text.trim(),
                    hourlyMax: controller.hourlyMaxController.text.trim(),
                    experienceLevel: controller.experienceLevel,
                    expectedDuration: controller.expectedDuration,
                    weeklyHours: controller.weeklyHoursController.text.trim(),
                    visibility: controller.visibility,
                    timezone: controller.timezoneController.text.trim(),
                    skills: controller.selectedJobSkills.toList(),
                    questionOne: controller.questionOneController.text.trim(),
                    questionTwo: controller.questionTwoController.text.trim(),
                    questionThree: controller.questionThreeController.text
                        .trim(),
                  );
                  JobStore.instance.addJob(job);
                  Navigator.of(context).pushReplacementNamed('/jobs');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyJobsList extends StatefulWidget {
  const _MyJobsList();

  @override
  State<_MyJobsList> createState() => _MyJobsListState();
}

class _MyJobsListState extends State<_MyJobsList> {
  @override
  void initState() {
    super.initState();
    JobStore.instance.load();
    JobStore.instance.addListener(_onJobsChanged);
  }

  @override
  void dispose() {
    JobStore.instance.removeListener(_onJobsChanged);
    super.dispose();
  }

  void _onJobsChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final jobs = JobStore.instance.jobs;
    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 56.0),
          child: Text(
            'No jobs posted yet',
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final job in jobs)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        job.title,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 18,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      job.timeAgo,
                      style: TextStyle(
                        color: AppColors.ink500,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _JobInfoPill(label: 'Category', value: job.category),
                    _JobInfoPill(label: 'Type', value: job.projectType),
                    _JobInfoPill(label: 'Location', value: job.location),
                    _JobInfoPill(label: 'Visibility', value: job.visibility),
                  ],
                ),
                const SizedBox(height: 14),
                _JobDetailGrid(
                  items: [
                    _JobDetailItem('Fixed budget', job.fixedBudget),
                    _JobDetailItem(
                      'Hourly rate',
                      _formatHourlyRate(job.hourlyMin, job.hourlyMax),
                    ),
                    _JobDetailItem('Experience', job.experienceLevel),
                    _JobDetailItem('Expected duration', job.expectedDuration),
                    _JobDetailItem('Weekly hours', job.weeklyHours),
                    _JobDetailItem('Timezone', job.timezone),
                  ],
                ),
                const SizedBox(height: 14),
                _JobTextSection(title: 'Description', text: job.description),
                const SizedBox(height: 12),
                _JobTextSection(title: 'Deliverables', text: job.deliverables),
                const SizedBox(height: 12),
                const Text(
                  'Skills needed',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                if (job.skills.isEmpty)
                  Text(
                    'Not provided',
                    style: TextStyle(color: AppColors.ink500),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.skills
                        .map(
                          (skill) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greenSoft,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.green.withValues(alpha: 0.08),
                              ),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                color: AppColors.ink700,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 12),
                const Text(
                  'Screening questions',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                _ScreeningQuestion(number: 1, text: job.questionOne),
                _ScreeningQuestion(number: 2, text: job.questionTwo),
                _ScreeningQuestion(number: 3, text: job.questionThree),
              ],
            ),
          ),
      ],
    );
  }

  String _formatHourlyRate(String min, String max) {
    final cleanMin = min.trim();
    final cleanMax = max.trim();
    if (cleanMin.isEmpty && cleanMax.isEmpty) return '';
    if (cleanMin.isEmpty) return 'Up to $cleanMax';
    if (cleanMax.isEmpty) return 'From $cleanMin';
    return '$cleanMin - $cleanMax';
  }
}

class _JobInfoPill extends StatelessWidget {
  const _JobInfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final displayValue = _displayValue(value);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.greenSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          '$label: $displayValue',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _JobDetailGrid extends StatelessWidget {
  const _JobDetailGrid({required this.items});

  final List<_JobDetailItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 620;
        final itemWidth = compact
            ? (constraints.maxWidth - 10) / 2
            : (constraints.maxWidth - 16) / 2;
        return Wrap(
          spacing: compact ? 10 : 16,
          runSpacing: compact ? 10 : 14,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xfff8faf9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xffe3e7e4)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(compact ? 10 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            color: AppColors.ink500,
                            fontSize: compact ? 11 : 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _displayValue(item.value),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.ink700,
                            fontSize: compact ? 13 : 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _JobDetailItem {
  const _JobDetailItem(this.label, this.value);

  final String label;
  final String value;
}

class _JobTextSection extends StatelessWidget {
  const _JobTextSection({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(
          _displayValue(text),
          style: TextStyle(
            color: text.trim().isEmpty ? AppColors.ink500 : AppColors.ink700,
          ),
        ),
      ],
    );
  }
}

class _ScreeningQuestion extends StatelessWidget {
  const _ScreeningQuestion({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        'Q$number: ${_displayValue(text)}',
        style: TextStyle(
          color: text.trim().isEmpty ? AppColors.ink500 : AppColors.ink700,
        ),
      ),
    );
  }
}

String _displayValue(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed == 'Select a category') {
    return 'Not provided';
  }
  return trimmed;
}

class _FreelancerProfileForm extends StatelessWidget {
  const _FreelancerProfileForm({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Column(
      children: [
        _Card(
          child: Wrap(
            spacing: 24,
            runSpacing: 22,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: compact ? 58 : 76,
                backgroundColor: Color(0xffef6c00),
                child: Text(
                  'CU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 46 : 62,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              _OutlineButton(label: 'Change picture', onTap: () {}),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Field(
                label: 'Profile Name',
                hint: 'Creative UI/UX Designer',
                controller: controller.freelancerNameController,
              ),
              _Field(
                label: 'Professional title',
                hint: 'e.g. Full-Stack PHP Developer',
                controller: controller.professionalTitleController,
              ),
              _Field(
                label: 'Overview',
                hint:
                    'Tell clients about your experience and what you can help with.',
                controller: controller.freelancerOverviewController,
                lines: 5,
              ),
              _Field(
                label: 'Hourly rate',
                suffix: 'USD',
                hint: 'e.g. 1200',
                controller: controller.hourlyRateController,
              ),
              _Field(
                label: 'Weekly capacity',
                suffix: 'hours',
                hint: 'e.g. 30',
                controller: controller.weeklyCapacityController,
              ),
              _SelectField(
                label: 'Availability',
                value: controller.availability,
                values: const [
                  'Available now',
                  'Available next week',
                  'Not available',
                ],
                onChanged: (value) =>
                    controller.setValue('availability', value),
              ),
              _SelectField(
                label: 'Preferred project size',
                value: controller.preferredProjectSize,
                values: const ['Any', 'Small', 'Medium', 'Large'],
                onChanged: (value) =>
                    controller.setValue('preferredProjectSize', value),
              ),
              _SelectField(
                label: 'Primary category',
                value: controller.primaryCategory,
                values: const [
                  'Select a category',
                  'Design & Creative',
                  'Development & IT',
                  'Writing',
                ],
                onChanged: (value) =>
                    controller.setValue('primaryCategory', value),
              ),
              _SkillsBox(
                title: 'Skills',
                skills: _allSkills,
                selected: controller.selectedFreelancerSkills,
                onChanged: controller.toggleFreelancerSkill,
              ),
              const SizedBox(height: 30),
              _GreenButton(
                label: 'Save profile',
                large: true,
                compact: compact,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClientProfileForm extends StatelessWidget {
  const _ClientProfileForm({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: 'Profile Name',
            hint: 'app',
            controller: controller.clientProfileNameController,
          ),
          _Field(
            label: 'Company name',
            optional: true,
            hint: 'e.g. Acme Retail Pvt Ltd',
            controller: controller.companyNameController,
          ),
          _Field(
            label: 'Website',
            optional: true,
            hint: 'https://example.com',
            controller: controller.websiteController,
          ),
          _Field(
            label: 'Industry',
            optional: true,
            hint: 'e.g. E-commerce',
            controller: controller.industryController,
          ),
          _SelectField(
            label: 'Company size',
            optional: true,
            value: controller.companySize,
            values: const ['Select one', '1', '2-10', '11-50', '51-200'],
            onChanged: (value) => controller.setValue('companySize', value),
          ),
          _Field(
            label: 'About',
            optional: true,
            hint: 'What does your company do?',
            controller: controller.clientAboutController,
            lines: 5,
          ),
          const SizedBox(height: 30),
          _GreenButton(
            label: 'Save profile',
            large: true,
            compact: compact,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.optional = false,
    this.suffix,
    this.lines = 1,
    this.digitsOnly = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool optional;
  final String? suffix;
  final int lines;
  final bool digitsOnly;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label: label, optional: optional, suffix: suffix),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          minLines: lines,
          maxLines: lines,
          keyboardType: digitsOnly ? TextInputType.number : null,
          inputFormatters: digitsOnly
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: compact ? 15.5 : 24,
            fontWeight: FontWeight.w500,
          ),
          decoration: _inputDecoration(hint, compact: compact),
        ),
        SizedBox(height: compact ? 18 : 30),
      ],
    );
  }
}

class _BareField extends StatelessWidget {
  const _BareField({required this.hint, required this.controller});

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.navy,
          fontSize: compact ? 15.5 : 24,
          fontWeight: FontWeight.w500,
        ),
        decoration: _inputDecoration(hint, compact: compact),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label: label, optional: optional),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: values
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: TextStyle(
            color: AppColors.navy,
            fontSize: compact ? 15.5 : 24,
            fontWeight: FontWeight.w500,
          ),
          decoration: _inputDecoration('', compact: compact),
        ),
        SizedBox(height: compact ? 18 : 30),
      ],
    );
  }
}

class _SkillsBox extends StatelessWidget {
  const _SkillsBox({
    required this.title,
    required this.skills,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final List<String> skills;
  final Set<String> selected;
  final void Function(String, bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(title),
        const SizedBox(height: 10),
        Container(
          constraints: BoxConstraints(maxHeight: compact ? 280 : 360),
          padding: EdgeInsets.symmetric(vertical: compact ? 6 : 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(compact ? 14 : 28),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final skill in skills)
                CheckboxListTile(
                  value: selected.contains(skill),
                  onChanged: (value) => onChanged(skill, value),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.green,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  title: Text(
                    skill,
                    style: TextStyle(
                      color: AppColors.ink700,
                      fontSize: compact ? 14.5 : 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, this.optional = false, this.suffix});

  final String label;
  final bool optional;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          color: AppColors.navy,
          fontSize: compact ? 15.5 : 23,
          fontWeight: FontWeight.w900,
        ),
        children: [
          if (optional || suffix != null)
            TextSpan(
              text: ' (${suffix ?? 'optional'})',
              style: const TextStyle(
                color: AppColors.ink300,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Text(
      text,
      style: TextStyle(
        color: AppColors.navy,
        fontSize: compact ? 15.5 : 23,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint, {required bool compact}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Color(0xff8d8f95),
      fontSize: compact ? 15 : 23,
      height: 1.3,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: compact ? 14 : 24,
      vertical: compact ? 13 : 20,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.green, width: 2),
    ),
  );
}

class _RadioChoice extends StatelessWidget {
  const _RadioChoice({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return InkWell(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: groupValue == value ? AppColors.green : AppColors.ink300,
                width: 2,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: groupValue == value
                    ? AppColors.green
                    : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: AppColors.ink700,
              fontSize: compact ? 15 : 22,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return CircleAvatar(
      radius: compact ? 38 : 46,
      backgroundColor: AppColors.green100,
      child: Icon(icon, size: compact ? 34 : 42, color: AppColors.saffron),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 16 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 16 : 28),
        border: compact ? Border.all(color: AppColors.cardBorder) : null,
        boxShadow: compact
            ? null
            : [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
      ),
      child: child,
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 64,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: AppColors.navy.withValues(alpha: 0.12),
        child: IconButton(
          icon: Icon(icon, size: size * 0.46),
          color: color,
          onPressed: onTap,
        ),
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  const _GreenButton({
    required this.label,
    required this.onTap,
    this.large = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool large;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.green,
      borderRadius: BorderRadius.circular(large ? 16 : 14),
      elevation: 8,
      shadowColor: AppColors.green.withValues(alpha: 0.32),
      child: InkWell(
        borderRadius: BorderRadius.circular(large ? 16 : 14),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? (large ? 20 : 18) : (large ? 42 : 28),
            vertical: compact ? (large ? 12 : 11) : (large ? 20 : 16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? (large ? 15.5 : 15) : (large ? 24 : 22),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.onTap,
    this.large = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 560;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(large ? 16 : 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(large ? 16 : 14),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? (large ? 20 : 18) : (large ? 42 : 28),
            vertical: compact ? (large ? 12 : 11) : (large ? 20 : 14),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(large ? 16 : 14),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: compact ? (large ? 15.5 : 15) : (large ? 24 : 18),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

const _allSkills = [
  '3D Modeling',
  'Animation',
  'AutoCAD',
  'BIM',
  'Bookkeeping',
  'Brand Identity',
  'Business Strategy',
  'Civil Engineering',
  'Community Management',
  'Compliance',
  'Computer Vision',
  'Content Marketing',
  'Content Writing',
  'Contract Drafting',
  'Copywriting',
  'Email Marketing',
  'Financial Analysis',
  'Graphic Design',
  'Growth Strategy',
  'GST Compliance',
  'HR Policy',
  'Illustration',
  'IP Law',
  'JavaScript',
  'Learning & Development',
  'Legal Research',
  'Machine Learning',
  'Management Consulting',
  'Market Research',
  'Mobile App Development',
  'Technical Writing',
  'Translation',
  'UI/UX Design',
  'Video Editing',
  'Virtual Assistance',
  'Voice Over',
  'WordPress',
];
