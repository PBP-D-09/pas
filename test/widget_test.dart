import 'package:flutter_test/flutter_test.dart';

import 'package:sustainabowl_mobile/app.dart';

void main() {
  testWidgets('shows the SustainaBowl landing page', (tester) async {
    await tester.pumpWidget(const SustainaBowlApp());

    expect(find.text('SustainaBowl'), findsOneWidget);
  });
}
