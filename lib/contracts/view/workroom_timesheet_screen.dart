import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';

class WorkroomTimesheetScreen extends StatefulWidget {
  const WorkroomTimesheetScreen({super.key});

  @override
  State<WorkroomTimesheetScreen> createState() => _WorkroomTimesheetScreenState();
}

class _WorkroomTimesheetScreenState extends State<WorkroomTimesheetScreen> {
  String _activeTab = 'Timesheet';
  DateTime _currentWeekStart = DateTime(2026, 8, 3); // Aug 3 - 9, 2026

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/contracts',
      showBackButton: true,
      title: 'Workroom timesheet',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dark teal header section
            Container(
              color: const Color(0xff0f4037),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Native Mobile SDK for iOS and Android',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                          border: Border.all(color: Colors.white30, width: 1),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white70,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Jim Rising',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'United States · Thu 10:57 PM',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action buttons
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/messages');
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff14a800),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff14a800),
                        ),
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Green tabs under header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderTab('Overview'),
                      _buildHeaderTab('Timesheet'),
                      _buildHeaderTab('Contract details'),
                    ],
                  ),
                ],
              ),
            ),

            // Body content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metrics Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                label: 'Last 24 hours',
                                value: '5:00 hrs',
                                subtitle: 'Last worked 17 minutes ago',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: AppColors.cardBorder,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: _buildMetricTile(
                                  label: 'This week',
                                  value: '30:50 hrs',
                                  subtitle: 'of 40 hrs weekly limit',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(color: AppColors.cardBorder, height: 1),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                label: 'Last week',
                                value: '36:00 hrs',
                                subtitle: 'of 40 hrs limit',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: AppColors.cardBorder,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: _buildMetricTile(
                                  label: 'Since start',
                                  value: '4,276:10 hrs',
                                  subtitle: 'total tracked time',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Work diary heading
                  const Text(
                    'Work diary',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Total amount card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f7f2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffd5e0d5)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Total amount',
                          style: TextStyle(
                            color: AppColors.ink700,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\$555.00',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '30:50 hrs @ \$18.00 per hr',
                          style: TextStyle(
                            color: AppColors.ink500,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date switcher
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton.outlined(
                        icon: const Icon(Icons.chevron_left_rounded, size: 22),
                        onPressed: () {
                          setState(() {
                            _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.green),
                              const SizedBox(width: 8),
                              Text(
                                _formatWeekRange(_currentWeekStart),
                                style: const TextStyle(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.green),
                            ],
                          ),
                        ),
                      ),
                      IconButton.outlined(
                        icon: const Icon(Icons.chevron_right_rounded, size: 22),
                        onPressed: () {
                          setState(() {
                            _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mock screenshot grid for work diary logs
                  const Text(
                    'Time Log Screenshots (6)',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    children: [
                      _buildMockDiaryCard('10:10 AM', 8),
                      _buildMockDiaryCard('10:20 AM', 9),
                      _buildMockDiaryCard('10:30 AM', 7),
                      _buildMockDiaryCard('10:40 AM', 10),
                      _buildMockDiaryCard('10:50 AM', 6),
                      _buildMockDiaryCard('11:00 AM', 9),
                    ],
                  ),
                  const SizedBox(height: 80), // bottom spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTab(String title) {
    final isSelected = _activeTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xff14a800) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.ink500,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.ink300,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMockDiaryCard(String time, int activityLevel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Simulated screenshot
          Expanded(
            child: Container(
              color: const Color(0xffe9f0ec),
              child: Center(
                child: Icon(
                  Icons.developer_board_rounded,
                  color: AppColors.green.withValues(alpha: 0.15),
                  size: 32,
                ),
              ),
            ),
          ),
          // Info row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      '$activityLevel/10',
                      style: TextStyle(
                        color: activityLevel >= 8 ? AppColors.green : AppColors.saffron,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Activity level bar
                Row(
                  children: [
                    for (int i = 0; i < 10; i++)
                      Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            color: i < activityLevel
                                ? AppColors.green
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatWeekRange(DateTime start) {
    final end = start.add(const Duration(days: 6));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    if (start.month == end.month) {
      return '${months[start.month - 1]} ${start.day} - ${end.day}, ${start.year}';
    } else {
      return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}, ${start.year}';
    }
  }
}
