import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../auth/bindings/auth_binding.dart';
import '../../auth/view/auth_screen.dart';
import '../../jobs/bindings/jobs_binding.dart';
import '../../jobs/view/jobs_screen.dart';
import '../bindings/home_binding.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthBinding.of(context);

    return ListenableBuilder(
      listenable: authController,
      builder: (context, _) {
        if (authController.isLoggedIn) {
          return const JobsBinding(
            child: JobsScreen(),
          );
        }

        return const LoginScreen();
      },
    );
  }
}

class AppColors {
  static const primaryBlue = Color(0xff108a00);
  static const primaryBlueLight = Color(0xff14a800);
  static const navy = Color(0xff001e00);
  static const navy700 = Color(0xff173b18);
  static const green = Color(0xff108a00);
  static const green500 = Color(0xff14a800);
  static const green100 = Color(0xffe4ebe4);
  static const saffron = Color(0xfff56e06);
  static const saffron400 = Color(0xffff8a2b);
  static const saffron100 = Color(0xffffe9d5);
  static const cream50 = Color(0xfff7faf7);
  static const cream100 = Color(0xfff2f7f2);
  static const ink900 = Color(0xff001e00);
  static const ink700 = Color(0xff333333);
  static const ink500 = Color(0xff5e6d55);
  static const ink300 = Color(0xff9aaa97);
  static const border = Color(0xffd5e0d5);
  static const cardBorder = Color(0xffe4ebe4);
}

class _Constrained extends StatelessWidget {
  const _Constrained({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SiteConstrained(child: child);
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, this.compact = false, this.showText = true});

  final bool compact;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(compact ? 10 : 12),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: compact ? 36 : 44,
            height: compact ? 36 : 44,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        if (showText)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'IndiaFreelancers',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: compact ? 17 : 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  const _LogoMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final r = size.width * 0.18;
    final bg = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(1), Radius.circular(r)),
      bg,
    );

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;
    final center = rect.center;
    final radius = size.width * 0.28;

    stroke.color = AppColors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.55,
      math.pi * 0.82,
      false,
      stroke,
    );
    stroke.color = AppColors.navy700;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.38,
      math.pi * 0.75,
      false,
      stroke,
    );
    stroke.color = AppColors.saffron;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.04,
      math.pi * 0.45,
      false,
      stroke,
    );
    canvas.drawCircle(
      center,
      size.width * 0.075,
      Paint()..color = AppColors.navy,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Material(
        color: Colors.white,
        elevation: 0,
        shadowColor: AppColors.navy.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).pushNamed('/search'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: AppColors.ink300, size: 22),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Search skills or talent',
                    style: TextStyle(
                      color: AppColors.ink300,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.cream100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 18,
                    color: AppColors.ink700,
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

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlue, AppColors.navy700],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.18,
                child: Icon(
                  Icons.laptop_mac_rounded,
                  size: 140,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'India verified talent',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Hire the best\nfreelancers for\nany job',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Post projects, compare bids, and pay when you are happy.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    label: 'Get Started',
                    variant: ButtonVariant.light,
                    onTap: () => Navigator.of(context).pushNamed('/register'),
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

class AppStatsBar extends StatelessWidget {
  const AppStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('12.5K+', 'Freelancers'),
      ('4.8', 'Avg rating'),
      ('24h', 'Fast bids'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0)
                Container(width: 1, height: 36, color: AppColors.cardBorder),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stats[i].$1,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats[i].$2,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroEyebrow extends StatelessWidget {
  const _HeroEyebrow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        "India's BEST professional freelance marketplace",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width < 480 ? 28.0 : 34.0;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: FontWeight.w900,
          height: 1.02,
          letterSpacing: 0,
        ),
        children: const [
          TextSpan(text: 'Hire '),
          TextSpan(
            text: 'excellent talent',
            style: TextStyle(color: AppColors.saffron400),
          ),
          TextSpan(text: ' from India. Create with confidence.'),
        ],
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    final stats = HomeBinding.of(context).heroStats;
    final width = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = width < 400
            ? (constraints.maxWidth - 10) / 2
            : (constraints.maxWidth - 20) / 3;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final stat in stats)
              SizedBox(
                width: width < 640 ? itemWidth : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat.label,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.76),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeroVisualPainter(),
      child: Align(
        alignment: const Alignment(0.72, 0.05),
        child: MediaQuery.sizeOf(context).width < 900
            ? const SizedBox.shrink()
            : const _FloatingCards(),
      ),
    );
  }
}

class _HeroVisualPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xff173e20), Color(0xff0a2352), Color(0xff341808)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final rng = math.Random(7);
    for (var i = 0; i < 90; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = 1.5 + rng.nextDouble() * 7;
      final color = [
        AppColors.green500,
        AppColors.saffron400,
        Colors.white,
        AppColors.navy700,
      ][i % 4].withValues(alpha: 0.08 + rng.nextDouble() * 0.16);
      canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
    }

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 76) {
      canvas.drawLine(Offset(x, 0), Offset(x + 90, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 76) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 40), gridPaint);
    }

    final portraitPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.saffron400.withValues(alpha: 0.52),
              AppColors.green500.withValues(alpha: 0.26),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.76, size.height * 0.42),
              radius: size.width * 0.35,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.42),
      size.width * 0.35,
      portraitPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloatingCards extends StatelessWidget {
  const _FloatingCards();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      height: 360,
      child: Stack(
        children: const [
          Positioned(
            top: 8,
            left: 6,
            child: _ProfileCard(
              name: 'Aarav Sharma',
              role: 'Full-stack developer',
              rate: 'Rs 1,850/hr',
              tags: ['React', 'Laravel', 'GST'],
            ),
          ),
          Positioned(
            right: 10,
            bottom: 12,
            child: _ProfileCard(
              name: 'Meera Iyer',
              role: 'Brand designer',
              rate: 'Rs 1,400/hr',
              tags: ['Logo', 'UI', 'Motion'],
              saffron: true,
            ),
          ),
          Positioned(top: 160, right: 40, child: _LiveChip()),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.name,
    required this.role,
    required this.rate,
    required this.tags,
    this.saffron = false,
  });

  final String name;
  final String role;
  final String rate;
  final List<String> tags;
  final bool saffron;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: saffron ? AppColors.saffron100 : AppColors.green100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  saffron ? Icons.brush_rounded : Icons.code_rounded,
                  color: saffron ? AppColors.saffron : AppColors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      role,
                      overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final tag in tags)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: saffron ? AppColors.saffron100 : AppColors.green100,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: saffron ? AppColors.saffron : AppColors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rate,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Star 4.9',
                style: TextStyle(
                  color: AppColors.saffron,
                  fontWeight: FontWeight.w900,
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

class _LiveChip extends StatelessWidget {
  const _LiveChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.green500, AppColors.green],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withValues(alpha: 0.36),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text(
            'Verified Indian talent',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  static const _iconColors = [
    (Color(0xffe8f1ff), AppColors.primaryBlue),
    (Color(0xfff0e8ff), Color(0xff7c3aed)),
    (Color(0xffe8f8ef), AppColors.green),
    (Color(0xfffff0e6), AppColors.saffron),
    (Color(0xffffe8f0), Color(0xffe11d48)),
    (Color(0xfff0f2f5), AppColors.ink500),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = HomeBinding.of(context).categories;
    final displayItems = categories.take(5).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/search'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.92,
            children: [
              for (var i = 0; i < displayItems.length; i++)
                _AppCategoryTile(
                  icon: displayItems[i].icon,
                  title: _shortTitle(displayItems[i].title),
                  bgColor: _iconColors[i].$1,
                  iconColor: _iconColors[i].$2,
                ),
              _AppCategoryTile(
                icon: Icons.apps_rounded,
                title: 'More',
                bgColor: _iconColors[5].$1,
                iconColor: _iconColors[5].$2,
                onTap: () => Navigator.of(context).pushNamed('/search'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _shortTitle(String title) {
    if (title.contains('&')) {
      return title.split('&').first.trim();
    }
    if (title.contains(' ')) {
      return title.split(' ').first;
    }
    return title;
  }
}

class _AppCategoryTile extends StatelessWidget {
  const _AppCategoryTile({
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ?? () => Navigator.of(context).pushNamed('/register'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.navy,
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

class TopFreelancersSection extends StatelessWidget {
  const TopFreelancersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final freelancers = HomeBinding.of(context).topFreelancers;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Rated Freelancers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/search'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: freelancers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final f = freelancers[index];
                return _FreelancerCard(freelancer: f);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FreelancerCard extends StatelessWidget {
  const _FreelancerCard({required this.freelancer});

  final HomeFreelancer freelancer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: freelancer.avatarColor,
                child: Text(
                  freelancer.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.star_rounded,
                color: AppColors.saffron,
                size: 16,
              ),
              const SizedBox(width: 2),
              Text(
                freelancer.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            freelancer.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            freelancer.role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.ink500, fontSize: 11),
          ),
          const Spacer(),
          Text(
            freelancer.rate,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 400;

    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).pushNamed('/register'),
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 38 : 42,
                height: compact ? 38 : 42,
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.green,
                  size: compact ? 20 : 22,
                ),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: compact ? 13 : 15,
                  height: 1.2,
                ),
              ),
              SizedBox(height: compact ? 4 : 6),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.ink500,
                  fontSize: compact ? 11 : 12,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepsSection extends StatelessWidget {
  const StepsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeBinding.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.cream100),
      child: SectionShell(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stack = constraints.maxWidth < 820;
            final clients = _StepColumn(
              eyebrow: 'For clients',
              title: 'Post work, review proposals, hire with clarity',
              button: AppButton(
                label: 'Start hiring',
                variant: ButtonVariant.secondary,
                onTap: () => Navigator.of(context).pushNamed('/register'),
              ),
              steps: controller.clientSteps,
            );
            final freelancers = _StepColumn(
              eyebrow: 'For freelancers',
              title: 'Build a profile that wins the right work',
              button: AppButton(
                label: 'Create your profile',
                variant: ButtonVariant.saffron,
                onTap: () => Navigator.of(context).pushNamed('/register'),
              ),
              steps: controller.freelancerSteps,
            );
            return stack
                ? Column(
                    children: [
                      clients,
                      const SizedBox(height: 44),
                      freelancers,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: clients),
                      const SizedBox(width: 56),
                      Expanded(child: freelancers),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _StepColumn extends StatelessWidget {
  const _StepColumn({
    required this.eyebrow,
    required this.title,
    required this.steps,
    required this.button,
  });

  final String eyebrow;
  final String title;
  final List<HomeStepInfo> steps;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final isClient = eyebrow == 'For clients';
    final accent = isClient ? AppColors.green : AppColors.saffron;
    final accentSoft = isClient ? AppColors.green100 : AppColors.saffron100;
    final icon = isClient
        ? Icons.business_center_rounded
        : Icons.workspace_premium_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.06),
            blurRadius: 18,
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(eyebrow, color: accent),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < steps.length; i++) ...[
            NumberedStep(
              number: i + 1,
              title: steps[i].title,
              body: steps[i].body,
              accent: accent,
              accentSoft: accentSoft,
            ),
            if (i != steps.length - 1) const SizedBox(height: 12),
          ],
          const SizedBox(height: 22),
          SizedBox(width: double.infinity, child: button),
        ],
      ),
    );
  }
}

class NumberedStep extends StatelessWidget {
  const NumberedStep({
    super.key,
    required this.number,
    required this.title,
    required this.body,
    this.accent = AppColors.green,
    this.accentSoft = AppColors.green100,
  });

  final int number;
  final String title;
  final String body;
  final Color accent;
  final Color accentSoft;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accentSoft,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Text(
              '$number',
              style: TextStyle(color: accent, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.ink500,
                    fontSize: 13,
                    height: 1.42,
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

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = HomeBinding.of(context).trustCards;

    return ColoredBox(
      color: AppColors.cream100,
      child: SectionShell(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 18,
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
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.saffron100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.saffron,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow(
                          'Trust & safety',
                          color: AppColors.saffron,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Built for trust before growth',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                height: 1.18,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stack = constraints.maxWidth < 780;
                  return stack
                      ? Column(
                          children: [
                            for (final card in cards) ...[
                              TrustCard(
                                icon: card.icon,
                                title: card.title,
                                body: card.body,
                              ),
                              if (card != cards.last)
                                const SizedBox(height: 12),
                            ],
                          ],
                        )
                      : Row(
                          children: [
                            for (final card in cards) ...[
                              Expanded(
                                child: TrustCard(
                                  icon: card.icon,
                                  title: card.title,
                                  body: card.body,
                                ),
                              ),
                              if (card != cards.last) const SizedBox(width: 12),
                            ],
                          ],
                        );
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: 'See full trust & safety',
                  variant: ButtonVariant.light,
                  onTap: () => Navigator.of(context).pushNamed('/trust'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrustCard extends StatelessWidget {
  const TrustCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream50,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.green100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.green),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.ink500,
              fontSize: 13,
              height: 1.42,
            ),
          ),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cream100,
      child: SectionShell(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('About', color: AppColors.green),
              const SizedBox(height: 8),
              Text(
                'India’s professional freelance marketplace',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'IndiaFreelancers.com connects skilled Indian professionals with clients in India and worldwide — with clear pricing, strong identity and payment controls, and no dark patterns.',
                style: TextStyle(
                  color: AppColors.ink500,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              AppButton(
                label: 'Learn more about us',
                variant: ButtonVariant.saffron,
                expanded: false,
                onTap: () => Navigator.of(context).pushNamed('/about'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navy.withValues(alpha: 0.07),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.green100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    color: AppColors.green,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ready to get started?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create your free account and start hiring or finding work today.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.ink500,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Create your free account',
                    large: true,
                    onTap: () => Navigator.of(context).pushNamed('/register'),
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

class SectionShell extends StatelessWidget {
  const SectionShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Constrained(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: child,
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = AppColors.green});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }
}

enum ButtonVariant { primary, secondary, saffron, light, heroGhost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.variant = ButtonVariant.primary,
    this.dense = false,
    this.large = false,
    this.expanded = false,
    this.onTap,
  });

  final String label;
  final ButtonVariant variant;
  final bool dense;
  final bool large;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final filled = switch (variant) {
      ButtonVariant.primary => const [AppColors.green500, AppColors.green],
      ButtonVariant.secondary => const [AppColors.navy700, AppColors.navy],
      ButtonVariant.saffron => const [AppColors.saffron400, AppColors.saffron],
      ButtonVariant.light || ButtonVariant.heroGhost => null,
    };
    final foreground = switch (variant) {
      ButtonVariant.light || ButtonVariant.heroGhost => AppColors.navy700,
      _ => Colors.white,
    };
    final background = filled == null ? Colors.white : null;
    final padding = EdgeInsets.symmetric(
      horizontal: large
          ? 30
          : dense
          ? 16
          : 22,
      vertical: large
          ? 16
          : dense
          ? 9
          : 13,
    );

    final button = DecoratedBox(
      decoration: BoxDecoration(
        gradient: filled == null ? null : LinearGradient(colors: filled),
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              variant == ButtonVariant.light ||
                  variant == ButtonVariant.heroGhost
              ? AppColors.border
              : Colors.transparent,
        ),
        boxShadow: [
          if (variant != ButtonVariant.light)
            BoxShadow(
              color:
                  (variant == ButtonVariant.saffron
                          ? AppColors.saffron
                          : AppColors.green)
                      .withValues(alpha: 0.24),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: padding,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w900,
                fontSize: large
                    ? 16
                    : dense
                    ? 13
                    : 14,
              ),
            ),
          ),
        ),
      ),
    );
    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
