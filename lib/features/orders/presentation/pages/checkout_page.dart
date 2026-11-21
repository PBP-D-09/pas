import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/checkout_summary.dart';
import '../../domain/repositories/orders_repository.dart';
import '../providers/checkout_provider.dart';
import '../providers/orders_errors.dart';
import '../widgets/orders_format.dart';
import '../widgets/orders_widgets.dart';

/// Checkout: pilih alamat, kemasan ramah lingkungan, dan catatan pengiriman.
/// Mengembalikan `Order` lewat `Navigator.pop` setelah pesanan dibuat.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({required this.repository, this.hasToken, super.key});

  final OrdersRepository repository;
  final TokenCheck? hasToken;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(CheckoutProvider provider) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final order = await provider.placeOrder(_notesController.text);
    if (order != null) {
      navigator.pop(order);
    } else if (provider.placeError != null) {
      messenger.showSnackBar(SnackBar(content: Text(provider.placeError!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CheckoutProvider(widget.repository, hasToken: widget.hasToken)
            ..load(),
      child: Consumer<CheckoutProvider>(
        builder: (context, provider, _) {
          final summary = provider.summary;
          return Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: _buildBody(context, provider),
            bottomNavigationBar: summary == null
                ? null
                : _PlaceOrderBar(
                    provider: provider,
                    onPlaceOrder: () => _placeOrder(provider),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CheckoutProvider provider) {
    if (provider.needsLogin) {
      return OrdersLoginRequiredState(onRetry: provider.load);
    }
    final summary = provider.summary;
    if (provider.isLoading && summary == null) {
      return const OrdersLoadingState(message: 'Preparing checkout...');
    }
    if (summary == null) {
      return OrdersErrorState(
        message: provider.errorMessage ?? 'Something went wrong.',
        onRetry: provider.load,
      );
    }

    final textTheme = Theme.of(context).textTheme;
    final heading = textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Delivery address', style: heading),
        const SizedBox(height: 8),
        if (summary.addresses.isEmpty)
          OrdersSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You don't have a saved address yet. Add one from the Map "
                  'tab, then refresh this page.',
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: provider.load,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh addresses'),
                ),
              ],
            ),
          )
        else
          for (final address in summary.addresses) ...[
            _AddressOption(
              address: address,
              selected: address.id == provider.selectedAddressId,
              onTap: () => provider.selectAddress(address.id),
            ),
            const SizedBox(height: 8),
          ],
        const SizedBox(height: 16),
        Text('Packaging', style: heading),
        const SizedBox(height: 8),
        for (final option in summary.packagingOptions) ...[
          _PackagingOptionTile(
            option: option,
            selected: option.value == provider.selectedPackaging,
            onTap: () => provider.selectPackaging(option),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 16),
        Text('Delivery note', style: heading),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          maxLength: deliveryNoteMaxLength,
          decoration: const InputDecoration(
            hintText: 'e.g. Leave it with the security desk',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text('Order summary', style: heading),
        const SizedBox(height: 8),
        OrdersSectionCard(
          child: Column(
            children: [
              for (final item in summary.cart.items)
                SummaryRow(
                  label: '${item.quantity}× ${item.name}',
                  value: formatRupiah(item.subtotal),
                ),
              const Divider(height: 20),
              SummaryRow(
                label: 'Subtotal',
                value: formatRupiah(provider.subtotal),
              ),
              SummaryRow(
                label: 'Packaging',
                value: formatRupiah(provider.packagingFee),
              ),
              SummaryRow(
                label: 'Delivery',
                value: provider.deliveryFee == null
                    ? '—'
                    : formatRupiah(provider.deliveryFee!),
              ),
              const Divider(height: 20),
              SummaryRow(
                label: 'Total',
                value: formatRupiah(provider.total),
                emphasize: true,
              ),
              if (provider.ecoPoints > 0) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: EcoPointsBadge(points: provider.ecoPoints),
                ),
              ],
            ],
          ),
        ),
        if (provider.placeError != null) ...[
          const SizedBox(height: 12),
          Text(
            provider.placeError!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.selected,
    required this.onTap,
    required this.child,
    this.enabled = true,
  });

  final bool selected;
  final bool enabled;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: enabled ? Colors.white : colors.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: enabled ? colors.primary : colors.outline,
              ),
              const SizedBox(width: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressOption extends StatelessWidget {
  const _AddressOption({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final CheckoutAddress address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final muted = textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant);
    return Semantics(
      selected: selected,
      button: true,
      label: 'Deliver to ${address.label}',
      child: _SelectableCard(
        selected: selected,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  address.label,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  Text('Default', style: muted),
                ],
                const Spacer(),
                Text(
                  formatRupiah(address.deliveryFee),
                  style: textTheme.titleSmall,
                ),
              ],
            ),
            Text(
              '${address.recipientName} · ${address.phoneNumber}',
              style: muted,
            ),
            const SizedBox(height: 2),
            Text(address.address, style: textTheme.bodyMedium),
            if (address.landmark.isNotEmpty)
              Text('Landmark: ${address.landmark}', style: muted),
            const SizedBox(height: 4),
            Text('Arrives in about ${address.etaMinutes} min', style: muted),
          ],
        ),
      ),
    );
  }
}

class _PackagingOptionTile extends StatelessWidget {
  const _PackagingOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final PackagingOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      selected: selected,
      enabled: !option.disabled,
      button: true,
      label: option.label,
      child: _SelectableCard(
        selected: selected,
        enabled: !option.disabled,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    option.label,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(formatRupiah(option.fee), style: textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              option.description,
              style: textTheme.bodySmall?.copyWith(
                color: option.disabled ? colors.error : colors.onSurfaceVariant,
              ),
            ),
            if (!option.disabled) ...[
              const SizedBox(height: 6),
              EcoPointsBadge(points: option.ecoPoints),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  const _PlaceOrderBar({required this.provider, required this.onPlaceOrder});

  final CheckoutProvider provider;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: FilledButton(
            onPressed: provider.canPlaceOrder ? onPlaceOrder : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: provider.isPlacing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Place order · ${formatRupiah(provider.total)}'),
          ),
        ),
      ),
    );
  }
}
