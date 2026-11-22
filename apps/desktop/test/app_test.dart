import 'package:ffs_di/ffs_di.dart';
import 'package:ffs_foundation/ffs_foundation.dart';
import 'package:ffs_navigation/ffs_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:freefileshare_desktop/di/injection.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  test('dependencies resolve', () {
    expect(getIt.isRegistered<Talker>(), isTrue);
  });

  testWidgets('app starts on the home page', (tester) async {
    await tester.pumpWidget(const FfsApp());
    await tester.pumpAndSettle();

    expect(find.text('No devices yet'), findsOneWidget);
  });
}
