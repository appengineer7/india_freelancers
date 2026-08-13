import 'package:flutter/material.dart';

import '../controllers/dashboard_controller.dart';
import '../models/dashboard_page_model.dart';

class DashboardBinding extends StatefulWidget {
  const DashboardBinding({super.key, required this.page, required this.child});

  final DashboardPageModel page;
  final Widget child;

  static DashboardController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_DashboardScope>();
    assert(scope != null, 'DashboardBinding not found in widget tree');
    return scope!.controller;
  }

  @override
  State<DashboardBinding> createState() => _DashboardBindingState();
}

class _DashboardBindingState extends State<DashboardBinding> {
  late DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController(widget.page);
  }

  @override
  void didUpdateWidget(covariant DashboardBinding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.kind != widget.page.kind) {
      _controller.dispose();
      _controller = DashboardController(widget.page);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DashboardScope(controller: _controller, child: widget.child);
  }
}

class _DashboardScope extends InheritedWidget {
  const _DashboardScope({required this.controller, required super.child});

  final DashboardController controller;

  @override
  bool updateShouldNotify(_DashboardScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
