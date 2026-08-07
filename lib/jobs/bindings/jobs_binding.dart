import 'package:flutter/material.dart';

import '../controllers/jobs_controller.dart';

class JobsBinding extends StatefulWidget {
  const JobsBinding({super.key, required this.child});

  final Widget child;

  static JobsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_JobsScope>();
    assert(scope != null, 'JobsBinding not found in widget tree');
    return scope!.controller;
  }

  @override
  State<JobsBinding> createState() => _JobsBindingState();
}

class _JobsBindingState extends State<JobsBinding> {
  late final JobsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = JobsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _JobsScope(controller: _controller, child: widget.child);
  }
}

class _JobsScope extends InheritedWidget {
  const _JobsScope({required this.controller, required super.child});

  final JobsController controller;

  @override
  bool updateShouldNotify(_JobsScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
