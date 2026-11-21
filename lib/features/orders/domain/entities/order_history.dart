import 'order.dart';

/// Filter riwayat pesanan, sama dengan query `?status=&date_range=` di web.
class OrderFilter {
  const OrderFilter({
    this.status = 'all',
    this.dateRange = 'all',
    this.startDate,
    this.endDate,
  });

  /// `all` atau salah satu nilai [OrderStatus].
  final String status;

  /// `all`, `today`, `7_days`, `30_days`, atau `custom`.
  final String dateRange;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderFilter copyWith({
    String? status,
    String? dateRange,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return OrderFilter(
      status: status ?? this.status,
      dateRange: dateRange ?? this.dateRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class OrderHistory {
  const OrderHistory({
    required this.statusCounts,
    required this.activeStatus,
    required this.dateRange,
    required this.unreturnedContainers,
    required this.containerReturnPoints,
    required this.orders,
  });

  /// Jumlah pesanan per status, termasuk kunci `all`.
  final Map<String, int> statusCounts;
  final String activeStatus;
  final String dateRange;
  final int unreturnedContainers;
  final int containerReturnPoints;
  final List<Order> orders;
}
