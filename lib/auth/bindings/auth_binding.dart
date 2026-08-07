import 'package:flutter/widgets.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends StatefulWidget {
  const AuthBinding({super.key, required this.child});

  final Widget child;

  static AuthController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AuthScope>();
    assert(scope != null, 'AuthBinding was not found above this context.');
    return scope!.controller;
  }

  @override
  State<AuthBinding> createState() => _AuthBindingState();
}

class _AuthBindingState extends State<AuthBinding> {
  static final AuthController _sharedController = AuthController();
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _sharedController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AuthScope(controller: _controller, child: widget.child);
  }
}

class _AuthScope extends InheritedNotifier<AuthController> {
  const _AuthScope({
    required this.controller,
    required super.child,
  }) : super(notifier: controller);

  final AuthController controller;
}
