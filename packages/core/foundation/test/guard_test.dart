import 'package:ffs_foundation/ffs_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('guard', () {
    test('returns Right with the value when run succeeds', () async {
      final result = await guard(() async => 42).run();

      expect(result, const Right<AppFailure, int>(42));
    });

    test('returns Left(UnexpectedFailure) when run throws', () async {
      final result = await guard<int>(() async => throw StateError('boom'))
          .run();

      final failure = result.getLeft().toNullable();
      expect(failure, isA<UnexpectedFailure>());
      expect(failure!.message, contains('boom'));
    });
  });

  group('AppFailure', () {
    test('has value equality', () {
      expect(
        const AppFailure.permissionDenied(permission: 'storage'),
        const AppFailure.permissionDenied(permission: 'storage'),
      );
    });

    test('message describes each case', () {
      expect(const AppFailure.cancelled().message, 'Cancelled');
      expect(
        const AppFailure.permissionDenied(permission: 'bluetooth').message,
        'Permission denied: bluetooth',
      );
    });
  });
}
