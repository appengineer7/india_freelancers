import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';
import '../bindings/alerts_binding.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertsBinding(
      child: _AlertsFeedView(),
    );
  }
}

class _AlertsFeedView extends StatefulWidget {
  const _AlertsFeedView();

  @override
  State<_AlertsFeedView> createState() => _AlertsFeedViewState();
}

class _AlertsFeedViewState extends State<_AlertsFeedView> {
  String _activeTab = 'All Activity'; // All Activity, Job Alerts, Security, Payments
  final Set<int> _readAlertIds = {3};

  void _markAllAsRead() {
    setState(() {
      for (final alert in _mockAlerts) {
        _readAlertIds.add(alert.id);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppColors.saffron,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleReadStatus(int id) {
    setState(() {
      if (_readAlertIds.contains(id)) {
        _readAlertIds.remove(id);
      } else {
        _readAlertIds.add(id);
      }
    });
  }

  List<_AlertModel> get _filteredAlerts {
    return _mockAlerts.where((alert) {
      if (_activeTab == 'Job Alerts' && alert.category != AlertCategory.job) {
        return false;
      }
      if (_activeTab == 'Security' && alert.category != AlertCategory.security) {
        return false;
      }
      if (_activeTab == 'Payments' && alert.category != AlertCategory.payment) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _filteredAlerts;
    final unreadCount = _mockAlerts.where((a) => !_readAlertIds.contains(a.id)).length;

    final todayAlerts = alerts.where((a) => a.section == 'Today').toList();
    final yesterdayAlerts = alerts.where((a) => a.section == 'Yesterday').toList();
    final earlierAlerts = alerts.where((a) => a.section == 'Earlier').toList();

    return AppScaffold(
      currentRoute: '/alerts',
      body: Container(
        color: const Color(0xfff8f9fa),
        child: Column(
          children: [
            // Top Header & Category Tabs Container
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Responsive Header Row (No RenderFlex Overflow)
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Flexible(
                              child: Text(
                                'Alerts & Notifications',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.navy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (unreadCount > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.saffron,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$unreadCount New',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _markAllAsRead,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.done_all_rounded, size: 16, color: AppColors.saffron),
                            SizedBox(width: 4),
                            Text(
                              'Mark all as read',
                              style: TextStyle(
                                color: AppColors.saffron,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tabs Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        'All Activity',
                        'Job Alerts',
                        'Security',
                        'Payments',
                      ].map((tab) {
                        final isActive = _activeTab == tab;
                        return GestureDetector(
                          onTap: () => setState(() => _activeTab = tab),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.saffron : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isActive ? AppColors.saffron : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isActive ? Colors.white : AppColors.ink700,
                                fontSize: 13,
                                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),

            // Alerts List (Only renders section header when section has item!)
            Expanded(
              child: alerts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'No notifications in this category',
                              style: TextStyle(
                                color: AppColors.ink500,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      children: [
                        if (todayAlerts.isNotEmpty) ...[
                          _buildSectionHeader('Today'),
                          ...todayAlerts.map((a) => _AlertCardContainer(
                                alert: a,
                                isRead: _readAlertIds.contains(a.id),
                                onToggleRead: () => _toggleReadStatus(a.id),
                              )),
                          const SizedBox(height: 12),
                        ],
                        if (yesterdayAlerts.isNotEmpty) ...[
                          _buildSectionHeader('Yesterday'),
                          ...yesterdayAlerts.map((a) => _AlertCardContainer(
                                alert: a,
                                isRead: _readAlertIds.contains(a.id),
                                onToggleRead: () => _toggleReadStatus(a.id),
                              )),
                          const SizedBox(height: 12),
                        ],
                        if (earlierAlerts.isNotEmpty) ...[
                          _buildSectionHeader('Earlier'),
                          ...earlierAlerts.map((a) => _AlertCardContainer(
                                alert: a,
                                isRead: _readAlertIds.contains(a.id),
                                onToggleRead: () => _toggleReadStatus(a.id),
                              )),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AlertCardContainer extends StatelessWidget {
  const _AlertCardContainer({
    required this.alert,
    required this.isRead,
    required this.onToggleRead,
  });

  final _AlertModel alert;
  final bool isRead;
  final VoidCallback onToggleRead;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(alert.category);
    final categoryIcon = _getCategoryIcon(alert.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xfff5faf6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? AppColors.cardBorder : AppColors.green.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onToggleRead,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon Avatar Circle Container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Main Alert Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 14.5,
                                fontWeight: isRead ? FontWeight.w700 : FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            alert.time,
                            style: const TextStyle(
                              color: AppColors.ink500,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: alert.spans,
                        ),
                        style: const TextStyle(
                          color: AppColors.ink700,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                      if (alert.actionLabel != null) ...[
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening ${alert.actionLabel}...'),
                                backgroundColor: AppColors.green,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.green,
                            side: const BorderSide(color: AppColors.green),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            alert.actionLabel!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Unread Indicator Dot
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(AlertCategory category) {
    switch (category) {
      case AlertCategory.job:
        return AppColors.green;
      case AlertCategory.security:
        return Colors.orange.shade800;
      case AlertCategory.payment:
        return Colors.blue.shade700;
      case AlertCategory.general:
        return AppColors.navy;
    }
  }

  IconData _getCategoryIcon(AlertCategory category) {
    switch (category) {
      case AlertCategory.job:
        return Icons.work_outline_rounded;
      case AlertCategory.security:
        return Icons.shield_outlined;
      case AlertCategory.payment:
        return Icons.account_balance_wallet_outlined;
      case AlertCategory.general:
        return Icons.notifications_none_rounded;
    }
  }
}

enum AlertCategory { job, security, payment, general }

class _AlertModel {
  const _AlertModel({
    required this.id,
    required this.section,
    required this.title,
    required this.spans,
    required this.time,
    required this.category,
    this.actionLabel,
  });

  final int id;
  final String section;
  final String title;
  final List<TextSpan> spans;
  final String time;
  final AlertCategory category;
  final String? actionLabel;
}

final List<_AlertModel> _mockAlerts = [
  _AlertModel(
    id: 1,
    section: 'Today',
    title: 'Top Applicant Selection',
    category: AlertCategory.job,
    time: '2 hours ago',
    actionLabel: 'Review Proposal',
    spans: const [
      TextSpan(text: 'You have been shortlisted as a top applicant for '),
      TextSpan(
        text: 'Senior Flutter Engineer (UPI & Payment flows)',
        style: TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: ' by Nexelix Tech.'),
    ],
  ),
  _AlertModel(
    id: 2,
    section: 'Today',
    title: 'Milestone Funded & Payout Ready',
    category: AlertCategory.payment,
    time: '5 hours ago',
    actionLabel: 'View Escrow',
    spans: const [
      TextSpan(text: 'Milestone 2 for '),
      TextSpan(
        text: 'Smart Home IoT App',
        style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' has been funded by client David Courtney (₹25,000 held in Escrow).'),
    ],
  ),
  _AlertModel(
    id: 3,
    section: 'Yesterday',
    title: 'Security Alert: New Sign-in',
    category: AlertCategory.security,
    time: 'Yesterday, 6:15 PM',
    actionLabel: 'Verify Device',
    spans: const [
      TextSpan(
        text:
            'A recent sign-in to your IndiaFreelancers account (p_brightroots) was detected from Chrome on macOS in New Delhi.',
      ),
    ],
  ),
  _AlertModel(
    id: 4,
    section: 'Yesterday',
    title: 'Payment Released to Bank Account',
    category: AlertCategory.payment,
    time: 'Yesterday, 11:30 AM',
    actionLabel: 'Download Receipt',
    spans: const [
      TextSpan(text: 'Your withdrawal of '),
      TextSpan(
        text: '₹42,000',
        style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' to HDFC Bank (**** 4892) has been completed.'),
    ],
  ),
  _AlertModel(
    id: 5,
    section: 'Earlier',
    title: 'Security Notice: Password Changed',
    category: AlertCategory.security,
    time: '4 Aug',
    spans: const [
      TextSpan(text: 'Your security password was updated successfully.'),
    ],
  ),
  _AlertModel(
    id: 6,
    section: 'Earlier',
    title: 'Weekly Summary Available',
    category: AlertCategory.general,
    time: '3 Aug',
    spans: const [
      TextSpan(text: 'The work week has ended, and your '),
      TextSpan(
        text: 'weekly activity summary',
        style: TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: ' is ready for your review.'),
    ],
  ),
  _AlertModel(
    id: 7,
    section: 'Earlier',
    title: 'New Job Invite Received',
    category: AlertCategory.job,
    time: '1 Aug',
    actionLabel: 'Respond to Invite',
    spans: const [
      TextSpan(text: 'Client Trojan Smart Locks invited you to interview for '),
      TextSpan(
        text: 'Create website for Trojan smart locks',
        style: TextStyle(
          color: AppColors.green,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: '.'),
    ],
  ),
];
