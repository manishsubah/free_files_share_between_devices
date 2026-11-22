import 'package:auto_route/auto_route.dart';
import 'package:ffs_design_system/ffs_design_system.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free File Share')),
      body: const EmptyState(
        icon: Icons.devices_other_outlined,
        title: 'No devices yet',
        message:
            'Open Free File Share on your other device. '
            'Nearby devices will appear here.',
      ),
    );
  }
}
