import 'package:fpdart/fpdart.dart';

import '../failure/failure.dart';

/// Runs [run] and turns any thrown error into an [AppFailure.unexpected].
///
/// Data-layer code uses this so domain and presentation never see exceptions.
TaskEither<AppFailure, T> guard<T>(Future<T> Function() run) =>
    TaskEither.tryCatch(
      run,
      (error, stackTrace) =>
          AppFailure.unexpected(error: error, stackTrace: stackTrace),
    );
