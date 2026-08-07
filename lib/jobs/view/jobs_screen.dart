import 'package:flutter/material.dart';

import '../../auth/bindings/auth_binding.dart';
import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';
import '../bindings/jobs_binding.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const JobsBinding(child: _JobsFeedView());
  }
}

class _JobsFeedView extends StatefulWidget {
  const _JobsFeedView();

  @override
  State<_JobsFeedView> createState() => _JobsFeedViewState();
}

class _JobsFeedViewState extends State<_JobsFeedView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeTab =
      'Best matches'; // Best matches, Most recent, Saved jobs, My feed
  String _selectedCategory = 'All';
  String _selectedType = 'Any'; // Any, Fixed price, Hourly
  final Set<int> _savedJobIds = {2, 3};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_JobModel> get _filteredJobs {
    return _mockJobs.where((job) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = job.title.toLowerCase().contains(query);
        final matchesDesc = job.description.toLowerCase().contains(query);
        final matchesSkills = job.skills.any(
          (s) => s.toLowerCase().contains(query),
        );
        if (!matchesTitle && !matchesDesc && !matchesSkills) return false;
      }

      if (_activeTab == 'Saved jobs' && !_savedJobIds.contains(job.id)) {
        return false;
      }

      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Development & IT' &&
            !job.skills.any(
              (s) => [
                'Flutter',
                'React',
                'Node.js',
                'HTML5',
                'React Native',
              ].contains(s),
            )) {
          return false;
        }
        if (_selectedCategory == 'Design & Creative' &&
            !job.skills.any(
              (s) => ['Figma', 'UI/UX Design', 'Wireframing'].contains(s),
            )) {
          return false;
        }
        if (_selectedCategory == 'AI & Data' &&
            !job.skills.any((s) => ['Blockchain', 'AI', 'Web3'].contains(s))) {
          return false;
        }
      }

      if (_selectedType != 'Any') {
        if (job.budgetType != _selectedType) return false;
      }

      return true;
    }).toList();
  }

  void _toggleSaveJob(int id) {
    setState(() {
      if (_savedJobIds.contains(id)) {
        _savedJobIds.remove(id);
      } else {
        _savedJobIds.add(id);
      }
    });
  }

  void _openFiltersSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 16,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Jobs',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setSheetState(() {
                            _selectedCategory = 'All';
                            _selectedType = 'Any';
                          });
                          setState(() {});
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                          'All',
                          'Development & IT',
                          'Design & Creative',
                          'AI & Data',
                        ].map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.saffron100,
                            backgroundColor: AppColors.cream50,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.saffron700
                                  : AppColors.navy,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              fontSize: 13,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.saffron
                                  : AppColors.cardBorder,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setSheetState(() => _selectedCategory = cat);
                                setState(() {});
                              }
                            },
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Job Type',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ['Any', 'Fixed price', 'Hourly'].map((type) {
                      final isSelected = _selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: AppColors.saffron100,
                          backgroundColor: AppColors.cream50,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.saffron700
                                : AppColors.navy,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 13,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.saffron
                                : AppColors.cardBorder,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setSheetState(() => _selectedType = type);
                              setState(() {});
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showJobDetailModal(_JobModel job) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          job.title,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.25,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _savedJobIds.contains(job.id)
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          color: _savedJobIds.contains(job.id)
                              ? Colors.red
                              : AppColors.ink500,
                        ),
                        onPressed: () {
                          _toggleSaveJob(job.id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${job.timeAgo} • ${job.location}',
                    style: const TextStyle(
                      color: AppColors.ink500,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.cardBorder),
                  const SizedBox(height: 16),

                  // Scope & Budget Row
                  Row(
                    children: [
                      Expanded(
                        child: _DetailInfoTile(
                          icon: Icons.monetization_on_outlined,
                          title: job.budgetType,
                          subtitle: job.budgetInfo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DetailInfoTile(
                          icon: Icons.workspace_premium_outlined,
                          title: 'Experience',
                          subtitle: job.experienceLevel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Job Description',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job.description,
                    style: const TextStyle(
                      color: AppColors.ink700,
                      fontSize: 14.5,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Skills & Expertise',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cream50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Client Information Container Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cream50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About the Client',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              job.paymentVerified
                                  ? Icons.verified_rounded
                                  : Icons.gpp_maybe_rounded,
                              size: 18,
                              color: job.paymentVerified
                                  ? AppColors.green
                                  : Colors.amber.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              job.paymentVerified
                                  ? 'Payment Verified'
                                  : 'Payment Unverified',
                              style: TextStyle(
                                color: job.paymentVerified
                                    ? AppColors.green
                                    : Colors.amber.shade900,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: AppColors.saffron,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${job.rating > 0 ? job.rating : 'New'} client rating',
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              '•  ${job.spent}',
                              style: const TextStyle(
                                color: AppColors.ink500,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Proposal CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Submitting proposal for "${job.title}"',
                            ),
                            backgroundColor: AppColors.saffron,
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Submit a Proposal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.saffron,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs;
    final displayName = AuthBinding.maybeOf(context)?.displayName.trim();
    final welcomeName = displayName == null || displayName.isEmpty
        ? 'nisha'
        : displayName;

    return AppScaffold(
      currentRoute: '/jobs',
      body: Container(
        color: AppColors.cream100,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
          children: [
            Text(
              'Welcome back, $welcomeName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Here is a quick way into the tools for your active account mode.',
              style: TextStyle(
                color: AppColors.ink500,
                fontWeight: FontWeight.w500,
                fontSize: 17,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            _JobsSearchFilterBar(
              searchController: _searchController,
              searchQuery: _searchQuery,
              onClearSearch: _searchController.clear,
              onOpenFilters: _openFiltersSheet,
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 22),
              _AccountModeCard(onActivateMode: _openFiltersSheet),
              const SizedBox(height: 18),
              _FindingWorkCard(
                activeTab: _activeTab,
                savedCount: _savedJobIds.length,
                onTabSelected: (tab) {
                  setState(() {
                    _activeTab = tab;
                  });
                },
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Posted jobs',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  '${jobs.length} found',
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (jobs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'No jobs found matching "$_searchQuery"'
                          : 'No saved jobs found',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            else
              for (final job in jobs)
                _JobCardContainer(
                  job: job,
                  isSaved: _savedJobIds.contains(job.id),
                  onToggleSave: () => _toggleSaveJob(job.id),
                  onTap: () => _showJobDetailModal(job),
                ),
          ],
        ),
      ),
    );
  }
}

class _AccountModeCard extends StatelessWidget {
  const _AccountModeCard({required this.onActivateMode});

  final VoidCallback onActivateMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account modes',
            style: TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Activate both modes if you plan to hire and work on the platform.',
            style: TextStyle(
              color: AppColors.ink500,
              fontWeight: FontWeight.w500,
              fontSize: 15.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ModePill(
                icon: Icons.check_rounded,
                label: 'FREELANCER',
                selected: true,
              ),
              _ModePill(label: 'CLIENT', selected: false),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 430;
              final selector = _ModeSelectorButton(onTap: onActivateMode);
              final activate = _ActivateModeButton(onTap: onActivateMode);

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [selector, const SizedBox(height: 12), activate],
                );
              }

              return Row(
                children: [
                  Expanded(child: selector),
                  const SizedBox(width: 12),
                  activate,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FindingWorkCard extends StatelessWidget {
  const _FindingWorkCard({
    required this.activeTab,
    required this.savedCount,
    required this.onTabSelected,
  });

  final String activeTab;
  final int savedCount;
  final ValueChanged<String> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final actions = <_WorkAction>[
      const _WorkAction('Browse jobs', 'Best matches'),
      const _WorkAction('Most recent', 'Most recent'),
      _WorkAction('Saved jobs ($savedCount)', 'Saved jobs'),
      const _WorkAction('My feed', 'My feed'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.work_outline_rounded,
                color: AppColors.green,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Finding work',
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: actions.map((action) {
              final isActive = activeTab == action.tab;
              return _WorkActionButton(
                label: action.label,
                selected: isActive,
                onTap: () => onTabSelected(action.tab),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _JobsSearchFilterBar extends StatelessWidget {
  const _JobsSearchFilterBar({
    required this.searchController,
    required this.searchQuery,
    required this.onClearSearch,
    required this.onOpenFilters,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClearSearch;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(
                fontSize: 14.5,
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Search for jobs',
                hintStyle: const TextStyle(
                  color: AppColors.ink500,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.ink500,
                  size: 20,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: AppColors.ink500,
                        onPressed: onClearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune_rounded, size: 20),
            color: AppColors.green,
            tooltip: 'Filter options',
            onPressed: onOpenFilters,
          ),
        ),
      ],
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({required this.label, required this.selected, this.icon});

  final String label;
  final bool selected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? AppColors.green100 : AppColors.cream100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.green, size: 18),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.green : AppColors.ink700,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSelectorButton extends StatelessWidget {
  const _ModeSelectorButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.green, width: 2),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Text(
                'Freelancer',
                style: TextStyle(
                  color: AppColors.ink700,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.ink500),
          ],
        ),
      ),
    );
  }
}

class _ActivateModeButton extends StatelessWidget {
  const _ActivateModeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.border, width: 1.5),
        minimumSize: const Size(150, 56),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        'Activate mode',
        style: TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w900,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _WorkActionButton extends StatelessWidget {
  const _WorkActionButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? AppColors.green : Colors.white,
        foregroundColor: selected ? Colors.white : AppColors.navy,
        side: BorderSide(
          color: selected ? AppColors.green : AppColors.border,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: selected ? Colors.white : AppColors.navy,
        ),
      ),
    );
  }
}

class _WorkAction {
  const _WorkAction(this.label, this.tab);

  final String label;
  final String tab;
}

class _JobCardContainer extends StatelessWidget {
  const _JobCardContainer({
    required this.job,
    required this.isSaved,
    required this.onToggleSave,
    required this.onTap,
  });

  final _JobModel job;
  final bool isSaved;
  final VoidCallback onToggleSave;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title + Bookmark Heart
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.timeAgo,
                            style: const TextStyle(
                              color: AppColors.ink500,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color: isSaved ? Colors.red : AppColors.ink500,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onToggleSave,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Budget & Experience Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.budgetInfo,
                        style: const TextStyle(
                          color: AppColors.green,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '•  ${job.experienceLevel}',
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Description Paragraph
                Text(
                  job.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.ink700,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),

                // Skills Pill Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: job.skills.take(5).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cream50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 12),

                // Client Verification Footer Container
                Row(
                  children: [
                    Icon(
                      job.paymentVerified
                          ? Icons.verified_rounded
                          : Icons.gpp_maybe_rounded,
                      size: 16,
                      color: job.paymentVerified
                          ? AppColors.green
                          : Colors.amber.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job.paymentVerified ? 'Payment verified' : 'Unverified',
                      style: TextStyle(
                        color: job.paymentVerified
                            ? AppColors.green
                            : Colors.amber.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (job.rating > 0) ...[
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.saffron,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        job.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      job.spent,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      job.location,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailInfoTile extends StatelessWidget {
  const _DetailInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.green, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JobModel {
  const _JobModel({
    required this.id,
    required this.title,
    required this.timeAgo,
    required this.proposals,
    required this.budgetType,
    required this.experienceLevel,
    required this.budgetInfo,
    required this.description,
    required this.skills,
    required this.paymentVerified,
    required this.rating,
    required this.spent,
    required this.location,
  });

  final int id;
  final String title;
  final String timeAgo;
  final String proposals;
  final String budgetType;
  final String experienceLevel;
  final String budgetInfo;
  final String description;
  final List<String> skills;
  final bool paymentVerified;
  final double rating;
  final String spent;
  final String location;
}

const List<_JobModel> _mockJobs = [
  _JobModel(
    id: 1,
    title: 'Website and App Development (India Freelancers Platform)',
    timeAgo: 'Posted 9 hours ago',
    proposals: '50+',
    budgetType: 'Hourly',
    experienceLevel: 'Intermediate',
    budgetInfo: 'Hourly: ₹600 - ₹1,500/hr',
    description:
        'Looking for an experienced web and mobile app developer. We are building a platform for freelance services in India and need someone to help finalize the frontend UI and connect backend APIs. Must have experience with Flutter, React, and Node.js.',
    skills: ['Flutter', 'React', 'Node.js', 'HTML5', 'Web Development'],
    paymentVerified: true,
    rating: 4.9,
    spent: '₹2.4L+ spent',
    location: 'India',
  ),
  _JobModel(
    id: 2,
    title: 'Full-Stack Developer (Web + Mobile) to Finalize MVP',
    timeAgo: 'Posted 2 hours ago',
    proposals: '20 to 50',
    budgetType: 'Fixed price',
    experienceLevel: 'Intermediate',
    budgetInfo: 'Est. Budget: ₹65,000',
    description:
        'We are an early-stage startup looking for a developer to help launch our MVP platform. The project is 80% complete but we need support to squash bugs, refine responsive views, and integrate UPI payment workflows.',
    skills: [
      'Flutter',
      'Firebase',
      'Node.js',
      'RESTful API',
      'UPI Integration',
    ],
    paymentVerified: true,
    rating: 4.8,
    spent: '₹1.2L+ spent',
    location: 'India',
  ),
  _JobModel(
    id: 3,
    title: 'UI/UX Designer for Fintech Mobile App & Dashboard',
    timeAgo: 'Posted 3 hours ago',
    proposals: '10 to 15',
    budgetType: 'Fixed price',
    experienceLevel: 'Expert',
    budgetInfo: 'Est. Budget: ₹45,000',
    description:
        'Looking for a seasoned UI/UX Designer to design a 12-screen fintech application. The design should be modern, minimalist, and use a dark theme. Experience with Figma is required. Please share your portfolio.',
    skills: [
      'Figma',
      'UI/UX Design',
      'Mobile App Design',
      'Wireframing',
      'Prototyping',
    ],
    paymentVerified: true,
    rating: 5.0,
    spent: '₹4.5L+ spent',
    location: 'United States',
  ),
  _JobModel(
    id: 4,
    title: 'Technical Content Writer - Web3 & AI Security',
    timeAgo: 'Posted 1 day ago',
    proposals: '5 to 10',
    budgetType: 'Fixed price',
    experienceLevel: 'Intermediate',
    budgetInfo: 'Est. Budget: ₹15,000',
    description:
        'We need 4 high-quality articles (1,500 words each) covering Web3 security concepts and AI automation. Must have previous technical writing experience and ability to explain complex topics simply.',
    skills: [
      'Content Writing',
      'Technical Writing',
      'Blockchain',
      'SEO Optimization',
    ],
    paymentVerified: true,
    rating: 4.6,
    spent: '₹80k spent',
    location: 'India',
  ),
  _JobModel(
    id: 5,
    title: 'React Native & Flutter Mobile Engineer for E-commerce',
    timeAgo: 'Posted 5 hours ago',
    proposals: '15 to 20',
    budgetType: 'Hourly',
    experienceLevel: 'Expert',
    budgetInfo: 'Hourly: ₹800 - ₹2,000/hr',
    description:
        'Experienced mobile engineer needed for a high-performance e-commerce mobile application. Must have experience with state management, push notifications, and deploying to App Store / Google Play.',
    skills: ['Flutter', 'React Native', 'Redux', 'iOS Development', 'Android'],
    paymentVerified: false,
    rating: 0.0,
    spent: '₹0 spent',
    location: 'Denmark',
  ),
];
