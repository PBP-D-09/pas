import '../entities/cart.dart';
import '../repositories/orders_repository.dart';

class GetCart {
  const GetCart(this.repository);

  final OrdersRepository repository;

  Future<Cart> call() => repository.getCart();
}

class AddToCart {
  const AddToCart(this.repository);

  final OrdersRepository repository;

  Future<Cart> call(String menuItemId, {int quantity = 1}) {
    return repository.addToCart(menuItemId, quantity: quantity);
  }
}

class UpdateCartItem {
  const UpdateCartItem(this.repository);

  final OrdersRepository repository;

  Future<Cart> call(String itemId, int quantity) {
    return repository.updateCartItem(itemId, quantity);
  }
}

class RemoveCartItem {
  const RemoveCartItem(this.repository);

  final OrdersRepository repository;

  Future<Cart> call(String itemId) => repository.removeCartItem(itemId);
}
