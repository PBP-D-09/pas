import '../../domain/entities/cart.dart';
import 'json_reader.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.menuItemId,
    required super.name,
    required super.tenantName,
    required super.tenantArea,
    required super.price,
    required super.photoUrl,
    required super.quantity,
    required super.subtotal,
  });

  factory CartItemModel.fromReader(JsonReader json) {
    return CartItemModel(
      id: json.string('id'),
      menuItemId: json.string('menu_item_id'),
      name: json.string('name'),
      tenantName: json.string('tenant_name'),
      tenantArea: json.string('tenant_area'),
      price: json.integer('price'),
      photoUrl: json.nullableString('photo_url'),
      quantity: json.integer('quantity'),
      subtotal: json.integer('subtotal'),
    );
  }
}

class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.totalItems,
    required super.tenantCount,
    required super.subtotal,
    required super.items,
  });

  factory CartModel.fromJson(Object? json) {
    return CartModel.fromReader(JsonReader(json, 'cart'));
  }

  factory CartModel.fromReader(JsonReader json) {
    return CartModel(
      id: json.string('id'),
      totalItems: json.integer('total_items'),
      tenantCount: json.integer('tenant_count'),
      subtotal: json.integer('subtotal'),
      items: json.list('items', CartItemModel.fromReader),
    );
  }
}
