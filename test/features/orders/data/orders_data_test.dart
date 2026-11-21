import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sustainabowl_mobile/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:sustainabowl_mobile/features/orders/data/models/cart_model.dart';
import 'package:sustainabowl_mobile/features/orders/data/models/order_history_model.dart';
import 'package:sustainabowl_mobile/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/order.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/order_history.dart';

import '../fakes.dart';
import '../fixtures/orders_responses.dart';

void main() {
  group('models', () {
    test('parse the order history response from Django', () {
      final history = fixtureHistory();

      expect(history.statusCounts['all'], greaterThan(0));
      expect(
        history.orders.map((o) => o.status),
        contains(OrderStatus.pending),
      );
      final pending = history.orders.firstWhere(
        (o) => o.status == OrderStatus.pending,
      );
      expect(pending.orderCode, startsWith('#'));
      expect(pending.canCancel, isTrue);
      expect(pending.items, isNotEmpty);
      expect(pending.createdAt, isNotNull);
      expect(
        pending.totalPrice,
        pending.subtotal + pending.packagingFee + pending.deliveryFee,
      );
    });

    test('parse the cart and checkout responses', () {
      final cart = fixtureCart();
      expect(cart.items, isNotEmpty);
      expect(
        cart.items.fold<int>(0, (sum, item) => sum + item.subtotal),
        cart.subtotal,
      );

      final checkout = fixtureCheckout();
      expect(checkout.addresses, isNotEmpty);
      expect(checkout.packagingOptions.map((o) => o.value), [
        PackagingType.reusable,
        PackagingType.compostable,
      ]);
      expect(checkout.defaultAddressId, checkout.addresses.first.id);
    });

    test('report the field name when the JSON shape is wrong', () {
      final json = jsonDecode(cartResponse) as Map<String, Object?>;
      json['subtotal'] = '246000';

      expect(
        () => CartModel.fromJson(json),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('cart.subtotal'),
          ),
        ),
      );
      expect(
        () => OrderHistoryModel.fromJson(<String, Object?>{}),
        throwsFormatException,
      );
    });
  });

  group('remote data source', () {
    test('uses the DRF paths, methods and bodies', () async {
      final client = RecordingApiClient(jsonDecode(cartResponse));
      final source = OrdersRemoteDataSource(apiClient: client);

      await source.getCart();
      await source.addCartItem('menu-1', 2);
      await source.updateCartItem('item-1', 3);
      await source.deleteCartItem('item-1');
      await source.getCheckout();
      await source.postCheckout(
        addressId: 4,
        packagingType: 'compostable',
        deliveryNotes: 'Titip satpam',
      );
      await source.cancelOrder('order-1');
      await source.updateOrderNote('order-1', 'Pagar hijau');
      await source.reorder('order-1');

      expect(client.requests, [
        'GET /api/v1/orders/cart/',
        'POST /api/v1/orders/cart/items/',
        'PATCH /api/v1/orders/cart/items/item-1/',
        'DELETE /api/v1/orders/cart/items/item-1/',
        'GET /api/v1/orders/checkout/',
        'POST /api/v1/orders/checkout/',
        'POST /api/v1/orders/order-1/cancel/',
        'PATCH /api/v1/orders/order-1/note/',
        'POST /api/v1/orders/order-1/reorder/',
      ]);
      expect(client.bodies[0], {'menu_item_id': 'menu-1', 'quantity': 2});
      expect(client.bodies[1], {'quantity': 3});
      expect(client.bodies[2], {
        'address_id': 4,
        'packaging_type': 'compostable',
        'delivery_notes': 'Titip satpam',
      });
      expect(client.bodies[4], {'delivery_notes': 'Pagar hijau'});
    });

    test('builds the order history query string from the filter', () async {
      final client = RecordingApiClient(jsonDecode(ordersResponse));
      final source = OrdersRemoteDataSource(apiClient: client);

      await source.getOrders(const OrderFilter());
      await source.getOrders(
        const OrderFilter(status: 'delivered', dateRange: '7_days'),
      );
      await source.getOrders(
        OrderFilter(
          dateRange: 'custom',
          startDate: DateTime(2026, 11, 1),
          endDate: DateTime(2026, 11, 20),
        ),
      );

      expect(client.requests, [
        'GET /api/v1/orders/',
        'GET /api/v1/orders/?status=delivered&date_range=7_days',
        'GET /api/v1/orders/?date_range=custom&start_date=2026-11-01'
            '&end_date=2026-11-20',
      ]);
    });
  });

  test('repository maps responses into entities', () async {
    final repository = OrdersRepositoryImpl(
      remoteDataSource: OrdersRemoteDataSource(
        apiClient: RecordingApiClient(jsonDecode(placedOrderResponse)),
      ),
    );

    final order = await repository.placeOrder(
      addressId: 1,
      packagingType: PackagingType.compostable,
    );

    expect(order.status, OrderStatus.pending);
    expect(order.packagingType, PackagingType.compostable);
  });
}
