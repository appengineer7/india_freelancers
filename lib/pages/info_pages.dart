import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../auth/view/auth_screen.dart';
import '../core/site_shell.dart';
import '../home/view/home_screen.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/how-it-works',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: InfoPageContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('How it works'),
              const SizedBox(height: 10),
              Text(
                'A clear path from posting to payment',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.navy,
                  fontSize: _headingSize(context),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Here's exactly what happens from posting a job to getting paid — every step below is live on the Platform today.",
                style: TextStyle(
                  color: AppColors.ink500,
                  fontSize: 16,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stack = constraints.maxWidth < 640;
                  final clients = _StepsList(
                    title: 'For clients',
                    items: const [
                      'Create a free account and verify your email.',
                      'Complete your client profile with company details.',
                      'Post a fixed-price or hourly job with a clear scope.',
                      'Review proposals and message freelancers directly.',
                      'Hire, track milestones, and approve completed work.',
                    ],
                  );
                  final freelancers = _StepsList(
                    title: 'For freelancers',
                    items: const [
                      'Create a free account and verify your email.',
                      'Build a profile: skills, portfolio, rate and availability.',
                      'Search open jobs or receive direct invitations.',
                      'Submit tailored proposals with a clear cover letter.',
                      'Deliver milestones and get paid transparently.',
                    ],
                  );
                  return stack
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            clients,
                            const SizedBox(height: 40),
                            freelancers,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: clients),
                            const SizedBox(width: 40),
                            Expanded(child: freelancers),
                          ],
                        );
                },
              ),
              const SizedBox(height: 40),
              InfoAlert(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text:
                            'Milestones are funded upfront and held via our payment processor until you approve the delivered work, then released to the freelancer — see ',
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/pricing'),
                          child: const Text(
                            'pricing',
                            style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' for how fees work.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepsList extends StatelessWidget {
  const _StepsList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w900,
            fontSize: 19,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}. ',
                  style: const TextStyle(color: AppColors.ink700, height: 2),
                ),
                Expanded(
                  child: Text(
                    items[i],
                    style: const TextStyle(color: AppColors.ink700, height: 2),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      currentRoute: '/how-it-works',
      title: 'Pricing',
      body: InfoPageContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Pricing'),
            const SizedBox(height: 10),
            Text(
              'Simple, transparent pricing',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Creating an account, building a profile, posting jobs and submitting proposals are always free. We only make money when a freelancer gets paid for completed work.',
              style: TextStyle(
                color: AppColors.ink500,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 32),
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How fees work',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final item in const [
                    'No cost to register, verify your account, or build a profile.',
                    'No cost to post jobs, browse jobs, or submit proposals.',
                    "When a client funds a milestone, we deduct a 10% service fee from the freelancer's payout — clients pay no additional marketplace fee.",
                    'The fee is always shown before a milestone is funded — never hidden or applied retroactively.',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(color: AppColors.ink700),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: AppColors.ink700,
                                height: 1.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const InfoAlert(
              child: Text(
                'Payments are processed securely by Stripe. Funds are held against a milestone until you approve the delivered work, then released to the freelancer, minus the service fee above.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrustScreen extends StatelessWidget {
  const TrustScreen({super.key});

  static const _panels = [
    (
      'Account security',
      'Argon2id password hashing, session ID rotation on login, HttpOnly/SameSite cookies, per-account and per-IP login throttling, and a device/session list you control.',
    ),
    (
      'Data handling',
      'CSRF protection on every state-changing request, output escaping, and a strict content security policy. Sensitive fields are never logged in plain text.',
    ),
    (
      'Auditability',
      'Security-relevant events (logins, password resets, session revocations) and privileged/financial actions are recorded server-side with request correlation IDs.',
    ),
    (
      'Milestone-based payments',
      'Clients fund a milestone upfront through Stripe; funds are only released to the freelancer once the client approves the delivered work. We never see or store card details — that goes directly to Stripe.',
    ),
    (
      'Double-blind reviews',
      'Reviews only become visible once both sides have submitted theirs (or a waiting period passes), so feedback reflects real experience rather than retaliation.',
    ),
    (
      'Moderation and disputes',
      'Job posts, reviews and profiles are subject to our content policies, and our team can review flagged content, milestone disputes and messages when a dispute is raised.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      title: 'Trust & safety',
      body: InfoPageContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Trust & safety'),
            const SizedBox(height: 10),
            Text(
              "What we've built to keep the Platform trustworthy",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "We would rather under-promise than describe features that don't exist. Here is what is live in the product today.",
              style: TextStyle(
                color: AppColors.ink500,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 640 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _panels.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 170,
                  ),
                  itemBuilder: (context, index) {
                    final panel = _panels[index];
                    return InfoPanel(title: panel.$1, body: panel.$2);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      title: 'About',
      body: InfoPageContent(
        maxWidth: 760,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('About'),
            const SizedBox(height: 10),
            Text(
              "India's professional freelance marketplace",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'IndiaFreelancers.com connects skilled Indian professionals with clients in India and worldwide — with clear pricing, strong identity and payment controls, and no dark patterns.',
              style: TextStyle(
                color: AppColors.ink500,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                style: const TextStyle(color: AppColors.ink700, height: 1.85),
                children: [
                  const TextSpan(
                    text:
                        'From posting a job to funding a milestone and getting paid, every step happens on the Platform: verified profiles, proposals, offers, contracts, secure milestone-based payments, and a double-blind review system that keeps feedback honest. You can read about the specific protections we\'ve built on our ',
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/trust'),
                      child: const Text(
                        'trust & safety',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: ' page.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      title: 'Contact',
      body: InfoPageContent(
        maxWidth: 640,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Contact'),
            const SizedBox(height: 10),
            Text(
              'Get in touch',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Have a question, need help with your account, or want to report an issue? Reach us directly:',
              style: TextStyle(
                color: AppColors.ink500,
                fontSize: 16,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        color: AppColors.ink700,
                        fontSize: 16,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Email: ',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        TextSpan(
                          text: 'hello@indiafreelancers.com',
                          style: TextStyle(
                            color: AppColors.green,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We aim to respond within one business day.',
                    style: TextStyle(
                      color: AppColors.ink500.withValues(alpha: 0.95),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'Is IndiaFreelancers.com free to join?',
      'Yes. Creating an account, building a profile, posting jobs and submitting proposals are all free. See pricing for how our service fee works once you hire or get hired.',
    ),
    (
      'Can I sign up as both a client and a freelancer?',
      'Yes — choose "both" during registration, or activate the other mode later from your dashboard.',
    ),
    (
      'Where do I manage my account security?',
      'From your dashboard you can view active sessions/devices and revoke any of them individually.',
    ),
    (
      "Something isn't working — who do I tell?",
      'Please contact us with as much detail as you can — that helps us fix it fast.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      title: 'Help',
      body: InfoPageContent(
        maxWidth: 760,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Help center'),
            const SizedBox(height: 10),
            Text(
              'Frequently asked questions',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 24),
            for (final faq in _faqs) ...[
              InfoPanel(title: faq.$1, body: faq.$2),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _MockJob {
  final int id;
  final String title;
  final String timeAgo;
  final String proposals;
  final String budgetType;
  final String budgetInfo;
  final String experienceLevel;
  final String description;
  final List<String> skills;
  final bool paymentVerified;
  final double rating;
  final String spent;
  final String location;
  bool isLiked = false;
  bool isDisliked = false;
  bool isExpanded = false;

  _MockJob({
    required this.id,
    required this.title,
    required this.timeAgo,
    required this.proposals,
    required this.budgetType,
    required this.budgetInfo,
    required this.experienceLevel,
    required this.description,
    required this.skills,
    required this.paymentVerified,
    required this.rating,
    required this.spent,
    required this.location,
  });
}

class _MockInvite {
  final int id;
  final String time;
  final String clientName;
  final String jobTitle;
  final String description;
  bool isResponded = false;
  String responseStatus = 'Pending response';

  _MockInvite({
    required this.id,
    required this.time,
    required this.clientName,
    required this.jobTitle,
    required this.description,
  });
}

List<InlineSpan> _highlightText(
  String text,
  String query,
  TextStyle defaultStyle,
) {
  final highlightStyle = defaultStyle.copyWith(
    backgroundColor: const Color(0xffadff2f), // Lime green/yellow highlight
    color: Colors.black87,
  );
  if (query.isEmpty) return [TextSpan(text: text, style: defaultStyle)];

  final terms = query
      .split(RegExp(r'\s+'))
      .map((e) => e.trim().toLowerCase())
      .where((e) => e.length >= 2)
      .toList();

  if (terms.isEmpty) return [TextSpan(text: text, style: defaultStyle)];

  final escapedTerms = terms.map((t) => RegExp.escape(t)).join('|');
  final regex = RegExp(escapedTerms, caseSensitive: false);

  final List<InlineSpan> spans = [];
  int start = 0;

  regex.allMatches(text).forEach((match) {
    if (match.start > start) {
      spans.add(
        TextSpan(text: text.substring(start, match.start), style: defaultStyle),
      );
    }
    spans.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        style: highlightStyle,
      ),
    );
    start = match.end;
  });

  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: defaultStyle));
  }

  return spans;
}

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isFABExtended = true;
  String _searchQuery = '';
  String _activeTab =
      'Best matches'; // Best matches, Most recent, My feed, Invites
  bool _showSavedOnly = false;
  String _selectedCategory = 'All';
  String _selectedType = 'Any'; // Any, Fixed price, Hourly

  final List<_MockJob> _jobs = [
    _MockJob(
      id: 1,
      title: 'Website and App Development',
      timeAgo: 'Posted 9 hours ago',
      proposals: '50+',
      budgetType: 'Hourly',
      experienceLevel: 'Intermediate',
      budgetInfo: 'Est. Time: Less than 1 month, Less than 30 hrs/week',
      description:
          'Looking for an experienced web developer (Marketplace / CMS / Future mobile app). We are building a platform for freelance services in India and need someone to help finalize the frontend and connect APIs. Must have experience with React, Node, and Flutter.',
      skills: [
        'HTML5',
        'Web Development',
        'JavaScript',
        'React',
        'Flutter',
        'Node.js',
      ],
      paymentVerified: false,
      rating: 0.0,
      spent: '₹0 spent',
      location: 'Denmark',
    ),
    _MockJob(
      id: 2,
      title: 'Full-Stack Developer (Web + Mobile) to Finalize MVP',
      timeAgo: 'Posted 9 hours ago',
      proposals: '20 to 50',
      budgetType: 'Hourly',
      experienceLevel: 'Intermediate',
      budgetInfo: 'Hourly: ₹400 - ₹1,200',
      description:
          'We are an early-stage startup looking for a developer to help launch our platform. The project is 80% complete but we need support to squash bugs and ensure proper scaling. Integration with UPI payments is a major plus.',
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
    _MockJob(
      id: 3,
      title: 'UI/UX Designer for Fintech Mobile App',
      timeAgo: 'Posted 2 hours ago',
      proposals: '10 to 15',
      budgetType: 'Fixed price',
      experienceLevel: 'Expert',
      budgetInfo: 'Est. Budget: ₹45,000',
      description:
          'Looking for a seasoned UI/UX Designer to design a 12-screen fintech application. The design should be modern, minimalist, and use a dark theme. Experience with Figma is required. Please share your portfolio of fintech or transaction-heavy apps.',
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
    _MockJob(
      id: 4,
      title: 'Technical Content Writer - Blockchain & Web3',
      timeAgo: 'Posted 1 day ago',
      proposals: '5 to 10',
      budgetType: 'Fixed price',
      experienceLevel: 'Intermediate',
      budgetInfo: 'Est. Budget: ₹12,000',
      description:
          'We need 4 high-quality articles (1,500 words each) covering basic and advanced Web3 security concepts. Must have previous writing experience in blockchain and be able to explain complex topics simply.',
      skills: [
        'Content Writing',
        'Technical Writing',
        'Blockchain',
        'Web3',
        'SEO Optimization',
      ],
      paymentVerified: true,
      rating: 4.5,
      spent: '₹80k spent',
      location: 'India',
    ),
    _MockJob(
      id: 5,
      title: 'React Native Developer for E-commerce App',
      timeAgo: 'Posted 3 hours ago',
      proposals: '15 to 20',
      budgetType: 'Hourly',
      experienceLevel: 'Expert',
      budgetInfo: 'Hourly: ₹800 - ₹2,000',
      description:
          'Experienced React Native developer needed for a high-performance e-commerce mobile application. Must have experience with Redux, native modules, push notifications, and deploying to App Store/Google Play.',
      skills: [
        'React Native',
        'Redux',
        'iOS Development',
        'Android Development',
        'E-commerce',
      ],
      paymentVerified: false,
      rating: 0.0,
      spent: '₹0 spent',
      location: 'United Kingdom',
    ),
  ];

  final List<_MockInvite> _invites = [
    _MockInvite(
      id: 1,
      time: 'Received 2 hours ago',
      clientName: 'Nexelix Tech (India)',
      jobTitle: 'Senior Flutter Engineer (UPI & Payment flows)',
      description:
          'Hi! We saw your profile and we would love to invite you to interview for our upcoming Flutter mobile application. We need someone who has worked on complex payment gateway integrations in India.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && _isFABExtended) {
      setState(() {
        _isFABExtended = false;
      });
    } else if (direction == ScrollDirection.forward && !_isFABExtended) {
      setState(() {
        _isFABExtended = true;
      });
    } else if (_scrollController.offset <= 10 && !_isFABExtended) {
      setState(() {
        _isFABExtended = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<_MockJob> get _filteredJobs {
    return _jobs.where((job) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = job.title.toLowerCase().contains(query);
        final matchesSkills = job.skills.any(
          (s) => s.toLowerCase().contains(query),
        );
        if (!matchesTitle && !matchesSkills) return false;
      }

      if (_showSavedOnly && !job.isLiked) return false;

      if (_selectedCategory != 'All') {
        if (_selectedCategory == 'Development & IT' &&
            !job.title.contains('Developer') &&
            !job.title.contains('Writer')) {
          return false;
        }
        if (_selectedCategory == 'Design & Creative' &&
            !job.title.contains('Designer')) {
          return false;
        }
        if (_selectedCategory == 'AI & Data' &&
            !job.skills.contains('Blockchain')) {
          return false;
        }
      }

      if (_selectedType != 'Any') {
        if (job.budgetType != _selectedType) return false;
      }

      return true;
    }).toList();
  }

  void _openFiltersSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.55,
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
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
                          },
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: AppColors.saffron,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Category',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      underline: Container(height: 1, color: AppColors.border),
                      items:
                          [
                            'All',
                            'Development & IT',
                            'Design & Creative',
                            'AI & Data',
                          ].map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            );
                          }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() {
                            _selectedCategory = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Project Type',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final type in [
                          'Any',
                          'Fixed price',
                          'Hourly',
                        ]) ...[
                          Row(
                            children: [
                              // ignore: deprecated_member_use
                              Radio<String>(
                                value: type,
                                // ignore: deprecated_member_use
                                groupValue: _selectedType,
                                activeColor: AppColors.saffron,
                                // ignore: deprecated_member_use
                                onChanged: (val) {
                                  if (val != null) {
                                    setSheetState(() {
                                      _selectedType = val;
                                    });
                                  }
                                },
                              ),
                              Text(type),
                            ],
                          ),
                          const SizedBox(width: 12),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
                )
            );
          },
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredJobs;
    final tabs = ['Best matches', 'Most recent', 'My feed', 'Invites'];

    return AppScaffold(
      currentRoute: '/jobs',
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.cream50,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            readOnly: true,
                            onTap: () =>
                                Navigator.of(context).pushNamed('/job-search'),
                            decoration: const InputDecoration(
                              hintText: 'Search for jobs',
                              hintStyle: TextStyle(
                                color: AppColors.ink300,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: AppColors.ink500,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSavedOnly = !_showSavedOnly;
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.green,
                              width: 2.0,
                            ),
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.green,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final tab in tabs)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeTab = tab;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _activeTab == tab
                                            ? AppColors.green
                                            : Colors.transparent,
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    tab,
                                    style: TextStyle(
                                      color: _activeTab == tab
                                          ? AppColors.green
                                          : AppColors.ink700,
                                      fontWeight: _activeTab == tab
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.cardBorder,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Text(
                    switch (_activeTab) {
                      'Best matches' =>
                        'Browse jobs that match your experience to a client\'s hiring preferences. Ordered by most relevant.',
                      'Most recent' =>
                        'Browse the most recently posted jobs. Updated in real-time.',
                      'My feed' =>
                        'Personalized feed based on your skills, search history, and profile preferences.',
                      'Invites' =>
                        'Active invitations to interview from clients who found your profile.',
                      _ => '',
                    },
                    style: const TextStyle(
                      color: AppColors.ink500,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (_activeTab == 'Invites') ...[
                if (_invites.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'No pending invitations',
                          style: TextStyle(
                            color: AppColors.ink500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final invite = _invites[index];
                      return _InviteCard(
                        time: invite.time,
                        clientName: invite.clientName,
                        jobTitle: invite.jobTitle,
                        description: invite.description,
                        onAccept: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Accepted invitation from ${invite.clientName}! Opening chat...',
                              ),
                              backgroundColor: AppColors.green,
                            ),
                          );
                          setState(() {
                            _invites.removeAt(index);
                          });
                        },
                        onDecline: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Declined invitation for "${invite.jobTitle}".',
                              ),
                              backgroundColor: AppColors.ink700,
                            ),
                          );
                          setState(() {
                            _invites.removeAt(index);
                          });
                        },
                      );
                    }, childCount: _invites.length),
                  ),
              ] else ...[
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 60,
                          horizontal: 24,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.ink300.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'No jobs match your search',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try adjusting your keywords, toggling off saved jobs, or changing filters.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.ink500,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        '${filtered.length} open jobs',
                        style: const TextStyle(
                          color: AppColors.ink500,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final job = filtered[index];
                      return _JobCard(
                        job: job,
                        searchQuery: _searchQuery,
                        onLikeToggle: () {
                          setState(() {
                            job.isLiked = !job.isLiked;
                          });
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                job.isLiked
                                    ? 'Job saved'
                                    : 'Job removed from saved',
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.navy,
                            ),
                          );
                        },
                        onDislikeToggle: () {
                          setState(() {
                            job.isDisliked = !job.isDisliked;
                          });
                        },
                        onExpandToggle: () {
                          setState(() {
                            job.isExpanded = !job.isExpanded;
                          });
                        },
                      );
                    }, childCount: filtered.length),
                  ),
                ],
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          if (_activeTab != 'Invites')
            Positioned(
              bottom: 16,
              right: 16,
              child: _isFABExtended
                  ? FloatingActionButton.extended(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      icon: const Icon(Icons.tune_rounded),
                      label: const Text(
                        'Filters',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _openFiltersSheet,
                    )
                  : FloatingActionButton(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      onPressed: _openFiltersSheet,
                      child: const Icon(Icons.tune_rounded),
                    ),
            ),
        ],
      ),
    );
  }
}

class _InviteCard extends StatelessWidget {
  final String time;
  final String clientName;
  final String jobTitle;
  final String description;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _InviteCard({
    required this.time,
    required this.clientName,
    required this.jobTitle,
    required this.description,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(color: AppColors.ink500, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Pending response',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            clientName,
            style: const TextStyle(
              color: AppColors.ink700,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            jobTitle,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink700,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Accept & Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final _MockJob job;
  final String searchQuery;
  final VoidCallback onLikeToggle;
  final VoidCallback onDislikeToggle;
  final VoidCallback onExpandToggle;

  const _JobCard({
    required this.job,
    required this.searchQuery,
    required this.onLikeToggle,
    required this.onDislikeToggle,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${job.timeAgo} • Proposals: ${job.proposals}',
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  job.isDisliked
                      ? Icons.thumb_down_rounded
                      : Icons.thumb_down_outlined,
                  size: 18,
                  color: job.isDisliked ? AppColors.saffron : AppColors.ink500,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDislikeToggle,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  job.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 18,
                  color: job.isLiked ? AppColors.green : AppColors.ink500,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onLikeToggle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: _highlightText(
                job.title,
                searchQuery,
                const TextStyle(
                  color: AppColors.navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${job.budgetType} - ${job.experienceLevel} - ${job.budgetInfo}',
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final text = job.description;
              final shouldTruncate = text.length > 140 && !job.isExpanded;
              final displayText = shouldTruncate
                  ? '${text.substring(0, 140)}...'
                  : text;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.ink700,
                        fontSize: 13.5,
                        height: 1.5,
                      ),
                      children: [
                        ..._highlightText(
                          displayText,
                          searchQuery,
                          const TextStyle(
                            color: AppColors.ink700,
                            fontSize: 13.5,
                            height: 1.5,
                          ),
                        ),
                        if (shouldTruncate) ...[
                          const TextSpan(
                            text: ' ',
                            style: TextStyle(color: AppColors.ink700),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: onExpandToggle,
                              child: const Text(
                                'more',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ),
                        ] else if (text.length > 140 && job.isExpanded) ...[
                          const TextSpan(
                            text: ' ',
                            style: TextStyle(color: AppColors.ink700),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: onExpandToggle,
                              child: const Text(
                                'less',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < job.skills.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cream100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: _highlightText(
                          job.skills[i],
                          searchQuery,
                          const TextStyle(
                            color: AppColors.navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  size: 15,
                  color: job.paymentVerified
                      ? AppColors.green
                      : AppColors.ink300,
                ),
                const SizedBox(width: 4),
                Text(
                  job.paymentVerified
                      ? 'Payment verified'
                      : 'Payment unverified',
                  style: TextStyle(
                    color: job.paymentVerified
                        ? AppColors.green
                        : AppColors.ink500,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                if (job.rating > 0) ...[
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.saffron,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    job.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  job.spent,
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.location_on_rounded,
                  size: 13,
                  color: AppColors.ink500,
                ),
                const SizedBox(width: 2),
                Text(
                  job.location,
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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

class ProposalsScreen extends StatefulWidget {
  const ProposalsScreen({super.key});

  @override
  State<ProposalsScreen> createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  String _activeMainTab = 'Active'; // Active, Referrals, Archived
  String _activeSubTab =
      'Discussing (1)'; // Offers (0), Invites (0), Discussing (1), Submitted (16)
  String _referralsSubTab =
      'Jobs referred to you (0)'; // Jobs referred to you (0), Freelancers you referred (0)
  String _archivedSubTab =
      'Proposals (6615)'; // Proposals (6615), Invites (551)

  Widget _buildSubTabPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : AppColors.border,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.ink700,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveContent() {
    if (_activeSubTab == 'Discussing (1)') {
      return Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Roofing',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '29 Jul 2026',
                    style: TextStyle(
                      color: AppColors.ink500,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Proposal sent with General Profile',
                style: TextStyle(color: AppColors.ink500, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    } else if (_activeSubTab == 'Submitted (16)') {
      final list = [
        ('Senior Flutter Engineer (UPI & Payments)', 'Nexelix Tech', '10m ago'),
        ('UI/UX Designer for Fintech Mobile App', 'Fintech Inc', '1d ago'),
      ];
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.$3,
                        style: const TextStyle(
                          color: AppColors.ink500,
                          fontSize: 11,
                        ),
                      ),
                      const Text(
                        'Submitted',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.$1,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Client: ${item.$2}',
                    style: const TextStyle(
                      color: AppColors.ink700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
          child: Text(
            'No items in ${_activeSubTab.split(' ').first}',
            style: const TextStyle(color: AppColors.ink500, fontSize: 14),
          ),
        ),
      );
    }
  }

  Widget _buildReferralsContent() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.cream100,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const Icon(
                Icons.card_giftcard_rounded,
                size: 64,
                color: AppColors.saffron,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "You haven't been referred yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'When declining an invitation, you can make a referral to help other freelancers succeed and help clients fill their job.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ink500,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Learn about referring freelancers',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchivedContent() {
    if (_archivedSubTab == 'Proposals (6615)') {
      final archivedList = [
        (
          'Ethiopian Health App Development',
          '6 Jul 2026',
          'Job is closed',
          'Proposal sent with General Profile',
        ),
        (
          'React Native Developer for Android App',
          '6 Jul 2026',
          'Job is closed',
          'Proposal sent with General Profile',
        ),
        (
          'Mobile app for preschool to K education resources',
          '6 Jul 2026',
          'Job is closed',
          'Proposal sent with General Profile',
        ),
        (
          'Senior Technical Advisor: Flutter & Firebase Consumer App',
          '6 Jul 2026',
          'Job is closed',
          '',
        ),
      ];
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: archivedList.length,
        itemBuilder: (context, index) {
          final item = archivedList[index];
          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.$2,
                        style: const TextStyle(
                          color: AppColors.ink500,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        item.$3,
                        style: const TextStyle(
                          color: AppColors.ink500,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.$1,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (item.$4.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.$4,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            'No archived invitations',
            style: TextStyle(color: AppColors.ink500, fontSize: 14),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainTabs = ['Active', 'Referrals', 'Archived'];

    return AppScaffold(
      currentRoute: '/proposals',
      body: CustomScrollView(
        slivers: [
          // Main Tab Headers
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final tab in mainTabs)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeMainTab = tab;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _activeMainTab == tab
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  color: _activeMainTab == tab
                                      ? Colors.black
                                      : AppColors.ink700,
                                  fontWeight: _activeMainTab == tab
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.cardBorder,
                  ),
                ],
              ),
            ),
          ),

          // Sub Tabs row
          SliverToBoxAdapter(
            child: switch (_activeMainTab) {
              'Active' => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    for (final sub in [
                      'Offers (0)',
                      'Invites (0)',
                      'Discussing (1)',
                      'Submitted (16)',
                    ]) ...[
                      _buildSubTabPill(sub, _activeSubTab == sub, () {
                        setState(() {
                          _activeSubTab = sub;
                        });
                      }),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              'Referrals' => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    for (final sub in [
                      'Jobs referred to you (0)',
                      'Freelancers you referred (0)',
                    ]) ...[
                      _buildSubTabPill(sub, _referralsSubTab == sub, () {
                        setState(() {
                          _referralsSubTab = sub;
                        });
                      }),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              'Archived' => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    for (final sub in [
                      'Proposals (6615)',
                      'Invites (551)',
                    ]) ...[
                      _buildSubTabPill(sub, _archivedSubTab == sub, () {
                        setState(() {
                          _archivedSubTab = sub;
                        });
                      }),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              _ => const SizedBox.shrink(),
            },
          ),

          // Main contents
          SliverToBoxAdapter(
            child: switch (_activeMainTab) {
              'Active' => _buildActiveContent(),
              'Referrals' => _buildReferralsContent(),
              'Archived' => _buildArchivedContent(),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  String _activeTab = 'All';

  @override
  Widget build(BuildContext context) {
    final subTabs = ['All', 'Hourly (5)', 'Active Milestones (1)', 'Awa...'];

    return AppScaffold(
      currentRoute: '/contracts',
      body: CustomScrollView(
        slivers: [
          // Earnings available now header
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Earnings available now:',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$0.00',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, size: 20),
                          color: AppColors.green,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Active contracts',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search Contracts
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Search contracts',
                        hintStyle: TextStyle(
                          color: AppColors.ink300,
                          fontSize: 13.5,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.ink500,
                          size: 18,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sub-tabs row
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        for (final tab in subTabs) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeTab = tab;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _activeTab == tab
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  color: _activeTab == tab
                                      ? Colors.black
                                      : AppColors.ink700,
                                  fontWeight: _activeTab == tab
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.cardBorder,
                  ),
                ],
              ),
            ),
          ),

          // Contract card list
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed('/workroom-timesheet'),
                          child: const Text(
                            'Native Mobile SDK for iOS and Android',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, size: 18),
                          color: AppColors.green,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hired by Jim Rising',
                    style: TextStyle(color: AppColors.navy, fontSize: 13.5),
                  ),
                  const Text(
                    'Jim Rising',
                    style: TextStyle(color: AppColors.ink700, fontSize: 13.5),
                  ),
                  const SizedBox(height: 12),
                  // Active Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '27:00 hrs, \$486.00',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(
                          text: ' this week',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Rate: \$18.00/hr, 40 hrs weekly limit',
                    style: TextStyle(color: AppColors.ink500, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jun 5, 2024 - Present',
                    style: TextStyle(color: AppColors.ink500, fontSize: 12.5),
                  ),
                  const SizedBox(height: 16),
                  // See timesheet button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.green,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed('/workroom-timesheet'),
                      child: const Text(
                        'See timesheet',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _searchController = TextEditingController();
  final _replyController = TextEditingController();
  String _searchQuery = '';
  int? _selectedChatIndex;

  final List<_ChatThread> _chats = const [
    _ChatThread(
      name: 'William Christofi',
      company: 'Trojan Smart Locks',
      project: 'Create website for Trojan smart locks',
      preview: 'William: Thanks mate',
      time: 'Tuesday',
      initials: 'WC',
      starred: false,
      online: true,
      budget: 'Fixed-price | ₹42,000',
      messages: [
        _ChatMessage(
          'Hi, can you update the smart lock landing page today?',
          false,
          '9:42 AM',
        ),
        _ChatMessage(
          'Yes William, I can start with the hero and pricing sections.',
          true,
          '9:46 AM',
        ),
        _ChatMessage('Thanks mate', false, '9:48 AM'),
      ],
    ),
    _ChatThread(
      name: 'Greg Quinn',
      company: 'Pixacast',
      project: 'Mobile App Development Agreement - Pure Edge',
      preview: 'You: How are you?',
      time: 'Monday',
      initials: 'GQ',
      starred: true,
      online: true,
      budget: 'Hourly | ₹1,200/hr',
      messages: [
        _ChatMessage(
          'Can we review the agreement before kickoff?',
          false,
          'Mon',
        ),
        _ChatMessage(
          'Sure. I will mark the delivery milestones clearly.',
          true,
          'Mon',
        ),
        _ChatMessage('How are you?', true, 'Mon'),
      ],
    ),
    _ChatThread(
      name: 'Jackson Davis',
      company: 'Jackson D',
      project: 'CloudKit storage debug and completion',
      preview: 'You: How are you?',
      time: 'Monday',
      initials: 'JD',
      starred: true,
      online: false,
      budget: 'Hourly | ₹950/hr',
      messages: [
        _ChatMessage(
          'The CloudKit sync is failing on fresh installs.',
          false,
          'Mon',
        ),
        _ChatMessage(
          'I found the issue. It is in the container entitlement.',
          true,
          'Mon',
        ),
      ],
    ),
    _ChatThread(
      name: 'Esma Platnumz',
      company: 'Esma P',
      project: 'Roofing',
      preview: 'You: can we have call here?',
      time: '30/7/2026',
      initials: 'EP',
      starred: false,
      online: true,
      budget: 'Fixed-price | ₹18,000',
      messages: [
        _ChatMessage(
          'I need a clean quote page for roofing leads.',
          false,
          '30 Jul',
        ),
        _ChatMessage('Can we have call here?', true, '30 Jul'),
      ],
    ),
    _ChatThread(
      name: 'Kevin Ross',
      company: 'Independent client',
      project: 'Relationship & Coaching App Build',
      preview: 'You: Hi Kevin, I reviewed the scope.',
      time: '27/7/2026',
      initials: 'KR',
      starred: true,
      online: false,
      budget: 'Milestone | ₹72,000',
      messages: [
        _ChatMessage(
          'The MVP needs chat, subscriptions, and video lessons.',
          false,
          '27 Jul',
        ),
        _ChatMessage(
          'Hi Kevin, I reviewed the scope. The MVP is doable in phases.',
          true,
          '27 Jul',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase();
    final filteredChats = _chats.where((chat) {
      return chat.name.toLowerCase().contains(query) ||
          chat.company.toLowerCase().contains(query) ||
          chat.project.toLowerCase().contains(query) ||
          chat.preview.toLowerCase().contains(query);
    }).toList();

    final selectedChat = _selectedChatIndex == null
        ? null
        : _chats[_selectedChatIndex!];

    return PopScope(
      canPop: selectedChat == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selectedChat != null) {
          setState(() => _selectedChatIndex = null);
        }
      },
      child: AppScaffold(
        currentRoute: '/messages',
        body: selectedChat == null
            ? _MessagesInbox(
                searchController: _searchController,
                filteredChats: filteredChats,
                onSearchChanged: (val) => setState(() => _searchQuery = val),
                onOpenChat: (chat) {
                  setState(() {
                    _selectedChatIndex = _chats.indexOf(chat);
                    _replyController.clear();
                  });
                },
              )
            : _ChatDetail(
                chat: selectedChat,
                replyController: _replyController,
                onBack: () => setState(() => _selectedChatIndex = null),
              ),
      ),
    );
  }
}

class _MessagesInbox extends StatelessWidget {
  const _MessagesInbox({
    required this.searchController,
    required this.filteredChats,
    required this.onSearchChanged,
    required this.onOpenChat,
  });

  final TextEditingController searchController;
  final List<_ChatThread> filteredChats;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<_ChatThread> onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.cream50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search messages',
                      hintStyle: TextStyle(
                        color: AppColors.ink500,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.ink500,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.outlined(
                icon: const Icon(Icons.tune_rounded, size: 20),
                color: AppColors.green,
                onPressed: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredChats.isEmpty
              ? const Center(
                  child: Text(
                    'No messages found',
                    style: TextStyle(
                      color: AppColors.ink500,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 84),
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    return _ChatListTile(
                      chat: chat,
                      onTap: () => onOpenChat(chat),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({required this.chat, required this.onTap});

  final _ChatThread chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChatAvatar(initials: chat.initials, online: chat.online),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (chat.starred) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.saffron,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            '${chat.name}, ${chat.company}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          chat.time,
                          style: const TextStyle(
                            color: AppColors.ink500,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.project,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      chat.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink900,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatDetail extends StatelessWidget {
  const _ChatDetail({
    required this.chat,
    required this.replyController,
    required this.onBack,
  });

  final _ChatThread chat;
  final TextEditingController replyController;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                color: AppColors.navy,
                onPressed: onBack,
              ),
              _ChatAvatar(
                initials: chat.initials,
                online: chat.online,
                radius: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      chat.project,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                color: AppColors.ink700,
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: const Color(0xfff7faf7),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 18,
                color: AppColors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${chat.budget} - Protected workroom',
                  style: const TextStyle(
                    color: AppColors.ink700,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            reverse: true,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            itemCount: chat.messages.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final message = chat.messages.reversed.toList()[index];
              return _MessageBubble(message: message);
            },
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, size: 22),
                  color: AppColors.green,
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: 42,
                      maxHeight: 96,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cream50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: TextField(
                      controller: replyController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Write a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 44,
                  height: 44,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => replyController.clear(),
                    child: const Icon(Icons.send_rounded, size: 19),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final align = message.fromMe
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final bg = message.fromMe ? AppColors.green : Colors.white;
    final fg = message.fromMe ? Colors.white : AppColors.ink900;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: message.fromMe
                ? null
                : Border.all(color: AppColors.cardBorder),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: fg, fontSize: 14, height: 1.35),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          message.time,
          style: const TextStyle(color: AppColors.ink500, fontSize: 11),
        ),
      ],
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({
    required this.initials,
    required this.online,
    this.radius = 22,
  });

  final String initials;
  final bool online;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.navy,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: radius * 0.68,
            ),
          ),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: online ? AppColors.green : AppColors.ink300,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatThread {
  const _ChatThread({
    required this.name,
    required this.company,
    required this.project,
    required this.preview,
    required this.time,
    required this.initials,
    required this.starred,
    required this.online,
    required this.budget,
    required this.messages,
  });

  final String name;
  final String company;
  final String project;
  final String preview;
  final String time;
  final String initials;
  final bool starred;
  final bool online;
  final String budget;
  final List<_ChatMessage> messages;
}

class _ChatMessage {
  const _ChatMessage(this.text, this.fromMe, this.time);

  final String text;
  final bool fromMe;
  final String time;
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _activeTab = 'Activity'; // Activity, Job alerts

  Widget _buildActivityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Most Recent',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _buildAlertItem(
          icon: Icons.person_outline_rounded,
          textSpans: const [
            TextSpan(
              text:
                  'A recent sign-in to your IndiaFreelancers account (p_brightroots) from an unknown device or browser.',
            ),
          ],
          date: '5 Aug',
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            'Earlier',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _buildAlertItem(
          icon: Icons.person_outline_rounded,
          textSpans: const [
            TextSpan(
              text:
                  'A recent sign-in to your IndiaFreelancers account (p_brightroots) from an unknown device or browser.',
            ),
          ],
          date: '3 Aug',
        ),
        _buildAlertItem(
          logoText: 'iF',
          textSpans: const [
            TextSpan(text: 'Top applicant: '),
            TextSpan(
              text: 'SMS specialist',
              style: TextStyle(
                color: AppColors.green,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          date: '3 Aug',
        ),
        _buildAlertItem(
          logoText: 'iF',
          textSpans: const [
            TextSpan(text: 'The work week has ended, and your '),
            TextSpan(
              text: 'weekly summary',
              style: TextStyle(
                color: AppColors.green,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ' is available for review.'),
          ],
          date: '3 Aug',
        ),
        _buildAlertItem(
          logoText: 'iF',
          textSpans: const [
            TextSpan(text: 'Top applicant: '),
            TextSpan(
              text: 'Web and Android App with AI Integration',
              style: TextStyle(
                color: AppColors.green,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          date: '1 Aug',
        ),
      ],
    );
  }

  Widget _buildJobAlertsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              Icon(Icons.settings_outlined, color: AppColors.green, size: 20),
              SizedBox(width: 8),
              Text(
                'Alert preferences',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildJobAlertItem(
          title: 'New job: Partner with Experienced Developer',
          date: '26 Jul',
        ),
        _buildJobAlertItem(
          title:
              'New job: React Native Developer – Health & Peptide Tracking App (MVP Build)',
          date: '26 Jun',
        ),
        _buildJobAlertItem(
          title: 'New job: Android/Telegram Expert',
          date: '20 Jun',
        ),
        _buildJobAlertItem(
          title: 'New job: AI Developer to Create a Mobile App and Website',
          date: '28 May',
        ),
        _buildJobAlertItem(
          title:
              'New job: Mobile App Developers to join Opinify.ai Needed for Android and iOS Projects',
          date: '22 May',
        ),
      ],
    );
  }

  Widget _buildAlertItem({
    IconData? icon,
    String? logoText,
    required List<TextSpan> textSpans,
    required String date,
  }) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.cream100,
                child: Icon(icon, color: AppColors.navy, size: 20),
              )
            else if (logoText != null)
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.navy,
                child: Text(
                  logoText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      children: textSpans,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.ink500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobAlertItem({required String title, required String date}) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.navy,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.ink500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Activity', 'Job alerts'];

    return AppScaffold(
      currentRoute: '/alerts',
      body: CustomScrollView(
        slivers: [
          // Alerts Tab Headers
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final tab in tabs)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeTab = tab;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _activeTab == tab
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  color: _activeTab == tab
                                      ? Colors.black
                                      : AppColors.ink700,
                                  fontWeight: _activeTab == tab
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.cardBorder,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: _activeTab == 'Activity'
                  ? _buildActivityContent()
                  : _buildJobAlertsContent(),
            ),
          ),
        ],
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      title: 'Terms',
      body: InfoPageContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Legal'),
            const SizedBox(height: 10),
            Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Effective date: July 19, 2026',
              style: TextStyle(color: AppColors.ink500, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const InfoAlert(
              child: Text(
                'This is a template. It has not been reviewed by a licensed attorney and should not be relied on as legal advice. Replace every bracketed placeholder below with your actual details, and have counsel qualified in Indian law review the final text before you rely on it.',
              ),
            ),
            const SizedBox(height: 24),
            for (final section in _termsSections) ...[
              Text(
                section.$1,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                section.$2,
                style: const TextStyle(color: AppColors.ink700, height: 1.85),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      title: 'Privacy',
      body: InfoPageContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Legal'),
            const SizedBox(height: 10),
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.navy,
                fontSize: _headingSize(context),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Effective date: July 19, 2026',
              style: TextStyle(color: AppColors.ink500, fontSize: 16),
            ),
            const SizedBox(height: 24),
            const InfoAlert(
              child: Text(
                "This is a template. It has not been reviewed by a licensed attorney and should not be relied on as legal advice. Replace every bracketed placeholder below with your actual company and contact details, and have counsel confirm this matches your obligations under India's Digital Personal Data Protection Act, 2023 before you rely on it.",
              ),
            ),
            const SizedBox(height: 24),
            for (final section in _privacySections) ...[
              Text(
                section.$1,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                section.$2,
                style: const TextStyle(color: AppColors.ink700, height: 1.85),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/login',
      showBottomNav: false,
      showBackButton: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: authCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: BrandLockup(compact: true)),
              const SizedBox(height: 24),
              const Text(
                'Reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email and we'll send you a reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.ink500, fontSize: 15),
              ),
              const SizedBox(height: 28),
              AuthTextField(
                label: 'Email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Send reset link',
                large: true,
                expanded: true,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/login'),
                  child: const Text(
                    'Back to sign in',
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double _headingSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 480) return 22;
  return 26;
}

const _termsSections = [
  (
    '1. Agreement to these Terms',
    'These Terms of Service govern your access to and use of indiafreelancers.com. By creating an account or using the Platform, you agree to these Terms and our Privacy Policy.',
  ),
  (
    '2. Who we are and what the Platform does',
    'IndiaFreelancers.com is an online marketplace connecting independent professionals with clients. We provide tools to post work, submit proposals, message, and process payments. We are not a party to contracts between users.',
  ),
  (
    '3. Eligibility and account registration',
    'You must be at least 18 years old and capable of forming a legally binding contract. You agree to provide accurate information and keep your account credentials secure.',
  ),
  (
    '6. Fees',
    'Creating an account, building a profile, posting jobs, and submitting proposals are free. When a client funds a milestone, we deduct a 10% service fee from the freelancer payout. Clients pay no additional marketplace fee.',
  ),
  (
    '7. Payments and Stripe',
    'All payments are processed by Stripe. We never collect or store your full card number. Funds are held until the client approves submitted work, then released to the freelancer minus the service fee.',
  ),
];

const _privacySections = [
  (
    '1. Who this policy covers',
    'This Privacy Policy explains how IndiaFreelancers.com collects, uses, discloses, and protects personal data when you use the Platform. It applies to Clients, Freelancers, and visitors.',
  ),
  (
    '2. Information we collect',
    'We collect account information (name, email, hashed password), profile information you choose to add, job and proposal data, messages, payment references via Stripe, reviews, and security/audit logs.',
  ),
  (
    '3. How we use your information',
    'We use your information to operate the marketplace, process payments, detect fraud, enforce our Terms, send transactional emails, respond to support requests, and comply with legal obligations. We do not sell your personal data.',
  ),
  (
    '5. How we share information',
    'We share information with other users as needed for the Platform to function, with Stripe for payments, and with infrastructure providers who help us run the service.',
  ),
];
