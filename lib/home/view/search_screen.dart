import 'package:flutter/material.dart';

import '../bindings/home_binding.dart';
import '../controllers/home_controller.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryController = TextEditingController();
  String _selectedCategory = 'All categories';
  String _sortBy = 'Relevance';

  static const _sampleResults = [
    _SearchResult(
      name: 'Priya Sharma',
      title: 'Senior React Developer',
      category: 'Development & IT',
      rating: 4.9,
      rate: '₹850/hr',
    ),
    _SearchResult(
      name: 'Arjun Mehta',
      title: 'GST-ready Accountant',
      category: 'Finance & Accounting',
      rating: 4.8,
      rate: '₹650/hr',
    ),
    _SearchResult(
      name: 'Sneha Reddy',
      title: 'UI/UX Product Designer',
      category: 'Design & Creative',
      rating: 5.0,
      rate: '₹750/hr',
    ),
    _SearchResult(
      name: 'Rahul Verma',
      title: 'Flutter Mobile Developer',
      category: 'Development & IT',
      rating: 4.7,
      rate: '₹900/hr',
    ),
    _SearchResult(
      name: 'Kavita Nair',
      title: 'Content & SEO Writer',
      category: 'Writing & Translation',
      rating: 4.8,
      rate: '₹500/hr',
    ),
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  List<_SearchResult> get _filteredResults {
    final query = _queryController.text.trim().toLowerCase();
    return _sampleResults.where((item) {
      final matchesCategory =
          _selectedCategory == 'All categories' ||
          item.category == _selectedCategory;
      final matchesQuery =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = HomeBinding.of(context).categories;
    final results = _filteredResults;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.cream50,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppColors.navy,
            onPressed: _goBack,
          ),
          title: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cream50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search "React developer", skills...',
                hintStyle: const TextStyle(
                  color: AppColors.ink300,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: _queryController.text.isEmpty
                    ? const Icon(
                        Icons.search_rounded,
                        color: AppColors.ink500,
                        size: 20,
                      )
                    : GestureDetector(
                        onTap: () {
                          _queryController.clear();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.ink500,
                          size: 20,
                        ),
                      ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: _selectedCategory,
                          icon: Icons.grid_view_rounded,
                          selected: _selectedCategory != 'All categories',
                          onTap: () => _openCategoryFilter(context, categories),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: _sortBy,
                          icon: Icons.sort_rounded,
                          selected: _sortBy != 'Relevance',
                          onTap: () => _openSortFilter(context),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Top rated',
                          icon: Icons.star_rounded,
                          selected: false,
                          onTap: () => setState(() => _sortBy = 'Top rated'),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Available now',
                          icon: Icons.circle,
                          selected: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'No results found.\nTry a different search or filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.ink500, fontSize: 14),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = results[index];
                        return _ResultCard(item: item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _goBack() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushNamedAndRemoveUntil('/', (_) => false);
    }
  }

  void _openCategoryFilter(
    BuildContext context,
    List<HomeCategory> categories,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.55,
          child: Material(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SingleChildScrollView(
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
                        'Category',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (final option in [
                              'All categories',
                              ...categories.map((c) => c.title),
                            ])
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  _selectedCategory == option
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: AppColors.green,
                                ),
                                title: Text(
                                  option,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                onTap: () {
                                  setState(() => _selectedCategory = option);
                                  Navigator.pop(ctx);
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openSortFilter(BuildContext context) {
    const options = [
      'Relevance',
      'Top rated',
      'Price: low to high',
      'Price: high to low',
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.55,
          child: Material(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SingleChildScrollView(
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
                        'Sort by',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final option in options)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            _sortBy == option
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: AppColors.green,
                          ),
                          title: Text(
                            option,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onTap: () {
                            setState(() => _sortBy = option);
                            Navigator.pop(ctx);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.green100 : AppColors.cream50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: selected
              ? AppColors.green.withValues(alpha: 0.35)
              : AppColors.cardBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.green : AppColors.ink500,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.green : AppColors.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.item});

  final _SearchResult item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.green100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item.name.characters.first,
                style: const TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  style: const TextStyle(color: AppColors.ink500, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  item.category,
                  style: const TextStyle(
                    color: AppColors.ink300,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.saffron,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    item.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.rate,
                style: const TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchResult {
  const _SearchResult({
    required this.name,
    required this.title,
    required this.category,
    required this.rating,
    required this.rate,
  });

  final String name;
  final String title;
  final String category;
  final double rating;
  final String rate;
}
