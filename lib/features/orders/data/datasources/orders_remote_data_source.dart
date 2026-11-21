import '../../../../core/network/api_client.dart';
import '../../domain/entities/order_history.dart';

/// Endpoint DRF modul Orders di web Django (`/api/v1/orders/`).
class OrdersRemoteDataSource {
  const OrdersRemoteDataSource({required this.apiClient});

  static const basePath = '/api/v1/orders/';

  final ApiClient apiClient;

  Future<Object?> getCart() => apiClient.get('${basePath}cart/');

  Future<Object?> addCartItem(String menuItemId, int quantity) {
    return apiClient.post(
      '${basePath}cart/items/',
      body: {'menu_item_id': menuItemId, 'quantity': quantity},
    );
  }

  Future<Object?> updateCartItem(String itemId, int quantity) {
    return apiClient.patch(
      '${basePath}cart/items/${_segment(itemId)}/',
      body: {'quantity': quantity},
    );
  }

  Future<Object?> deleteCartItem(String itemId) {
    return apiClient.delete('${basePath}cart/items/${_segment(itemId)}/');
  }

  Future<Object?> getCheckout() => apiClient.get('${basePath}checkout/');

  Future<Object?> postCheckout({
    required int addressId,
    required String packagingType,
    required String deliveryNotes,
  }) {
    return apiClient.post(
      '${basePath}checkout/',
      body: {
        'address_id': addressId,
        'packaging_type': packagingType,
        'delivery_notes': deliveryNotes,
      },
    );
  }

  Future<Object?> getOrders(OrderFilter filter) {
    final query = <String, String>{
      if (filter.status != 'all') 'status': filter.status,
      if (filter.dateRange != 'all') 'date_range': filter.dateRange,
      if (filter.dateRange == 'custom' && filter.startDate != null)
        'start_date': _date(filter.startDate!),
      if (filter.dateRange == 'custom' && filter.endDate != null)
        'end_date': _date(filter.endDate!),
    };
    final suffix = query.isEmpty ? '' : '?${Uri(queryParameters: query).query}';
    return apiClient.get('$basePath$suffix');
  }

  Future<Object?> cancelOrder(String orderId) {
    return apiClient.post('$basePath${_segment(orderId)}/cancel/');
  }

  Future<Object?> updateOrderNote(String orderId, String deliveryNotes) {
    return apiClient.patch(
      '$basePath${_segment(orderId)}/note/',
      body: {'delivery_notes': deliveryNotes},
    );
  }

  Future<Object?> reorder(String orderId) {
    return apiClient.post('$basePath${_segment(orderId)}/reorder/');
  }

  static String _segment(String value) => Uri.encodeComponent(value);

  static String _date(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)}';
  }
}
