import 'package:flutter/material.dart';

import '../../pages/info_pages.dart' as legacy;
import '../bindings/proposals_binding.dart';

class ProposalsScreen extends StatelessWidget {
  const ProposalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProposalsBinding(child: legacy.ProposalsScreen());
  }
}
