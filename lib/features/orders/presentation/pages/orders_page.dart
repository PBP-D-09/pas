import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../reviews/presentation/pages/reviews_page.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../providers/orders_errors.dart';
import '../providers/orders_provider.dart';
import '../widgets/orders_format.dart';
import '../widgets/orders_widgets.dart';
import 'cart_page.dart';

/// Tab Orders: riwayat pesanan (My orders) dengan akses ke keranjang.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key, this.repository, this.hasToken});

  /// Diisi saat tes; default memakai API Django.
  final OrdersRepository? repository;
  final TokenCheck? hasToken;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final OrdersRepository _repository =
      widget.repository ?? createOrdersRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              OrdersProvider(_repository, hasToken: widget.hasToken)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CartProvider(_repository, hasToken: widget.hasToken)..load(),
        ),
      ],
      child: _OrdersView(repository: _repository, hasToken: widget.hasToken),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView({required this.repository, required this.hasToken});

  final OrdersRepository repository;
  final TokenCheck? hasToken;

  Future<void> _openCart(BuildContext context) async {
    final orders = context.read<OrdersProvider>();
    final cart = context.read<CartProvider>();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<CartProvider>.value(
          value: cart,
          child: CartPage(repository: repository, hasToken: hasToken),
        ),
      ),
    );
    // Setelah checkout, pesanan baru dan keranjang kosong perlu dimuat ulang.
    await Future.wait([orders.load(silent: true), cart.load()]);
  }

  Future<void> _reloadAll(BuildContext context) {
    return Future.wait([
      context.read<OrdersProvider>().load(),
      context.read<CartProvider>().load(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = context.select<CartProvider, int>((p) => p.itemCount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My orders'),
        actions: [
          IconButton(
            tooltip: 'Your cart',
            onPressed: () => _openCart(context),
            icon: Badge.count(
              count: itemCount,
              isLabelVisible: itemCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, provider, _) {
          if (provider.needsLogin) {
            return OrdersLoginRequiredState(onRetry: () => _reloadAll(context));
          }
          if (provider.isLoading && provider.history == null) {
            return const OrdersLoadingState(message: 'Loading your orders...');
          }
          final history = provider.history;
          if (history == null) {
            return OrdersErrorState(
              message: provider.errorMessage ?? 'Something went wrong.',
              onRetry: provider.load,
            );
          }
          return RefreshIndicator(
            onRefresh: () => _reloadAll(context),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                _StatusFilter(provider: provider),
                const SizedBox(height: 4),
                _DateRangeFilter(provider: provider),
                const SizedBox(height: 12),
                if (provider.isLoading) const LinearProgressIndicator(),
                if (provider.errorMessage != null) ...[
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (history.unreturnedContainers > 0) ...[
                  ContainerReturnBanner(
                    containers: history.unreturnedContainers,
                    pointsPerContainer: history.containerReturnPoints,
                  ),
                  const SizedBox(height: 12),
                ],
                if (history.orders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 48),
                    child: OrdersMessageState(
                      icon: Icons.receipt_long_outlined,
                      title: 'No orders yet',
                      message:
                          'Orders that match these filters will show up here.',
                    ),
                  )
                else
                  for (final order in history.orders) ...[
                    OrderCard(
                      order: order,
                      isBusy: provider.isBusy(order.id),
                      onEditNote: () => _editNote(context, order),
                      onCancel: () => _cancel(context, order),
                      onReorder: () => _reorder(context, order),
                      onReview: (item) => _openReview(context, item),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _editNote(BuildContext context, Order order) async {
    final provider = context.read<OrdersProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final note = await showDialog<String>(
      context: context,
      builder: (_) => _EditNoteDialog(order: order),
    );
    if (note == null) return;
    try {
      await provider.updateNote(order, note);
      messenger.showSnackBar(
        const SnackBar(content: Text('Delivery note updated.')),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(error))));
    }
  }

  Future<void> _cancel(BuildContext context, Order order) async {
    final provider = context.read<OrdersProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cancel ${order.orderCode}?'),
        content: const Text(
          'The tenant has not started on this order yet. Eco Points from it '
          'will be taken back and any reusable containers are released.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep order'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final updated = await provider.cancel(order);
      messenger.showSnackBar(
        SnackBar(content: Text('Order ${updated.orderCode} cancelled.')),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(error))));
    }
  }

  Future<void> _reorder(BuildContext context, Order order) async {
    final provider = context.read<OrdersProvider>();
    final cart = context.read<CartProvider>();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await provider.reorder(order);
      cart.replaceCart(result.cart);
      final count = result.addedCount;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '$count item${count == 1 ? '' : 's'} from ${order.orderCode} '
            'added to your cart.',
          ),
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () {
              if (context.mounted) _openCart(context);
            },
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(error))));
    }
  }

  void _openReview(BuildContext context, OrderItem item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReviewsPage(menuUuid: item.menuItemId),
      ),
    );
  }
}

const _statusFilters = [
  ('all', 'All'),
  (OrderStatus.pending, 'Pending'),
  (OrderStatus.processing, 'Processing'),
  (OrderStatus.onTheWay, 'On the way'),
  (OrderStatus.delivered, 'Delivered'),
  (OrderStatus.cancelled, 'Cancelled'),
];

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.provider});

  final OrdersProvider provider;

  @override
  Widget build(BuildContext context) {
    final counts = provider.history?.statusCounts ?? const <String, int>{};
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (value, label) in _statusFilters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('$label (${counts[value] ?? 0})'),
                selected: provider.filter.status == value,
                onSelected: (_) => provider.setStatus(value),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateRangeFilter extends StatelessWidget {
  const _DateRangeFilter({required this.provider});

  final OrdersProvider provider;

  static const _ranges = [
    ('all', 'Any time'),
    ('today', 'Today'),
    ('7_days', 'Last 7 days'),
    ('30_days', 'Last 30 days'),
  ];

  @override
  Widget build(BuildContext context) {
    final filter = provider.filter;
    final start = filter.startDate;
    final end = filter.endDate;
    final customLabel = filter.dateRange == 'custom' && start != null
        ? '${formatShortDate(start)} – ${formatShortDate(end ?? start)}'
        : 'Custom…';
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (value, label) in _ranges)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: filter.dateRange == value,
                onSelected: (_) => provider.setDateRange(value),
              ),
            ),
          ChoiceChip(
            label: Text(customLabel),
            selected: filter.dateRange == 'custom',
            onSelected: (_) => _pickCustomRange(context),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: provider.filter.startDate == null
          ? null
          : DateTimeRange(
              start: provider.filter.startDate!,
              end: provider.filter.endDate ?? provider.filter.startDate!,
            ),
    );
    if (range == null) return;
    await provider.setDateRange(
      'custom',
      startDate: range.start,
      endDate: range.end,
    );
  }
}

class _EditNoteDialog extends StatefulWidget {
  const _EditNoteDialog({required this.order});

  final Order order;

  @override
  State<_EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<_EditNoteDialog> {
  late final _controller = TextEditingController(
    text: widget.order.deliveryNotes,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delivery note · ${widget.order.orderCode}'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 3,
        maxLength: deliveryNoteMaxLength,
        decoration: const InputDecoration(
          hintText: 'e.g. Leave it with the security desk',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Save note'),
        ),
      ],
    );
  }
}
