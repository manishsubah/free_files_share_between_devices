import 'package:ffs_design_system/ffs_design_system.dart';
import 'package:flutter/material.dart';

import '../router/app_router.dart';

class FfsApp extends StatefulWidget {
  const FfsApp({super.key, this.router});

  final AppRouter? router;

  @override
  State<FfsApp> createState() => _FfsAppState();
}

class _FfsAppState extends State<FfsApp> {
  late final AppRouter _router = widget.router ?? AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Free File Share',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _router.config(),
    );
  }
}
