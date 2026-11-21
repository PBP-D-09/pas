import 'dart:convert';

import 'package:sustainabowl_mobile/core/errors/app_failure.dart';
import 'package:sustainabowl_mobile/core/network/api_client.dart';
import 'package:sustainabowl_mobile/features/orders/data/models/cart_model.dart';
import 'package:sustainabowl_mobile/features/orders/data/models/checkout_summary_model.dart';
import 'package:sustainabowl_mobile/features/orders/data/models/order_history_model.dart';
import 'package:sustainabowl_mobile/features/orders/data/models/order_model.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/cart.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/checkout_summary.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/order.dart';
import 'package:sustainabowl_mobile/features/orders/domain/entities/order_history.dart';
import 'package:sustainabowl_mobile/features/orders/domain/repositories/orders_repository.dart';

import 'fixtures/orders_responses.dart';

Cart fixtureCart() => CartModel.fromJson(jsonDecode(cartResponse));

OrderHistory fixtureHistory() =>
    OrderHistoryModel.fromJson(jsonDecode(ordersResponse));

CheckoutSummary fixtureCheckout() =>
    CheckoutSummaryModel.fromJson(jsonDecode(checkoutResponse));

Order fixturePlacedOrder() =>
    OrderModel.fromJson(jsonDecode(placedOrderResponse));

const emptyCart = Cart(
  id: 'empty',
  totalItems: 0,
  tenantCount: 0,
  subtotal: 0,
  items: [],
);

/// Repository palsu berbasis fixture; [error] membuat setiap panggilan gagal.
class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository({Cart? cart, OrderHistory? history, this.error})
    : cart = cart ?? fixtureCart(),
      history = history ?? fixtureHistory();

  Cart cart;
  OrderHistory history;
  CheckoutSummary checkout = fixtureCheckout();
  Object? error;
  Object? placeOrderError;

  final List<String> calls = [];
  OrderFilter? lastFilter;

  Future<T> _answer<T>(String call, T Function() value) async {
    calls.add(call);
    final failure = error;
    if (failure != null) throw failure;
    return value();
  }

  @override
  Future<Cart> getCart() => _answer('getCart', () => cart);

  @override
  Future<Cart> addToCart(String menuItemId, {int quantity = 1}) {
    return _answer('addToCart $menuItemId x$quantity', () => cart);
  }

  @override
  Future<Cart> updateCartItem(String itemId, int quantity) {
    return _answer('updateCartItem $itemId $quantity', () {
      cart = _withQuantity(cart, itemId, quantity);
      return cart;
    });
  }

  @override
  Future<Cart> removeCartItem(String itemId) {
    return _answer('removeCartItem $itemId', () {
      cart = Cart(
        id: cart.id,
        totalItems: cart.totalItems,
        tenantCount: cart.tenantCount,
        subtotal: cart.subtotal,
        items: cart.items.where((item) => item.id != itemId).toList(),
      );
      return cart;
    });
  }

  @override
  Future<CheckoutSummary> getCheckoutSummary() {
    return _answer('getCheckoutSummary', () => checkout);
  }

  @override
  Future<Order> placeOrder({
    required int addressId,
    required String packagingType,
    String deliveryNotes = '',
  }) async {
    calls.add('placeOrder $addressId $packagingType "$deliveryNotes"');
    final failure = placeOrderError ?? error;
    if (failure != null) throw failure;
    return fixturePlacedOrder();
  }

  @override
  Future<OrderHistory> getOrders(OrderFilter filter) {
    lastFilter = filter;
    return _answer('getOrders ${filter.status} ${filter.dateRange}', () {
      return history;
    });
  }

  @override
  Future<Order> cancelOrder(String orderId) {
    return _answer('cancelOrder $orderId', () {
      final order = history.orders.firstWhere((o) => o.id == orderId);
      return _copyOrder(order, status: OrderStatus.cancelled);
    });
  }

  @override
  Future<Order> updateOrderNote(String orderId, String deliveryNotes) {
    return _answer('updateOrderNote $orderId "$deliveryNotes"', () {
      final order = history.orders.firstWhere((o) => o.id == orderId);
      return _copyOrder(order, deliveryNotes: deliveryNotes);
    });
  }

  @override
  Future<ReorderResult> reorder(String orderId) {
    return _answer('reorder $orderId', () {
      return ReorderResult(addedCount: 2, cart: cart);
    });
  }
}

/// ApiClient palsu yang mencatat setiap request.
class RecordingApiClient implements ApiClient {
  RecordingApiClient([this.response]);

  final Object? response;
  final List<String> requests = [];
  final List<Map<String, Object?>> bodies = [];

  Future<Object?> _record(String line, [Map<String, Object?>? body]) async {
    requests.add(line);
    if (body != null) bodies.add(body);
    return response;
  }

  @override
  Future<Object?> get(String path) => _record('GET $path');

  @override
  Future<Object?> post(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  }) {
    return _record('POST $path', body);
  }

  @override
  Future<Object?> patch(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  }) {
    return _record('PATCH $path', body);
  }

  @override
  Future<Object?> delete(String path) => _record('DELETE $path');
}

const unauthorized = AppFailure(
  'Authentication credentials were not provided.',
  statusCode: 401,
);

Cart _withQuantity(Cart cart, String itemId, int quantity) {
  return Cart(
    id: cart.id,
    totalItems: cart.totalItems,
    tenantCount: cart.tenantCount,
    subtotal: cart.subtotal,
    items: [
      for (final item in cart.items)
        if (item.id == itemId)
          CartItem(
            id: item.id,
            menuItemId: item.menuItemId,
            name: item.name,
            tenantName: item.tenantName,
            tenantArea: item.tenantArea,
            price: item.price,
            photoUrl: item.photoUrl,
            quantity: quantity,
            subtotal: item.price * quantity,
          )
        else
          item,
    ],
  );
}

Order _copyOrder(Order order, {String? status, String? deliveryNotes}) {
  final newStatus = status ?? order.status;
  return Order(
    id: order.id,
    orderCode: order.orderCode,
    status: newStatus,
    statusDisplay: newStatus == OrderStatus.cancelled
        ? 'Cancelled'
        : order.statusDisplay,
    packagingType: order.packagingType,
    packagingDisplay: order.packagingDisplay,
    reusableReturned: order.reusableReturned,
    reusableContainers: order.reusableContainers,
    deliveryAddress: order.deliveryAddress,
    deliveryNotes: deliveryNotes ?? order.deliveryNotes,
    deliveryEtaMinutes: order.deliveryEtaMinutes,
    subtotal: order.subtotal,
    packagingFee: order.packagingFee,
    deliveryFee: order.deliveryFee,
    totalPrice: order.totalPrice,
    ecoPoints: order.ecoPoints,
    totalItemsCount: order.totalItemsCount,
    canCancel: newStatus == OrderStatus.pending && order.canCancel,
    canEditNote: newStatus == OrderStatus.pending && order.canEditNote,
    createdAt: order.createdAt,
    items: order.items,
  );
}
