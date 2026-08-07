import 'package:flutter/material.dart';

import '../controllers/contracts_controller.dart';

class ContractsBinding extends StatefulWidget {
  const ContractsBinding({super.key, required this.child});

  final Widget child;

  static ContractsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ContractsScope>();
    assert(scope != null, 'ContractsBinding not found in widget tree');
    return scope!.controller;
  }

  @override
  State<ContractsBinding> createState() => _ContractsBindingState();
}

class _ContractsBindingState extends State<ContractsBinding> {
  late final ContractsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ContractsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ContractsScope(controller: _controller, child: widget.child);
  }
}

class _ContractsScope extends InheritedWidget {
  const _ContractsScope({required this.controller, required super.child});

  final ContractsController controller;

  @override
  bool updateShouldNotify(_ContractsScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
