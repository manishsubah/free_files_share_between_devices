/// Shared GetIt instance and dependency injection environments.
library;

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

abstract final class Envs {
  static const desktop = Environment('desktop');
  static const mobile = Environment('mobile');
}
