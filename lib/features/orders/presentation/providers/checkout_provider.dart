import 'package:flutter/foundation.dart';

import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/checkout.dart';
import 'orders_errors.dart';

/// Batas catatan pengiriman, sama dengan NOTE_MAX_LENGTH di apps/orders/forms.py.
const deliveryNoteMaxLength = 500;

class CheckoutProvider extends ChangeNotifier {
  CheckoutProvider(OrdersRepository repository, {TokenCheck? hasToken})
    : _getSummary = GetCheckoutSummary(repository),
      _placeOrder = PlaceOrder(repository),
      _hasToken = hasToken ?? defaultTokenCheck;

  final GetCheckoutSummary _getSummary;
  final PlaceOrder _placeOrder;
  final TokenCheck _hasToken;

  CheckoutSummary? _summary;
  String? _errorMessage;
  String? _placeError;
  bool _isLoading = false;
  bool _isPlacing = false;
  bool _needsLogin = false;
  int? _selectedAddressId;
  String? _selectedPackaging;

  CheckoutSummary? get summary => _summary;
  String? get errorMessage => _errorMessage;
  String? get placeError => _placeError;
  bool get isLoading => _isLoading;
  bool get isPlacing => _isPlacing;
  bool get needsLogin => _needsLogin;
  int? get selectedAddressId => _selectedAddressId;
  String? get selectedPackaging => _selectedPackaging;

  CheckoutAddress? get selectedAddress {
    final addresses = _summary?.addresses ?? const <CheckoutAddress>[];
    for (final address in addresses) {
      if (address.id == _selectedAddressId) return address;
    }
    return null;
  }

  PackagingOption? get selectedOption {
    final options = _summary?.packagingOptions ?? const <PackagingOption>[];
    for (final option in options) {
      if (option.value == _selectedPackaging) return option;
    }
    return null;
  }

  int get subtotal => _summary?.cart.subtotal ?? 0;
  int get packagingFee => selectedOption?.fee ?? 0;
  int? get deliveryFee => selectedAddress?.deliveryFee;
  int get total => subtotal + packagingFee + (deliveryFee ?? 0);
  int get ecoPoints => selectedOption?.ecoPoints ?? 0;

  bool get canPlaceOrder =>
      !_isPlacing && selectedAddress != null && selectedOption != null;

  Future<void> load() async {
    if (!_hasToken()) {
      _needsLogin = true;
      notifyListeners();
      return;
    }
    _needsLogin = false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final summary = await _getSummary();
      _summary = summary;
      _selectedAddressId =
          summary.defaultAddressId ??
          (summary.addresses.isEmpty ? null : summary.addresses.first.id);
      final available = summary.packagingOptions.where((o) => !o.disabled);
      _selectedPackaging = available.isEmpty ? null : available.first.value;
    } catch (error) {
      if (isUnauthorized(error)) {
        _needsLogin = true;
      } else {
        _errorMessage = describeError(error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAddress(int addressId) {
    _selectedAddressId = addressId;
    _placeError = null;
    notifyListeners();
  }

  void selectPackaging(PackagingOption option) {
    if (option.disabled) return;
    _selectedPackaging = option.value;
    _placeError = null;
    notifyListeners();
  }

  /// Membuat pesanan. Mengembalikan null (dan mengisi [placeError]) jika gagal.
  Future<Order?> placeOrder(String deliveryNotes) async {
    final address = selectedAddress;
    final option = selectedOption;
    if (_isPlacing || address == null || option == null) return null;

    _isPlacing = true;
    _placeError = null;
    notifyListeners();
    try {
      return await _placeOrder(
        addressId: address.id,
        packagingType: option.value,
        deliveryNotes: deliveryNotes.trim(),
      );
    } catch (error) {
      _placeError = describeError(error);
      return null;
    } finally {
      _isPlacing = false;
      notifyListeners();
    }
  }
}
