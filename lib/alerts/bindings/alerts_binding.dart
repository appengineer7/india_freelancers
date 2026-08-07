import 'package:flutter/material.dart';

import '../controllers/alerts_controller.dart';

class AlertsBinding extends StatefulWidget {
  const AlertsBinding({super.key, required this.child});

  final Widget child;

  static AlertsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AlertsScope>();
    assert(scope != null, 'AlertsBinding not found in widget tree');
    return scope!.controller;
  }

  @override
  State<AlertsBinding> createState() => _AlertsBindingState();
}

class _AlertsBindingState extends State<AlertsBinding> {
  late final AlertsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AlertsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AlertsScope(controller: _controller, child: widget.child);
  }
}

class _AlertsScope extends InheritedWidget {
  const _AlertsScope({required this.controller, required super.child});

  final AlertsController controller;

  @override
  bool updateShouldNotify(_AlertsScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
