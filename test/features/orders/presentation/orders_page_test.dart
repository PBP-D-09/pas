import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/core/theme/app_theme.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/order.dart';
import 'package:sustainabowl_mobile/features/orders/presentation/pages/orders_page.dart';
import 'package:sustainabowl_mobile/features/orders/presentation/widgets/orders_format.dart';

import '../fakes.dart';

Widget _app(FakeOrdersRepository repository, {bool loggedIn = true}) {
  return MaterialApp(
    theme: AppTheme.light,
    home: OrdersPage(repository: repository, hasToken: () => loggedIn),
  );
}

void main() {
  test('formatRupiah matches the web format', () {
    expect(formatRupiah(0), 'Rp 0');
    expect(formatRupiah(45000), 'Rp 45.000');
    expect(formatRupiah(1250000), 'Rp 1.250.000');
  });

  testWidgets('shows the login state without a token', (tester) async {
    final repository = FakeOrdersRepository();
    await tester.pumpWidget(_app(repository, loggedIn: false));
    await tester.pumpAndSettle();

    expect(find.text('Log in to see your orders'), findsOneWidget);
    expect(repository.calls, isEmpty);
  });

  testWidgets('lists orders with status filters and the cart badge', (
    tester,
  ) async {
    final repository = FakeOrdersRepository();
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    final history = repository.history;
    final first = history.orders.first;
    expect(find.text('My orders'), findsOneWidget);
    expect(find.text('All (${history.statusCounts['all']})'), findsOneWidget);
    expect(find.text(first.orderCode), findsOneWidget);
    expect(find.text('${repository.cart.totalItems}'), findsOneWidget);

    // Baris filter bisa digeser horizontal; geser dulu sampai chip terlihat.
    final delivered = find.textContaining('Delivered (');
    await tester.ensureVisible(delivered);
    await tester.pumpAndSettle();
    await tester.tap(delivered);
    await tester.pumpAndSettle();
    expect(repository.lastFilter!.status, OrderStatus.delivered);
  });

  testWidgets('cancels a pending order after confirmation', (tester) async {
    final repository = FakeOrdersRepository();
    final pending = repository.history.orders.firstWhere((o) => o.canCancel);
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    final cancelButton = find.widgetWithText(OutlinedButton, 'Cancel order');
    await tester.ensureVisible(cancelButton.first);
    await tester.tap(cancelButton.first);
    await tester.pumpAndSettle();
    expect(find.text('Cancel ${pending.orderCode}?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Cancel order'));
    await tester.pumpAndSettle();

    expect(repository.calls, contains('cancelOrder ${pending.id}'));
    expect(find.text('Order ${pending.orderCode} cancelled.'), findsOneWidget);
  });

  testWidgets('opens the cart from the app bar', (tester) async {
    final repository = FakeOrdersRepository();
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Your cart'));
    await tester.pumpAndSettle();

    expect(find.text('Your cart'), findsOneWidget);
    expect(find.text(repository.cart.items.first.name), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Checkout'), findsOneWidget);
  });
}
