import 'package:flutter_test/flutter_test.dart';

import 'package:sustainabowl_mobile/app.dart';

void main() {
  testWidgets('shows the SustainaBowl landing page', (tester) async {
    await tester.pumpWidget(const SustainaBowlApp());

    expect(find.text('SustainaBowl'), findsOneWidget);
  });

  testWidgets('bottom navigation reaches every module page', (tester) async {
    await tester.pumpWidget(const SustainaBowlApp());

    final cases = {
      'Accounts': 'Accounts module',
      'Catalog': 'Catalog module',
      // Tanpa token login, tab Orders menampilkan ajakan login.
      'Orders': 'Log in to see your orders',
      'Map': 'Map module',
      'Reviews': 'Pilih menu terlebih dahulu',
    };

    for (final entry in cases.entries) {
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget);
    }
  });
}
