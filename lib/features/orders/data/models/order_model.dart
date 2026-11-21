import '../../domain/entities/order.dart';
import 'json_reader.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.menuItemId,
    required super.itemName,
    required super.tenantName,
    required super.price,
    required super.quantity,
    required super.subtotal,
  });

  factory OrderItemModel.fromReader(JsonReader json) {
    return OrderItemModel(
      id: json.string('id'),
      menuItemId: json.nullableString('menu_item_id'),
      itemName: json.string('item_name'),
      tenantName: json.string('tenant_name'),
      price: json.integer('price'),
      quantity: json.integer('quantity'),
      subtotal: json.integer('subtotal'),
    );
  }
}

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.orderCode,
    required super.status,
    required super.statusDisplay,
    required super.packagingType,
    required super.packagingDisplay,
    required super.reusableReturned,
    required super.reusableContainers,
    required super.deliveryAddress,
    required super.deliveryNotes,
    required super.deliveryEtaMinutes,
    required super.subtotal,
    required super.packagingFee,
    required super.deliveryFee,
    required super.totalPrice,
    required super.ecoPoints,
    required super.totalItemsCount,
    required super.canCancel,
    required super.canEditNote,
    required super.createdAt,
    required super.items,
  });

  factory OrderModel.fromJson(Object? json) {
    return OrderModel.fromReader(JsonReader(json, 'order'));
  }

  factory OrderModel.fromReader(JsonReader json) {
    return OrderModel(
      id: json.string('id'),
      orderCode: json.string('order_code'),
      status: json.string('status'),
      statusDisplay: json.string('status_display'),
      packagingType: json.string('packaging_type'),
      packagingDisplay: json.string('packaging_display'),
      reusableReturned: json.boolean('reusable_returned'),
      reusableContainers: json.integer('reusable_containers'),
      deliveryAddress: json.string('delivery_address'),
      deliveryNotes: json.string('delivery_notes'),
      deliveryEtaMinutes: json.integer('delivery_eta_minutes'),
      subtotal: json.integer('subtotal'),
      packagingFee: json.integer('packaging_fee'),
      deliveryFee: json.integer('delivery_fee'),
      totalPrice: json.integer('total_price'),
      ecoPoints: json.integer('eco_points'),
      totalItemsCount: json.integer('total_items_count'),
      canCancel: json.boolean('can_cancel'),
      canEditNote: json.boolean('can_edit_note'),
      createdAt: json.dateTime('created_at'),
      items: json.list('items', OrderItemModel.fromReader),
    );
  }
}
