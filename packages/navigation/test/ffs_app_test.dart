import 'package:ffs_navigation/ffs_navigation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FfsApp opens on the home page', (tester) async {
    await tester.pumpWidget(const FfsApp());
    await tester.pumpAndSettle();

    expect(find.text('Free File Share'), findsOneWidget);
    expect(find.text('No devices yet'), findsOneWidget);
  });
}
