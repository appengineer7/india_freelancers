import 'package:flutter/material.dart';

import '../controllers/proposals_controller.dart';

class ProposalsBinding extends StatefulWidget {
  const ProposalsBinding({super.key, required this.child});

  final Widget child;

  static ProposalsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ProposalsScope>();
    assert(scope != null, 'ProposalsBinding not found in widget tree');
    return scope!.controller;
  }

  @override
  State<ProposalsBinding> createState() => _ProposalsBindingState();
}

class _ProposalsBindingState extends State<ProposalsBinding> {
  late final ProposalsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProposalsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProposalsScope(controller: _controller, child: widget.child);
  }
}

class _ProposalsScope extends InheritedWidget {
  const _ProposalsScope({required this.controller, required super.child});

  final ProposalsController controller;

  @override
  bool updateShouldNotify(_ProposalsScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
