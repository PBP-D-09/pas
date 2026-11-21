import '../entities/order_history.dart';
import '../repositories/orders_repository.dart';

class GetOrders {
  const GetOrders(this.repository);

  final OrdersRepository repository;

  Future<OrderHistory> call([OrderFilter filter = const OrderFilter()]) {
    return repository.getOrders(filter);
  }
}
