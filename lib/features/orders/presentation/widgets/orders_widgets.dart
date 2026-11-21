import 'package:flutter/material.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/order.dart';
import 'orders_format.dart';

// --- State umum (loading, error, login, kosong) ---------------------------

class OrdersLoadingState extends StatelessWidget {
  const OrdersLoadingState({super.key, this.message = 'Loading...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    );
  }
}

class OrdersMessageState extends StatelessWidget {
  const OrdersMessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isError = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: isError ? colors.error : colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class OrdersLoginRequiredState extends StatelessWidget {
  const OrdersLoginRequiredState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return OrdersMessageState(
      icon: Icons.lock_outline,
      title: 'Log in to see your orders',
      message:
          'Your cart and order history are linked to your SustainaBowl '
          'customer account. Log in from the Accounts tab, then try again.',
      actionLabel: 'Try again',
      onAction: onRetry,
    );
  }
}

class OrdersErrorState extends StatelessWidget {
  const OrdersErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return OrdersMessageState(
      icon: Icons.cloud_off_outlined,
      title: "Couldn't load this page",
      message: message,
      actionLabel: 'Try again',
      onAction: onRetry,
      isError: true,
    );
  }
}

// --- Kartu dan elemen kecil ---------------------------------------------

class OrdersSectionCard extends StatelessWidget {
  const OrdersSectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground) = switch (order.status) {
      OrderStatus.pending => (const Color(0xFFFFF4D6), const Color(0xFF7A5300)),
      OrderStatus.processing => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
      ),
      OrderStatus.onTheWay => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
      ),
      OrderStatus.delivered => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
      ),
      _ => (colors.errorContainer, colors.onErrorContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            order.statusDisplay,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: foreground, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class EcoPointsBadge extends StatelessWidget {
  const EcoPointsBadge({
    required this.points,
    this.suffix = 'Eco Points',
    super.key,
  });

  final int points;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.eco_outlined, size: 16, color: colors.tertiary),
        const SizedBox(width: 4),
        Text(
          '+$points $suffix',
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: colors.tertiary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
    super.key,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = emphasize
        ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class MenuThumbnail extends StatelessWidget {
  const MenuThumbnail({required this.photoUrl, this.size = 56, super.key});

  final String? photoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: size,
      height: size,
      color: colors.surfaceContainerHighest,
      child: Icon(Icons.rice_bowl_outlined, color: colors.primary),
    );
    final url = photoUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: url == null
          ? placeholder
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            ),
    );
  }
}

// --- Keranjang ----------------------------------------------------------

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    required this.item,
    required this.isBusy,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final bool isBusy;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tenant = [
      item.tenantName,
      item.tenantArea,
    ].where((part) => part.isNotEmpty).join(' · ');
    return OrdersSectionCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MenuThumbnail(photoUrl: item.photoUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (tenant.isNotEmpty)
                  Text(
                    tenant,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(formatRupiah(item.price), style: textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StepperButton(
                      icon: Icons.remove,
                      tooltip: 'Decrease ${item.name}',
                      onPressed: isBusy || item.quantity <= 1
                          ? null
                          : onDecrease,
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall,
                      ),
                    ),
                    _StepperButton(
                      icon: Icons.add,
                      tooltip: 'Increase ${item.name}',
                      onPressed: isBusy ? null : onIncrease,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: isBusy ? null : onRemove,
                      style: TextButton.styleFrom(
                        foregroundColor: colors.error,
                      ),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formatRupiah(item.subtotal),
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 18),
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      padding: EdgeInsets.zero,
    );
  }
}

// --- Riwayat pesanan ----------------------------------------------------

class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.order,
    required this.isBusy,
    required this.onEditNote,
    required this.onCancel,
    required this.onReorder,
    required this.onReview,
    super.key,
  });

  final Order order;
  final bool isBusy;
  final VoidCallback onEditNote;
  final VoidCallback onCancel;
  final VoidCallback onReorder;
  final void Function(OrderItem item) onReview;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant);
    final canOrderAgain =
        (order.status == OrderStatus.delivered ||
            order.status == OrderStatus.cancelled) &&
        order.canReorder;

    return OrdersSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderCode,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    Text(formatOrderDate(order.createdAt), style: muted),
                  ],
                ),
              ),
              OrderStatusChip(order: order),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}× ${item.itemName}',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  if (order.status == OrderStatus.delivered &&
                      item.menuItemId != null)
                    TextButton(
                      onPressed: () => onReview(item),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('Review'),
                    ),
                  Text(
                    formatRupiah(item.subtotal),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          if (order.deliveryNotes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.sticky_note_2_outlined,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(order.deliveryNotes, style: muted)),
              ],
            ),
          ],
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.packagingDisplay, style: muted),
                    if (order.ecoPoints > 0 &&
                        order.status != OrderStatus.cancelled)
                      EcoPointsBadge(points: order.ecoPoints),
                  ],
                ),
              ),
              Text(
                formatRupiah(order.totalPrice),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (order.canEditNote || order.canCancel || canOrderAgain) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 4,
              children: [
                if (order.canEditNote)
                  TextButton(
                    onPressed: isBusy ? null : onEditNote,
                    child: const Text('Edit note'),
                  ),
                if (order.canCancel)
                  OutlinedButton(
                    onPressed: isBusy ? null : onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide(color: colors.error),
                    ),
                    child: const Text('Cancel order'),
                  ),
                if (canOrderAgain)
                  OutlinedButton(
                    onPressed: isBusy ? null : onReorder,
                    child: const Text('Order again'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Banner pengingat wadah reusable yang belum dikembalikan.
class ContainerReturnBanner extends StatelessWidget {
  const ContainerReturnBanner({
    required this.containers,
    required this.pointsPerContainer,
    super.key,
  });

  final int containers;
  final int pointsPerContainer;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final noun = containers == 1 ? 'container' : 'containers';
    final pronoun = containers == 1 ? 'it' : 'them';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.recycling, color: colors.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reusable containers to return',
                  style: textTheme.titleSmall?.copyWith(
                    color: colors.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You have $containers $noun from delivered orders. Hand '
                  '$pronoun to the courier on your next delivery.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                EcoPointsBadge(points: pointsPerContainer, suffix: 'on return'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
