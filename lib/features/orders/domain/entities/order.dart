abstract final class OrderStatus {
  static const pending = 'pending';
  static const processing = 'processing';
  static const onTheWay = 'on_the_way';
  static const delivered = 'delivered';
  static const cancelled = 'cancelled';
}

abstract final class PackagingType {
  static const reusable = 'reusable';
  static const compostable = 'compostable';
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.menuItemId,
    required this.itemName,
    required this.tenantName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  final String id;

  /// Null jika menu sudah dihapus tenant (nama dan harga tetap tersimpan).
  final String? menuItemId;
  final String itemName;
  final String tenantName;
  final int price;
  final int quantity;
  final int subtotal;
}

class Order {
  const Order({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.statusDisplay,
    required this.packagingType,
    required this.packagingDisplay,
    required this.reusableReturned,
    required this.reusableContainers,
    required this.deliveryAddress,
    required this.deliveryNotes,
    required this.deliveryEtaMinutes,
    required this.subtotal,
    required this.packagingFee,
    required this.deliveryFee,
    required this.totalPrice,
    required this.ecoPoints,
    required this.totalItemsCount,
    required this.canCancel,
    required this.canEditNote,
    required this.createdAt,
    required this.items,
  });

  final String id;
  final String orderCode;
  final String status;
  final String statusDisplay;
  final String packagingType;
  final String packagingDisplay;
  final bool reusableReturned;
  final int reusableContainers;
  final String deliveryAddress;
  final String deliveryNotes;
  final int deliveryEtaMinutes;
  final int subtotal;
  final int packagingFee;
  final int deliveryFee;
  final int totalPrice;
  final int ecoPoints;
  final int totalItemsCount;
  final bool canCancel;
  final bool canEditNote;
  final DateTime? createdAt;
  final List<OrderItem> items;

  /// Pesan ulang hanya bisa jika masih ada menu yang belum dihapus tenant.
  bool get canReorder => items.any((item) => item.menuItemId != null);
}
