import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Base type for expected errors. Each feature defines its own sealed
/// failure union that implements this.
abstract interface class Failure {
  String get message;
}

@freezed
sealed class AppFailure with _$AppFailure implements Failure {
  const AppFailure._();

  const factory AppFailure.unexpected({
    required Object error,
    StackTrace? stackTrace,
  }) = UnexpectedFailure;

  const factory AppFailure.cancelled() = CancelledFailure;

  const factory AppFailure.permissionDenied({required String permission}) =
      PermissionDeniedFailure;

  @override
  String get message => switch (this) {
    UnexpectedFailure(:final error) => 'Unexpected error: $error',
    CancelledFailure() => 'Cancelled',
    PermissionDeniedFailure(:final permission) =>
      'Permission denied: $permission',
  };
}
