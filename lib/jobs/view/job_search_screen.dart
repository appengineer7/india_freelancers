import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _highlightTerms {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return [];
    return query.split(' ').where((w) => w.isNotEmpty).toList();
  }

  List<_MockSearchJob> get _filteredJobs {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allMockJobs;

    final queryWords = query.split(' ').where((w) => w.isNotEmpty).toList();
    if (queryWords.isEmpty) return _allMockJobs;

    return _allMockJobs.where((job) {
      return queryWords.any((word) {
        final matchesTitle = job.title.toLowerCase().contains(word);
        final matchesDesc = job.description.toLowerCase().contains(word);
        final matchesSkills = job.skills.any((s) => s.toLowerCase().contains(word));
        return matchesTitle || matchesDesc || matchesSkills;
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredJobs;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AppScaffold(
        currentRoute: '/jobs',
        showBackButton: false, // Custom app bar handles back arrow
        showBottomNav: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Job Search Top App Bar (integrated into body)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 24),
                    color: AppColors.navy,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cream50,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.ink500, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.5,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                hintText: 'Search for jobs',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade300,
                                ),
                                child: const Icon(Icons.close_rounded, size: 12, color: Colors.black87),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.green, width: 1.5),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      color: AppColors.green,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            // Advanced search and Save Search options row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Advanced search',
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActionChip(Icons.folder_open_rounded, 'Save search', () {}),
                      const SizedBox(width: 12),
                      _buildActionChip(Icons.favorite_outline_rounded, 'Saved jobs (1782)', () {}),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppColors.cardBorder),

            // Jobs Search Results List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No jobs found for "${_searchController.text}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final job = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildJobCard(job),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.green),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(_MockSearchJob job) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and proposals
          Text(
            '${job.time}  •  Proposals: ${job.proposals}',
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Title with highlights and heart / thumbs buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildHighlightedTextWidget(
                  job.title,
                  _highlightTerms,
                  const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(Icons.thumb_down_alt_outlined, size: 16, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Client metrics row
          Row(
            children: [
              if (job.paymentVerified) ...[
                const Icon(Icons.verified_rounded, size: 15, color: Colors.blue),
                const SizedBox(width: 4),
                const Text(
                  'Payment verified',
                  style: TextStyle(
                    color: AppColors.ink700,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: i < job.rating.floor() ? Colors.orange : Colors.grey.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 4),
              Text(
                job.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${job.spent} spent',
                style: const TextStyle(
                  color: AppColors.ink700,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.location_on_rounded, size: 13, color: AppColors.ink500),
              const SizedBox(width: 2),
              Text(
                job.location,
                style: const TextStyle(
                  color: AppColors.ink700,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Job type
          Text(
            job.jobType,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),

          // Description with highlights
          _buildHighlightedTextWidget(
            job.description,
            _highlightTerms,
            const TextStyle(
              color: AppColors.ink700,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),

          // Skills chips (with dynamic highlights if term matches)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: job.skills.map((skillName) {
              final queryWords = _highlightTerms;
              final isHighlighted = queryWords.any((word) => skillName.toLowerCase().contains(word));

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isHighlighted ? const Color(0xffc2f52c) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  skillName,
                  style: TextStyle(
                    color: isHighlighted ? const Color(0xff1f3d02) : AppColors.ink700,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedTextWidget(String text, List<String> terms, TextStyle baseStyle) {
    final highlightStyle = baseStyle.copyWith(
      background: Paint()..color = const Color(0xffc2f52c),
      color: Colors.black,
    );

    if (terms.isEmpty) return Text(text, style: baseStyle);

    List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    int start = 0;

    while (start < text.length) {
      int nextMatchIndex = -1;
      String matchedTerm = '';

      for (final term in terms) {
        int idx = lowerText.indexOf(term.toLowerCase(), start);
        if (idx != -1 && (nextMatchIndex == -1 || idx < nextMatchIndex)) {
          nextMatchIndex = idx;
          matchedTerm = text.substring(idx, idx + term.length);
        }
      }

      if (nextMatchIndex == -1) {
        spans.add(TextSpan(text: text.substring(start), style: baseStyle));
        break;
      }

      if (nextMatchIndex > start) {
        spans.add(TextSpan(text: text.substring(start, nextMatchIndex), style: baseStyle));
      }

      spans.add(TextSpan(
        text: matchedTerm,
        style: highlightStyle,
      ));

      start = nextMatchIndex + matchedTerm.length;
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

class _MockSearchJob {
  const _MockSearchJob({
    required this.time,
    required this.proposals,
    required this.title,
    required this.paymentVerified,
    required this.rating,
    required this.spent,
    required this.location,
    required this.jobType,
    required this.description,
    required this.skills,
  });

  final String time;
  final String proposals;
  final String title;
  final bool paymentVerified;
  final double rating;
  final String spent;
  final String location;
  final String jobType;
  final String description;
  final List<String> skills;
}

const List<_MockSearchJob> _allMockJobs = [
  _MockSearchJob(
    time: 'Posted yesterday',
    proposals: '50+',
    title: 'Backend Developer for Web & Mobile',
    paymentVerified: true,
    rating: 5.0,
    spent: '\$20K+',
    location: 'USA',
    jobType: 'Hourly - Intermediate - Est. time: More than 6 months, 30+ hrs/week',
    description: 'Job Title: Senior Backend Developer – Payments and Transaction Platform Company: Digital World Enterprises Inc. Employment Type: Full-time or long-term contract Location: Remote Experience: 5+ years preferred About the Role Digital World Enterprises Inc. is hiring an experienced backend developer to help take over, stabilize, improve, and operate an...',
    skills: ['Web Service', 'Back-End Development', 'Python', 'PHP', 'Laravel', 'PaperDb', 'MySQL', '+10'],
  ),
  _MockSearchJob(
    time: 'Posted 2 hours ago',
    proposals: '10 to 15',
    title: 'Senior Flutter Developer',
    paymentVerified: true,
    rating: 4.8,
    spent: '\$5K+',
    location: 'India',
    jobType: 'Hourly - Expert - Est. time: 3 to 6 months, 30+ hrs/week',
    description: 'We are looking for a senior Flutter developer to build a cross-platform mobile application for e-commerce. Must have excellent knowledge of State Management (BLoC/Provider), clean architecture, and CI/CD pipelines. Experience in integrating native modules is required.',
    skills: ['Flutter', 'Dart', 'Android', 'iOS', 'Firebase', 'BLoC', 'State Management'],
  ),
  _MockSearchJob(
    time: 'Posted 5 hours ago',
    proposals: '20 to 50',
    title: 'iOS App Developer (Swift/SwiftUI)',
    paymentVerified: true,
    rating: 4.9,
    spent: '\$15K+',
    location: 'United Kingdom',
    jobType: 'Hourly - Intermediate - Est. time: 1 to 3 months, 20 hrs/week',
    description: 'Looking for an expert iOS developer to build and design SwiftUI screens for our fitness tracker app. You will connect local storage (CoreData) with REST APIs and ensure smooth transitions. Experience in writing Unit Tests is highly desirable.',
    skills: ['iOS', 'Swift', 'SwiftUI', 'CoreData', 'REST API', 'Xcode'],
  ),
  _MockSearchJob(
    time: 'Posted 1 day ago',
    proposals: '5 to 10',
    title: 'Android Developer - Kotlin',
    paymentVerified: true,
    rating: 4.7,
    spent: '\$2K+',
    location: 'Germany',
    jobType: 'Fixed price - Intermediate - Est. Budget: \$3,500',
    description: 'Need an Android developer to implement a offline-first database synchronization module using Room database and Kotlin coroutines. The UI is already built in Jetpack Compose, you just need to hook up the Repository layer and clean up bugs.',
    skills: ['Android', 'Kotlin', 'Room Database', 'Coroutines', 'Jetpack Compose'],
  ),
  _MockSearchJob(
    time: 'Posted yesterday',
    proposals: '50+',
    title: 'Full Stack Developer with AI Expertise Needed',
    paymentVerified: true,
    rating: 4.9,
    spent: '\$800+',
    location: 'India',
    jobType: 'Hourly - Intermediate - Est. time: 1 to 3 months, 30+ hrs/week',
    description: 'We are seeking an experienced developer with expertise in AI model integrations and React/Python stacks. The ideal candidate will help build a backend service to parse files and execute prompts dynamically.',
    skills: ['Python', 'AI Integration', 'React', 'FastAPI', 'PostgreSQL'],
  ),
];
