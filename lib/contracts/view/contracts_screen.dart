import 'package:flutter/material.dart';

import '../../pages/info_pages.dart' as legacy;
import '../bindings/contracts_binding.dart';

class ContractsScreen extends StatelessWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContractsBinding(child: legacy.ContractsScreen());
  }
}
