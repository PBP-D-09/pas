import '../entities/checkout_summary.dart';
import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetCheckoutSummary {
  const GetCheckoutSummary(this.repository);

  final OrdersRepository repository;

  Future<CheckoutSummary> call() => repository.getCheckoutSummary();
}

class PlaceOrder {
  const PlaceOrder(this.repository);

  final OrdersRepository repository;

  Future<Order> call({
    required int addressId,
    required String packagingType,
    String deliveryNotes = '',
  }) {
    return repository.placeOrder(
      addressId: addressId,
      packagingType: packagingType,
      deliveryNotes: deliveryNotes,
    );
  }
}
