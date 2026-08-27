import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  String routeForLink(String label) => switch (label) {
    'Find work' => '/find-work',
    'How it works' => '/how-it-works',
    'Pricing' => '/pricing',
    'Trust & safety' => '/trust',
    'About' => '/about',
    'Contact' => '/contact',
    'Sign in' => '/login',
    'Join free' => '/register',
    'Post a job' => '/register',
    'Create a profile' => '/register',
    'Help center' => '/help',
    'Terms' => '/legal/terms',
    'Privacy' => '/legal/privacy',
    _ => '/',
  };

  List<String> get navLinks => const [
    'Find work',
    'How it works',
    'Pricing',
    'Trust & safety',
    'About',
  ];

  List<String> get drawerLinks => const [
    'Find work',
    'How it works',
    'Pricing',
    'Trust & safety',
    'About',
    'Contact',
  ];

  List<HomeFreelancer> get topFreelancers => const [
    HomeFreelancer(
      initials: 'RS',
      name: 'Rahul Sharma',
      role: 'Full Stack Developer',
      rate: '₹1,850/hr',
      rating: 4.9,
      avatarColor: Color(0xff0066ff),
    ),
    HomeFreelancer(
      initials: 'PP',
      name: 'Priya Patel',
      role: 'UI/UX Designer',
      rate: '₹1,400/hr',
      rating: 4.8,
      avatarColor: Color(0xff7c3aed),
    ),
    HomeFreelancer(
      initials: 'AK',
      name: 'Amit Kumar',
      role: 'Digital Marketer',
      rate: '₹1,200/hr',
      rating: 4.7,
      avatarColor: Color(0xff0d8236),
    ),
    HomeFreelancer(
      initials: 'MI',
      name: 'Meera Iyer',
      role: 'Brand Designer',
      rate: '₹1,600/hr',
      rating: 4.9,
      avatarColor: Color(0xfff56e06),
    ),
  ];

  List<HomeStat> get heroStats => const [
    HomeStat(value: '12', label: 'professional categories'),
    HomeStat(
      value: 'Argon2id + audit logging',
      label: 'security built in from day one',
    ),
    HomeStat(value: 'India-first', label: 'GST & TDS-aware from the ground up'),
  ];

  List<HomeCategory> get categories => const [
    HomeCategory(
      icon: Icons.code_rounded,
      title: 'Development & IT',
      subtitle: 'Web, mobile, DevOps & QA',
    ),
    HomeCategory(
      icon: Icons.memory_rounded,
      title: 'AI & Data',
      subtitle: 'ML, data engineering & analytics',
    ),
    HomeCategory(
      icon: Icons.edit_rounded,
      title: 'Design & Creative',
      subtitle: 'Product, brand & motion design',
    ),
    HomeCategory(
      icon: Icons.campaign_rounded,
      title: 'Sales & Marketing',
      subtitle: 'Growth, SEO & performance marketing',
    ),
    HomeCategory(
      icon: Icons.draw_rounded,
      title: 'Writing & Translation',
      subtitle: 'Content, copy & localisation',
    ),
    HomeCategory(
      icon: Icons.support_agent_rounded,
      title: 'Admin & Customer Support',
      subtitle: 'Virtual assistance & support',
    ),
    HomeCategory(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Finance & Accounting',
      subtitle: 'Bookkeeping, tax & analysis',
    ),
    HomeCategory(
      icon: Icons.architecture_rounded,
      title: 'Engineering & Architecture',
      subtitle: 'CAD, structural & civil',
    ),
    HomeCategory(
      icon: Icons.balance_rounded,
      title: 'Legal',
      subtitle: 'Contracts, compliance & IP',
    ),
    HomeCategory(
      icon: Icons.groups_rounded,
      title: 'HR & Training',
      subtitle: 'Recruiting & L&D',
    ),
    HomeCategory(
      icon: Icons.smart_display_rounded,
      title: 'Video & Audio',
      subtitle: 'Editing, animation & sound',
    ),
    HomeCategory(
      icon: Icons.lightbulb_rounded,
      title: 'Consulting',
      subtitle: 'Strategy & business advisory',
    ),
  ];

  List<HomeStepInfo> get clientSteps => const [
    HomeStepInfo(
      title: 'Describe the work',
      body:
          'Post a fixed-price or hourly job in minutes, or invite a freelancer directly.',
    ),
    HomeStepInfo(
      title: 'Compare proposals',
      body:
          'Review cover letters, portfolios and verification status side by side.',
    ),
    HomeStepInfo(
      title: 'Hire and collaborate',
      body: 'Message, share files and track milestones in one shared workroom.',
    ),
  ];

  List<HomeStepInfo> get freelancerSteps => const [
    HomeStepInfo(
      title: 'Create your profile',
      body:
          'Showcase skills, portfolio, rate and availability in a clean, credible layout.',
    ),
    HomeStepInfo(
      title: 'Apply with intent',
      body:
          'Send tailored proposals to jobs that match your skills and schedule.',
    ),
    HomeStepInfo(
      title: 'Get paid transparently',
      body:
          'Track milestones and payouts with a clear, auditable record - always.',
    ),
  ];

  List<HomeTrustCard> get trustCards => const [
    HomeTrustCard(
      icon: Icons.lock_rounded,
      title: 'Hardened accounts',
      body:
          'Argon2id password hashing, session rotation, device management and rate-limited login.',
    ),
    HomeTrustCard(
      icon: Icons.assignment_rounded,
      title: 'Auditable by design',
      body:
          'Every privileged and financial action is logged server-side - nothing is trusted from the client.',
    ),
    HomeTrustCard(
      icon: Icons.balance_rounded,
      title: 'No dark patterns',
      body:
          'Clear pricing, plain-language policies, and moderation that a human can explain.',
    ),
  ];

  List<HomeFooterColumn> get footerColumns => const [
    HomeFooterColumn(
      title: 'For clients',
      links: ['How it works', 'Pricing', 'Post a job'],
    ),
    HomeFooterColumn(
      title: 'For freelancers',
      links: ['Create a profile', 'Trust & safety', 'Help center'],
    ),
    HomeFooterColumn(
      title: 'Company',
      links: ['About', 'Contact', 'Terms', 'Privacy'],
    ),
  ];
}

class HomeStat {
  const HomeStat({required this.value, required this.label});

  final String value;
  final String label;
}

class HomeCategory {
  const HomeCategory({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class HomeStepInfo {
  const HomeStepInfo({required this.title, required this.body});

  final String title;
  final String body;
}

class HomeTrustCard {
  const HomeTrustCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class HomeFooterColumn {
  const HomeFooterColumn({required this.title, required this.links});

  final String title;
  final List<String> links;
}

class HomeFreelancer {
  const HomeFreelancer({
    required this.initials,
    required this.name,
    required this.role,
    required this.rate,
    required this.rating,
    required this.avatarColor,
  });

  final String initials;
  final String name;
  final String role;
  final String rate;
  final double rating;
  final Color avatarColor;
}
