import 'package:flutter/foundation.dart';

import '../../domain/entities/cart.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/manage_cart.dart';
import 'orders_errors.dart';

class CartProvider extends ChangeNotifier {
  CartProvider(OrdersRepository repository, {TokenCheck? hasToken})
    : _getCart = GetCart(repository),
      _addToCart = AddToCart(repository),
      _updateCartItem = UpdateCartItem(repository),
      _removeCartItem = RemoveCartItem(repository),
      _hasToken = hasToken ?? defaultTokenCheck;

  final GetCart _getCart;
  final AddToCart _addToCart;
  final UpdateCartItem _updateCartItem;
  final RemoveCartItem _removeCartItem;
  final TokenCheck _hasToken;

  Cart? _cart;
  String? _errorMessage;
  bool _isLoading = false;
  bool _needsLogin = false;
  final Set<String> _busyItemIds = {};

  Cart? get cart => _cart;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get needsLogin => _needsLogin;
  int get itemCount => _cart?.totalItems ?? 0;

  bool isBusy(String itemId) => _busyItemIds.contains(itemId);

  Future<void> load() async {
    if (!_hasToken()) {
      _needsLogin = true;
      _cart = null;
      notifyListeners();
      return;
    }
    _needsLogin = false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _cart = await _getCart();
    } catch (error) {
      _handleError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Dipakai setelah aksi lain (mis. pesan ulang) mengembalikan isi keranjang.
  void replaceCart(Cart cart) {
    _cart = cart;
    _needsLogin = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Menambahkan menu ke keranjang. Melempar error agar pemanggil bisa
  /// menampilkan pesan (mis. dari dialog Add to cart).
  Future<Cart> addItem(String menuItemId, {int quantity = 1}) async {
    final cart = await _addToCart(menuItemId, quantity: quantity);
    replaceCart(cart);
    return cart;
  }

  Future<void> increase(CartItem item) {
    return _changeItem(
      item.id,
      () => _updateCartItem(item.id, item.quantity + 1),
    );
  }

  /// Seperti di web, tombol (-) berhenti di 1; hapus item lewat [remove].
  Future<void> decrease(CartItem item) async {
    if (item.quantity <= 1) return;
    return _changeItem(
      item.id,
      () => _updateCartItem(item.id, item.quantity - 1),
    );
  }

  Future<void> remove(CartItem item) {
    return _changeItem(item.id, () => _removeCartItem(item.id));
  }

  Future<void> _changeItem(
    String itemId,
    Future<Cart> Function() action,
  ) async {
    if (_busyItemIds.contains(itemId)) return;
    _busyItemIds.add(itemId);
    _errorMessage = null;
    notifyListeners();
    try {
      _cart = await action();
    } catch (error) {
      _handleError(error);
    } finally {
      _busyItemIds.remove(itemId);
      notifyListeners();
    }
  }

  void _handleError(Object error) {
    if (isUnauthorized(error)) {
      _needsLogin = true;
      _cart = null;
    } else {
      _errorMessage = describeError(error);
    }
  }
}
