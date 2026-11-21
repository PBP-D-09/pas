import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/core/errors/app_failure.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/checkout_summary.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/order.dart';
import 'package:sustainabowl_mobile/features/orders/presentation/providers/cart_provider.dart';
import 'package:sustainabowl_mobile/features/orders/presentation/providers/checkout_provider.dart';
import 'package:sustainabowl_mobile/features/orders/presentation/providers/orders_provider.dart';

import '../fakes.dart';

bool _loggedIn() => true;
bool _loggedOut() => false;

void main() {
  group('CartProvider', () {
    test(
      'asks for login without calling the API when there is no token',
      () async {
        final repository = FakeOrdersRepository();
        final provider = CartProvider(repository, hasToken: _loggedOut);

        await provider.load();

        expect(provider.needsLogin, isTrue);
        expect(repository.calls, isEmpty);
      },
    );

    test('loads the cart and changes quantities', () async {
      final repository = FakeOrdersRepository();
      final provider = CartProvider(repository, hasToken: _loggedIn);
      await provider.load();
      final item = provider.cart!.items.first;

      await provider.increase(item);
      expect(provider.cart!.items.first.quantity, item.quantity + 1);
      expect(
        repository.calls.last,
        'updateCartItem ${item.id} ${item.quantity + 1}',
      );

      await provider.remove(provider.cart!.items.first);
      expect(provider.cart!.items.map((i) => i.id), isNot(contains(item.id)));
    });

    test('decrease stops at one, like the web stepper', () async {
      final repository = FakeOrdersRepository();
      await repository.updateCartItem(repository.cart.items.first.id, 2);
      final provider = CartProvider(repository, hasToken: _loggedIn);
      await provider.load();

      await provider.decrease(provider.cart!.items.first);
      expect(provider.cart!.items.first.quantity, 1);

      repository.calls.clear();
      await provider.decrease(provider.cart!.items.first);
      expect(repository.calls, isEmpty);
    });

    test('switches to the login state on 401', () async {
      final repository = FakeOrdersRepository(error: unauthorized);
      final provider = CartProvider(repository, hasToken: _loggedIn);

      await provider.load();

      expect(provider.needsLogin, isTrue);
      expect(provider.errorMessage, isNull);
    });
  });

  group('CheckoutProvider', () {
    test(
      'preselects the default address and first available packaging',
      () async {
        final provider = CheckoutProvider(
          FakeOrdersRepository(),
          hasToken: _loggedIn,
        );

        await provider.load();
        final summary = provider.summary!;

        expect(provider.selectedAddressId, summary.defaultAddressId);
        expect(provider.selectedPackaging, PackagingType.reusable);
        expect(
          provider.total,
          summary.cart.subtotal +
              provider.selectedOption!.fee +
              provider.selectedAddress!.deliveryFee,
        );
        expect(provider.canPlaceOrder, isTrue);
      },
    );

    test('skips sold-out reusable packaging', () async {
      final repository = FakeOrdersRepository();
      final checkout = repository.checkout;
      repository.checkout = CheckoutSummary(
        cart: checkout.cart,
        addresses: checkout.addresses,
        defaultAddressId: checkout.defaultAddressId,
        packagingOptions: [
          for (final option in checkout.packagingOptions)
            PackagingOption(
              value: option.value,
              label: option.label,
              description: option.description,
              fee: option.fee,
              ecoPoints: option.ecoPoints,
              disabled: option.value == PackagingType.reusable,
            ),
        ],
      );
      final provider = CheckoutProvider(repository, hasToken: _loggedIn);

      await provider.load();
      provider.selectPackaging(provider.summary!.packagingOptions.first);

      expect(provider.selectedPackaging, PackagingType.compostable);
    });

    test('places the order with trimmed notes', () async {
      final repository = FakeOrdersRepository();
      final provider = CheckoutProvider(repository, hasToken: _loggedIn);
      await provider.load();
      provider.selectPackaging(provider.summary!.packagingOptions.last);

      final order = await provider.placeOrder('  Titip satpam  ');

      expect(order, isNotNull);
      expect(
        repository.calls.last,
        'placeOrder ${provider.selectedAddressId} compostable "Titip satpam"',
      );
    });

    test('keeps the server error when placing fails', () async {
      final repository = FakeOrdersRepository()
        ..placeOrderError = const AppFailure(
          'Reusable containers are sold out at Laut Biru today.',
          statusCode: 400,
        );
      final provider = CheckoutProvider(repository, hasToken: _loggedIn);
      await provider.load();

      final order = await provider.placeOrder('');

      expect(order, isNull);
      expect(provider.placeError, contains('sold out'));
      expect(provider.isPlacing, isFalse);
    });
  });

  group('OrdersProvider', () {
    test('passes the selected filters to the repository', () async {
      final repository = FakeOrdersRepository();
      final provider = OrdersProvider(repository, hasToken: _loggedIn);
      await provider.load();

      await provider.setStatus(OrderStatus.delivered);
      await provider.setDateRange('7_days');

      expect(repository.lastFilter!.status, OrderStatus.delivered);
      expect(repository.lastFilter!.dateRange, '7_days');
    });

    test(
      'cancel reloads the history and returns the cancelled order',
      () async {
        final repository = FakeOrdersRepository();
        final provider = OrdersProvider(repository, hasToken: _loggedIn);
        await provider.load();
        final pending = provider.history!.orders.firstWhere((o) => o.canCancel);

        final cancelled = await provider.cancel(pending);

        expect(cancelled.status, OrderStatus.cancelled);
        expect(repository.calls.last, startsWith('getOrders'));
        expect(provider.isBusy(pending.id), isFalse);
      },
    );

    test('updateNote replaces the order in place', () async {
      final provider = OrdersProvider(
        FakeOrdersRepository(),
        hasToken: _loggedIn,
      );
      await provider.load();
      final pending = provider.history!.orders.firstWhere((o) => o.canEditNote);

      await provider.updateNote(pending, '  Pagar hijau ');

      final updated = provider.history!.orders.firstWhere(
        (o) => o.id == pending.id,
      );
      expect(updated.deliveryNotes, 'Pagar hijau');
    });

    test('rethrows action errors so the page can show them', () async {
      final repository = FakeOrdersRepository();
      final provider = OrdersProvider(repository, hasToken: _loggedIn);
      await provider.load();
      final order = provider.history!.orders.first;
      repository.error = const AppFailure('Nope', statusCode: 400);

      await expectLater(provider.reorder(order), throwsA(isA<AppFailure>()));
      expect(provider.isBusy(order.id), isFalse);
    });
  });
}
