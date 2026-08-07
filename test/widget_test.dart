import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:india_freelancers/main.dart';

void main() {
  testWidgets('renders IndiaFreelancers app home and info screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/how-it-works');
    await tester.pumpAndSettle();
    expect(find.text('HOW IT WORKS'), findsOneWidget);
  });

  testWidgets('renders auth routes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1600));
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
  });
}
