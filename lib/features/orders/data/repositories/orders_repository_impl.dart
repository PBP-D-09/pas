import '../../../../core/network/http_api_client.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_history.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/cart_model.dart';
import '../models/checkout_summary_model.dart';
import '../models/order_history_model.dart';
import '../models/order_model.dart';

/// Repository Orders yang memanggil API Django lewat [HttpApiClient].
OrdersRepository createOrdersRepository() {
  return const OrdersRepositoryImpl(
    remoteDataSource: OrdersRemoteDataSource(apiClient: HttpApiClient()),
  );
}

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl({required this.remoteDataSource});

  final OrdersRemoteDataSource remoteDataSource;

  @override
  Future<Cart> getCart() async {
    return CartModel.fromJson(await remoteDataSource.getCart());
  }

  @override
  Future<Cart> addToCart(String menuItemId, {int quantity = 1}) async {
    return CartModel.fromJson(
      await remoteDataSource.addCartItem(menuItemId, quantity),
    );
  }

  @override
  Future<Cart> updateCartItem(String itemId, int quantity) async {
    return CartModel.fromJson(
      await remoteDataSource.updateCartItem(itemId, quantity),
    );
  }

  @override
  Future<Cart> removeCartItem(String itemId) async {
    return CartModel.fromJson(await remoteDataSource.deleteCartItem(itemId));
  }

  @override
  Future<CheckoutSummary> getCheckoutSummary() async {
    return CheckoutSummaryModel.fromJson(await remoteDataSource.getCheckout());
  }

  @override
  Future<Order> placeOrder({
    required int addressId,
    required String packagingType,
    String deliveryNotes = '',
  }) async {
    return OrderModel.fromJson(
      await remoteDataSource.postCheckout(
        addressId: addressId,
        packagingType: packagingType,
        deliveryNotes: deliveryNotes,
      ),
    );
  }

  @override
  Future<OrderHistory> getOrders(OrderFilter filter) async {
    return OrderHistoryModel.fromJson(await remoteDataSource.getOrders(filter));
  }

  @override
  Future<Order> cancelOrder(String orderId) async {
    return OrderModel.fromJson(await remoteDataSource.cancelOrder(orderId));
  }

  @override
  Future<Order> updateOrderNote(String orderId, String deliveryNotes) async {
    return OrderModel.fromJson(
      await remoteDataSource.updateOrderNote(orderId, deliveryNotes),
    );
  }

  @override
  Future<ReorderResult> reorder(String orderId) async {
    return ReorderResultModel.fromJson(await remoteDataSource.reorder(orderId));
  }
}
