// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:ffs_foundation/src/logging/logging_module.dart' as _i503;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker/talker.dart' as _i993;

class FfsFoundationPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final loggingModule = _$LoggingModule();
    gh.singleton<_i993.Talker>(() => loggingModule.talker);
  }
}

class _$LoggingModule extends _i503.LoggingModule {}
