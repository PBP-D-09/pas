class CartItem {
  const CartItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.tenantName,
    required this.tenantArea,
    required this.price,
    required this.photoUrl,
    required this.quantity,
    required this.subtotal,
  });

  final String id;
  final String menuItemId;
  final String name;
  final String tenantName;
  final String tenantArea;
  final int price;
  final String? photoUrl;
  final int quantity;
  final int subtotal;
}

class Cart {
  const Cart({
    required this.id,
    required this.totalItems,
    required this.tenantCount,
    required this.subtotal,
    required this.items,
  });

  final String id;
  final int totalItems;
  final int tenantCount;
  final int subtotal;
  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;
}
