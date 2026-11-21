import '../entities/checkout_summary.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class CancelOrder {
  const CancelOrder(this.repository);

  final OrdersRepository repository;

  Future<Order> call(String orderId) => repository.cancelOrder(orderId);
}

class UpdateOrderNote {
  const UpdateOrderNote(this.repository);

  final OrdersRepository repository;

  Future<Order> call(String orderId, String deliveryNotes) {
    return repository.updateOrderNote(orderId, deliveryNotes);
  }
}

class Reorder {
  const Reorder(this.repository);

  final OrdersRepository repository;

  Future<ReorderResult> call(String orderId) => repository.reorder(orderId);
}
