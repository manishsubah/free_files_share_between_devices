import 'dart:async';

import 'package:ffs_di/ffs_di.dart';
import 'package:ffs_foundation/ffs_foundation.dart';
import 'package:ffs_navigation/ffs_navigation.dart';
import 'package:flutter/material.dart';

import 'di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final talker = getIt<Talker>();
  FlutterError.onError = (details) =>
      talker.handle(details.exception, details.stack);

  talker.info('Free File Share (Windows) started');
  runApp(const FfsApp());
}
