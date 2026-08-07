import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';
import '../bindings/contracts_binding.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContractsBinding(child: _ContractsView());
  }
}

class _ContractsView extends StatefulWidget {
  const _ContractsView();

  @override
  State<_ContractsView> createState() => _ContractsViewState();
}

class _ContractsViewState extends State<_ContractsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _activeTab = 'All';

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

  List<_Contract> get _filteredContracts {
    return _contracts.where((contract) {
      if (_activeTab != 'All' && contract.type != _activeTab) {
        return false;
      }

      if (_searchQuery.isEmpty) return true;

      final query = _searchQuery.toLowerCase();
      return contract.title.toLowerCase().contains(query) ||
          contract.client.toLowerCase().contains(query) ||
          contract.status.toLowerCase().contains(query) ||
          contract.skills.any((skill) => skill.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final contracts = _filteredContracts;

    return AppScaffold(
      currentRoute: '/contracts',
      body: Container(
        color: AppColors.cream100,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 84),
          children: [
            _EarningsSummaryCard(total: _contracts.length),
            const SizedBox(height: 18),
            _ContractsSearchBar(
              controller: _searchController,
              query: _searchQuery,
              onClear: _searchController.clear,
            ),
            const SizedBox(height: 14),
            _ContractsTabs(
              activeTab: _activeTab,
              onChanged: (tab) {
                setState(() {
                  _activeTab = tab;
                });
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Active contracts',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${contracts.length} found',
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (contracts.isEmpty)
              const _EmptyContractsState()
            else
              for (final contract in contracts)
                _ContractCard(
                  contract: contract,
                  onOpenTimesheet: () =>
                      Navigator.of(context).pushNamed('/workroom-timesheet'),
                ),
          ],
        ),
      ),
    );
  }
}

class _EarningsSummaryCard extends StatelessWidget {
  const _EarningsSummaryCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
            'Earnings available now',
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '₹0.00',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _SummaryChip(
                icon: Icons.assignment_turned_in_outlined,
                label: '$total contracts',
              ),
              const SizedBox(width: 10),
              const _SummaryChip(
                icon: Icons.schedule_rounded,
                label: '27 hrs this week',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContractsSearchBar extends StatelessWidget {
  const _ContractsSearchBar({
    required this.controller,
    required this.query,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Search contracts',
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
          suffixIcon: query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: AppColors.ink500,
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }
}

class _ContractsTabs extends StatelessWidget {
  const _ContractsTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['All', 'Hourly', 'Milestone', 'Awaiting'].map((tab) {
          final selected = activeTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tab),
              selected: selected,
              selectedColor: AppColors.green100,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: selected ? AppColors.green : AppColors.cardBorder,
              ),
              labelStyle: TextStyle(
                color: selected ? AppColors.green : AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              onSelected: (_) => onChanged(tab),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard({required this.contract, required this.onOpenTimesheet});

  final _Contract contract;
  final VoidCallback onOpenTimesheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
                  contract.title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
              ),
              _StatusBadge(status: contract.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Hired by ${contract.client}',
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: contract.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ContractMetric(
                  label: 'This week',
                  value: contract.weeklyValue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ContractMetric(label: 'Rate', value: contract.rate),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            contract.dateRange,
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.green, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onOpenTimesheet,
              child: const Text(
                'See timesheet',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.cream50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.green, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final awaiting = status == 'Awaiting';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: awaiting ? AppColors.saffron100 : AppColors.green100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: awaiting ? AppColors.saffron700 : AppColors.green,
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ContractMetric extends StatelessWidget {
  const _ContractMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyContractsState extends StatelessWidget {
  const _EmptyContractsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: AppColors.ink300, size: 44),
          SizedBox(height: 12),
          Text(
            'No contracts found',
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Contract {
  const _Contract({
    required this.title,
    required this.client,
    required this.type,
    required this.status,
    required this.weeklyValue,
    required this.rate,
    required this.dateRange,
    required this.skills,
  });

  final String title;
  final String client;
  final String type;
  final String status;
  final String weeklyValue;
  final String rate;
  final String dateRange;
  final List<String> skills;
}

const List<_Contract> _contracts = [
  _Contract(
    title: 'Native Mobile SDK for iOS and Android',
    client: 'Jim Rising',
    type: 'Hourly',
    status: 'Active',
    weeklyValue: '27 hrs, ₹40,500',
    rate: '₹1,500/hr',
    dateRange: 'Jun 5, 2024 - Present',
    skills: ['Flutter', 'iOS', 'Android'],
  ),
  _Contract(
    title: 'IndiaFreelancers dashboard polish and bug fixes',
    client: 'Nisha Sharma',
    type: 'Milestone',
    status: 'Active',
    weeklyValue: 'Milestone 1',
    rate: '₹65,000 fixed',
    dateRange: 'Jul 12, 2026 - Present',
    skills: ['Flutter', 'UI Design', 'QA'],
  ),
  _Contract(
    title: 'Figma to Flutter responsive screens',
    client: 'Amit Verma',
    type: 'Awaiting',
    status: 'Awaiting',
    weeklyValue: 'Pending approval',
    rate: '₹32,000 fixed',
    dateRange: 'Starts after approval',
    skills: ['Figma', 'Flutter', 'Responsive UI'],
  ),
];
