import 'package:flutter/material.dart';

import '../../auth/bindings/auth_binding.dart';
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
      DashboardPageKind.myProposals ||
      DashboardPageKind.invitations ||
      DashboardPageKind.offersReceived ||
      DashboardPageKind.offersSent ||
      DashboardPageKind.contracts ||
      DashboardPageKind.payouts ||
      DashboardPageKind.notifications ||
      DashboardPageKind.securitySessions => '/jobs',
      DashboardPageKind.freelancerProfile ||
      DashboardPageKind.clientProfile ||
      DashboardPageKind.postJob => '/create',
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
  const _TopBar({required this.onSignOut, required this.onNotifications});

  final VoidCallback onSignOut;
  final VoidCallback onNotifications;

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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 42,
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
                          ...DashboardPages.navItems.map(
                            (item) => ListTile(
                              leading: Icon(
                                _iconSpec(item.kind).icon,
                                color: _iconSpec(item.kind).color,
                              ),
                              title: Text(
                                item.label,
                                style: const TextStyle(
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
                            leading: const Icon(
                              Icons.logout_rounded,
                              color: AppColors.green,
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
                              onSignOut();
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.07),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 28,
        compact ? 18 : 28,
        compact ? 16 : 28,
        compact ? 24 : 36,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHero(page: page, onSelectPage: onSelectPage),
          SizedBox(height: compact ? 20 : 26),
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
      ),
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
    final spec = _iconSpec(page.kind);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        compact ? 18 : 28,
        compact ? 18 : 24,
        compact ? 16 : 24,
        compact ? 18 : 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [spec.tint.withValues(alpha: 0.72), Colors.white],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: spec.color.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleRow(page: page, onSelectPage: onSelectPage),
                if (page.description != null) ...[
                  SizedBox(height: compact ? 10 : 12),
                  Text(
                    page.description!,
                    style: TextStyle(
                      color: AppColors.ink500,
                      fontSize: compact ? 17 : 20,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 18),
            _HeroIllustration(spec: spec),
          ],
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
            fontSize: compact ? 22 : 26,
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
        padding: EdgeInsets.only(top: compact ? 44 : 72),
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
              fontSize: compact ? 19 : 24,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: compact ? 22 : 26),
          _GreenButton(
            label: 'Connect with Stripe',
            large: true,
            compact: compact,
            onTap: () {},
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
    final compact = MediaQuery.sizeOf(context).width < 560;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '223.178.213.2',
            style: TextStyle(
              color: AppColors.ink700,
              fontSize: compact ? 20 : 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mozilla/5.0 (Linux; Android 10; K)\nAppleWebKit/537.36 (KHTML, like Gecko) Chrome',
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: compact ? 16 : 20,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Last active 2026-08-08 04:34:54',
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: compact ? 15 : 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _OutlineButton(label: 'Revoke', onTap: () {}),
        ],
      ),
    );
  }
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
          const SizedBox(height: 22),
          _Field(
            label: 'Fixed budget',
            suffix: 'USD - if fixed price',
            hint: 'e.g. 500',
            controller: controller.fixedBudgetController,
          ),
          if (compact) ...[
            _Field(
              label: 'Hourly rate min',
              suffix: 'if hourly',
              hint: 'e.g. 800',
              controller: controller.hourlyMinController,
            ),
            _Field(
              label: 'Hourly rate max',
              suffix: 'if hourly',
              hint: 'e.g. 1500',
              controller: controller.hourlyMaxController,
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
                  ),
                ),
                const SizedBox(width: 28),
                Expanded(
                  child: _Field(
                    label: 'Hourly rate max',
                    suffix: 'if hourly',
                    hint: 'e.g. 1500',
                    controller: controller.hourlyMaxController,
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
          const SizedBox(height: 26),
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
          const SizedBox(height: 30),
          Wrap(
            spacing: 18,
            runSpacing: 16,
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
  int? _expandedId;

  @override
  void initState() {
    super.initState();
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
            style: TextStyle(color: AppColors.ink500, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
    int? expandedId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final job in jobs)
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (expandedId == job.id) {
                        expandedId = null;
                      } else {
                        expandedId = job.id;
                      }
                    });
                  },
                  child: ListTile(
                    title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(job.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Text(job.timeAgo),
                  ),
                ),
                if (expandedId == job.id) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${job.category}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text('Type: ${job.projectType}'),
                        const SizedBox(height: 6),
                        if (job.fixedBudget.isNotEmpty) Text('Fixed budget: ${job.fixedBudget}'),
                        if (job.hourlyMin.isNotEmpty || job.hourlyMax.isNotEmpty)
                          Text('Hourly: ${job.hourlyMin} - ${job.hourlyMax}'),
                        const SizedBox(height: 6),
                        Text('Experience: ${job.experienceLevel}'),
                        const SizedBox(height: 6),
                        Text('Duration: ${job.expectedDuration}'),
                        const SizedBox(height: 6),
                        if (job.weeklyHours.isNotEmpty) Text('Weekly hours: ${job.weeklyHours}'),
                        const SizedBox(height: 6),
                        Text('Visibility: ${job.visibility}'),
                        const SizedBox(height: 6),
                        if (job.timezone.isNotEmpty) Text('Timezone: ${job.timezone}'),
                        const SizedBox(height: 10),
                        const Text('Description', style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text(job.description),
                        const SizedBox(height: 10),
                        if (job.skills.isNotEmpty) ...[
                          const Text('Skills', style: TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            children: job.skills.map((s) => Chip(label: Text(s))).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
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
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool optional;
  final String? suffix;
  final int lines;

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
          style: TextStyle(
            color: AppColors.navy,
            fontSize: compact ? 18 : 24,
            fontWeight: FontWeight.w500,
          ),
          decoration: _inputDecoration(hint, compact: compact),
        ),
        const SizedBox(height: 30),
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
          fontSize: compact ? 18 : 24,
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
            fontSize: compact ? 18 : 24,
            fontWeight: FontWeight.w500,
          ),
          decoration: _inputDecoration('', compact: compact),
        ),
        const SizedBox(height: 30),
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
          constraints: const BoxConstraints(maxHeight: 360),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.09),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
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
                      fontSize: compact ? 16 : 22,
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
          fontSize: compact ? 18 : 23,
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
        fontSize: compact ? 18 : 23,
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
      fontSize: compact ? 17 : 23,
      height: 1.3,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: compact ? 18 : 24,
      vertical: compact ? 16 : 20,
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
              fontSize: compact ? 17 : 22,
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
      padding: EdgeInsets.all(compact ? 24 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 22 : 28),
        boxShadow: [
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
            horizontal: compact ? (large ? 26 : 20) : (large ? 42 : 28),
            vertical: compact ? (large ? 15 : 13) : (large ? 20 : 16),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? (large ? 18 : 16) : (large ? 24 : 22),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(large ? 16 : 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(large ? 16 : 14),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: large ? 42 : 28,
            vertical: large ? 20 : 14,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(large ? 16 : 14),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: large ? 24 : 18,
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
