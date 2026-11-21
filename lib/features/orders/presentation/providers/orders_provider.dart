import 'package:flutter/foundation.dart';

import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_history.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/manage_order.dart';
import 'orders_errors.dart';

/// State halaman My orders: riwayat, filter, dan aksi per pesanan.
class OrdersProvider extends ChangeNotifier {
  OrdersProvider(OrdersRepository repository, {TokenCheck? hasToken})
    : _getOrders = GetOrders(repository),
      _cancelOrder = CancelOrder(repository),
      _updateOrderNote = UpdateOrderNote(repository),
      _reorder = Reorder(repository),
      _hasToken = hasToken ?? defaultTokenCheck;

  final GetOrders _getOrders;
  final CancelOrder _cancelOrder;
  final UpdateOrderNote _updateOrderNote;
  final Reorder _reorder;
  final TokenCheck _hasToken;

  OrderHistory? _history;
  OrderFilter _filter = const OrderFilter();
  String? _errorMessage;
  bool _isLoading = false;
  bool _needsLogin = false;
  final Set<String> _busyOrderIds = {};

  OrderHistory? get history => _history;
  OrderFilter get filter => _filter;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get needsLogin => _needsLogin;

  bool isBusy(String orderId) => _busyOrderIds.contains(orderId);

  /// Memuat ulang riwayat. Saat [silent], daftar lama tetap tampil selama
  /// memuat (dipakai untuk pull-to-refresh dan setelah aksi).
  Future<void> load({bool silent = false}) async {
    if (!_hasToken()) {
      _needsLogin = true;
      _history = null;
      notifyListeners();
      return;
    }
    _needsLogin = false;
    _errorMessage = null;
    if (!silent || _history == null) {
      _isLoading = true;
    }
    notifyListeners();
    try {
      _history = await _getOrders(_filter);
    } catch (error) {
      if (isUnauthorized(error)) {
        _needsLogin = true;
        _history = null;
      } else {
        _errorMessage = describeError(error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setStatus(String status) {
    if (status == _filter.status) return Future.value();
    _filter = _filter.copyWith(status: status);
    return load();
  }

  Future<void> setDateRange(
    String dateRange, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _filter = OrderFilter(
      status: _filter.status,
      dateRange: dateRange,
      startDate: startDate,
      endDate: endDate,
    );
    return load();
  }

  /// Membatalkan pesanan Pending. Melempar error agar halaman bisa
  /// menampilkan pesannya.
  Future<Order> cancel(Order order) async {
    final updated = await _runAction(order.id, () => _cancelOrder(order.id));
    // Jumlah per status berubah, jadi muat ulang tanpa spinner penuh.
    await load(silent: true);
    return updated;
  }

  Future<Order> updateNote(Order order, String deliveryNotes) async {
    final updated = await _runAction(
      order.id,
      () => _updateOrderNote(order.id, deliveryNotes.trim()),
    );
    _replaceOrder(updated);
    return updated;
  }

  Future<ReorderResult> reorder(Order order) {
    return _runAction(order.id, () => _reorder(order.id));
  }

  Future<T> _runAction<T>(String orderId, Future<T> Function() action) async {
    _busyOrderIds.add(orderId);
    notifyListeners();
    try {
      return await action();
    } finally {
      _busyOrderIds.remove(orderId);
      notifyListeners();
    }
  }

  void _replaceOrder(Order updated) {
    final history = _history;
    if (history == null) return;
    _history = OrderHistory(
      statusCounts: history.statusCounts,
      activeStatus: history.activeStatus,
      dateRange: history.dateRange,
      unreturnedContainers: history.unreturnedContainers,
      containerReturnPoints: history.containerReturnPoints,
      orders: [
        for (final order in history.orders)
          order.id == updated.id ? updated : order,
      ],
    );
    notifyListeners();
  }
}
