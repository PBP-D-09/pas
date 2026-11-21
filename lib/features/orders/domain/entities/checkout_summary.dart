import 'cart.dart';

class CheckoutAddress {
  const CheckoutAddress({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.address,
    required this.landmark,
    required this.isDefault,
    required this.deliveryFee,
    required this.etaMinutes,
  });

  final int id;
  final String label;
  final String recipientName;
  final String phoneNumber;
  final String address;
  final String landmark;
  final bool isDefault;

  /// Ongkir dari tenant terjauh di keranjang ke alamat ini.
  final int deliveryFee;
  final int etaMinutes;
}

class PackagingOption {
  const PackagingOption({
    required this.value,
    required this.label,
    required this.description,
    required this.fee,
    required this.ecoPoints,
    required this.disabled,
  });

  final String value;
  final String label;
  final String description;
  final int fee;
  final int ecoPoints;

  /// True jika wadah reusable sedang habis di salah satu tenant.
  final bool disabled;
}

class CheckoutSummary {
  const CheckoutSummary({
    required this.cart,
    required this.addresses,
    required this.defaultAddressId,
    required this.packagingOptions,
  });

  final Cart cart;
  final List<CheckoutAddress> addresses;
  final int? defaultAddressId;
  final List<PackagingOption> packagingOptions;
}

class ReorderResult {
  const ReorderResult({required this.addedCount, required this.cart});

  final int addedCount;
  final Cart cart;
}
