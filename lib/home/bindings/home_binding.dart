import 'package:flutter/widgets.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends StatefulWidget {
  const HomeBinding({super.key, required this.child});

  final Widget child;

  static HomeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_HomeScope>();
    assert(scope != null, 'HomeBinding was not found above this context.');
    return scope!.controller;
  }

  @override
  State<HomeBinding> createState() => _HomeBindingState();
}

class _HomeBindingState extends State<HomeBinding> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _HomeScope(controller: _controller, child: widget.child);
  }
}

class _HomeScope extends InheritedNotifier<HomeController> {
  const _HomeScope({
    required this.controller,
    required super.child,
  }) : super(notifier: controller);

  final HomeController controller;
}
