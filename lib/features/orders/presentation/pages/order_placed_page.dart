import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';
import '../widgets/orders_format.dart';
import '../widgets/orders_widgets.dart';

/// Konfirmasi setelah checkout berhasil (langkah 3 di web).
class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Order placed')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          Icon(Icons.check_circle, size: 72, color: colors.tertiary),
          const SizedBox(height: 12),
          Text(
            'Thanks! Your order is in.',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.orderCode} · arrives in about '
            '${order.deliveryEtaMinutes} min',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          OrdersSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in order.items)
                  SummaryRow(
                    label: '${item.quantity}× ${item.itemName}',
                    value: formatRupiah(item.subtotal),
                  ),
                const Divider(height: 20),
                SummaryRow(
                  label: 'Subtotal',
                  value: formatRupiah(order.subtotal),
                ),
                SummaryRow(
                  label: order.packagingDisplay,
                  value: formatRupiah(order.packagingFee),
                ),
                SummaryRow(
                  label: 'Delivery',
                  value: formatRupiah(order.deliveryFee),
                ),
                const Divider(height: 20),
                SummaryRow(
                  label: 'Total',
                  value: formatRupiah(order.totalPrice),
                  emphasize: true,
                ),
                if (order.ecoPoints > 0) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: EcoPointsBadge(points: order.ecoPoints),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          OrdersSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivering to',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(order.deliveryAddress),
                if (order.deliveryNotes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Note: ${order.deliveryNotes}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('View my orders'),
          ),
        ],
      ),
    );
  }
}
