import '../entities/cart.dart';
import '../entities/checkout_summary.dart';
import '../entities/order.dart';
import '../entities/order_history.dart';

abstract interface class OrdersRepository {
  Future<Cart> getCart();

  Future<Cart> addToCart(String menuItemId, {int quantity = 1});

  Future<Cart> updateCartItem(String itemId, int quantity);

  Future<Cart> removeCartItem(String itemId);

  Future<CheckoutSummary> getCheckoutSummary();

  Future<Order> placeOrder({
    required int addressId,
    required String packagingType,
    String deliveryNotes = '',
  });

  Future<OrderHistory> getOrders(OrderFilter filter);

  Future<Order> cancelOrder(String orderId);

  Future<Order> updateOrderNote(String orderId, String deliveryNotes);

  Future<ReorderResult> reorder(String orderId);
}
