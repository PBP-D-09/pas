import '../../domain/entities/order_history.dart';
import 'json_reader.dart';
import 'order_model.dart';

class OrderHistoryModel extends OrderHistory {
  const OrderHistoryModel({
    required super.statusCounts,
    required super.activeStatus,
    required super.dateRange,
    required super.unreturnedContainers,
    required super.containerReturnPoints,
    required super.orders,
  });

  factory OrderHistoryModel.fromJson(Object? value) {
    final json = JsonReader(value, 'orders');
    return OrderHistoryModel(
      statusCounts: json.intMap('status_counts'),
      activeStatus: json.string('active_status'),
      dateRange: json.string('date_range'),
      unreturnedContainers: json.integer('unreturned_containers'),
      containerReturnPoints: json.integer('container_return_points'),
      orders: json.list('results', OrderModel.fromReader),
    );
  }
}
