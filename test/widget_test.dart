import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:india_freelancers/main.dart';

void main() {
  testWidgets('renders IndiaFreelancers landing page', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('IndiaFreelancers.com connects'), findsOneWidget);
    expect(
      find.text("India's BEST professional freelance marketplace"),
      findsOneWidget,
    );
    expect(find.text('Get started'), findsOneWidget);

    await _scrollUntilFound(tester, find.text('Development & IT'));
    expect(find.text('Development & IT'), findsOneWidget);

    await _scrollUntilFound(
      tester,
      find.text('Built for trust before growth'),
    );
    expect(find.text('Built for trust before growth'), findsOneWidget);
  });

  testWidgets('renders auth routes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/login');
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);

    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Country code'), findsOneWidget);

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Check your inbox'), findsOneWidget);
    expect(find.text('Back to sign in'), findsOneWidget);
  });
}

Future<void> _scrollUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 8 && finder.evaluate().isEmpty; i++) {
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();
  }
}
