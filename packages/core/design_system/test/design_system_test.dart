import 'package:ffs_design_system/ffs_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

void main() {
  group('formatBytes', () {
    test('formats each unit', () {
      expect(formatBytes(512), '512 B');
      expect(formatBytes(1536), '1.5 KB');
      expect(formatBytes(150 * 1024 * 1024), '150 MB');
      expect(formatBytes(3 * 1024 * 1024 * 1024), '3.0 GB');
    });
  });

  testWidgets('DeviceCard shows name and status and handles taps', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        DeviceCard(
          name: 'Pixel 9',
          kind: DeviceKind.phone,
          status: DeviceStatus.connected,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Pixel 9'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);
    expect(find.byIcon(Icons.smartphone), findsOneWidget);

    await tester.tap(find.byType(DeviceCard));
    expect(tapped, isTrue);
  });

  testWidgets('TransferProgressTile shows percentage and sizes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const TransferProgressTile(
          fileName: 'holiday.mp4',
          totalBytes: 1000,
          transferredBytes: 250,
        ),
      ),
    );

    expect(find.text('25%'), findsOneWidget);
    expect(find.text('250 B of 1000 B'), findsOneWidget);
  });

  testWidgets('AppButton is disabled while loading', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      _wrap(
        AppButton(
          label: 'Send',
          isLoading: true,
          onPressed: () => pressed = true,
        ),
      ),
    );

    await tester.tap(find.text('Send'));
    expect(pressed, isFalse);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
