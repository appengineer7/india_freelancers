import 'package:flutter/material.dart';

import '../controllers/messages_controller.dart';

class MessagesBinding extends StatefulWidget {
  const MessagesBinding({super.key, required this.child});

  final Widget child;

  static MessagesController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_MessagesControllerScope>();
    assert(scope != null, 'MessagesBinding not found in widget tree');
    return scope!.controller;
  }

  @override
  State<MessagesBinding> createState() => _MessagesBindingState();
}

class _MessagesBindingState extends State<MessagesBinding> {
  late final MessagesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MessagesController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MessagesControllerScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _MessagesControllerScope extends InheritedWidget {
  const _MessagesControllerScope({
    required this.controller,
    required super.child,
  });

  final MessagesController controller;

  @override
  bool updateShouldNotify(_MessagesControllerScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
