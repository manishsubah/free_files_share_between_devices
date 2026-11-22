import 'package:ffs_di/ffs_di.dart';
import 'package:ffs_foundation/ffs_foundation.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

@InjectableInit(
  externalPackageModulesBefore: [ExternalModule(FfsFoundationPackageModule)],
)
Future<void> configureDependencies() async =>
    getIt.init(environment: Envs.mobile.name);
