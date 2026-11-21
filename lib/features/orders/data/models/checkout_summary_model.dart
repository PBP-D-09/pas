import '../../domain/entities/checkout_summary.dart';
import 'cart_model.dart';
import 'json_reader.dart';

class CheckoutAddressModel extends CheckoutAddress {
  const CheckoutAddressModel({
    required super.id,
    required super.label,
    required super.recipientName,
    required super.phoneNumber,
    required super.address,
    required super.landmark,
    required super.isDefault,
    required super.deliveryFee,
    required super.etaMinutes,
  });

  factory CheckoutAddressModel.fromReader(JsonReader json) {
    return CheckoutAddressModel(
      id: json.integer('id'),
      label: json.string('label'),
      recipientName: json.string('recipient_name'),
      phoneNumber: json.string('phone_number'),
      address: json.string('address'),
      landmark: json.string('landmark'),
      isDefault: json.boolean('is_default'),
      deliveryFee: json.integer('delivery_fee'),
      etaMinutes: json.integer('eta_minutes'),
    );
  }
}

class PackagingOptionModel extends PackagingOption {
  const PackagingOptionModel({
    required super.value,
    required super.label,
    required super.description,
    required super.fee,
    required super.ecoPoints,
    required super.disabled,
  });

  factory PackagingOptionModel.fromReader(JsonReader json) {
    return PackagingOptionModel(
      value: json.string('value'),
      label: json.string('label'),
      description: json.string('description'),
      fee: json.integer('fee'),
      ecoPoints: json.integer('eco_points'),
      disabled: json.boolean('disabled'),
    );
  }
}

class CheckoutSummaryModel extends CheckoutSummary {
  const CheckoutSummaryModel({
    required super.cart,
    required super.addresses,
    required super.defaultAddressId,
    required super.packagingOptions,
  });

  factory CheckoutSummaryModel.fromJson(Object? value) {
    final json = JsonReader(value, 'checkout');
    return CheckoutSummaryModel(
      cart: CartModel.fromReader(json.object('cart')),
      addresses: json.list('addresses', CheckoutAddressModel.fromReader),
      defaultAddressId: json.nullableInteger('default_address_id'),
      packagingOptions: json.list(
        'packaging_options',
        PackagingOptionModel.fromReader,
      ),
    );
  }
}

class ReorderResultModel extends ReorderResult {
  const ReorderResultModel({required super.addedCount, required super.cart});

  factory ReorderResultModel.fromJson(Object? value) {
    final json = JsonReader(value, 'reorder');
    return ReorderResultModel(
      addedCount: json.integer('added_count'),
      cart: CartModel.fromReader(json.object('cart')),
    );
  }
}
