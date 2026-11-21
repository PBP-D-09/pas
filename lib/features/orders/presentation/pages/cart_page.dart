import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_errors.dart';
import '../widgets/orders_format.dart';
import '../widgets/orders_widgets.dart';
import 'checkout_page.dart';
import 'order_placed_page.dart';

/// Halaman keranjang (Your cart). Membutuhkan [CartProvider] dari pemanggil.
class CartPage extends StatelessWidget {
  const CartPage({required this.repository, this.hasToken, super.key});

  final OrdersRepository repository;
  final TokenCheck? hasToken;

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final navigator = Navigator.of(context);
    final order = await navigator.push<Order>(
      MaterialPageRoute(
        builder: (_) =>
            CheckoutPage(repository: repository, hasToken: hasToken),
      ),
    );
    if (order == null) {
      // Keranjang bisa berubah (mis. stok habis), jadi muat ulang.
      await cart.load();
      return;
    }
    navigator.pushReplacement(
      MaterialPageRoute<void>(builder: (_) => OrderPlacedPage(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, _) {
        final cart = provider.cart;
        return Scaffold(
          appBar: AppBar(title: const Text('Your cart')),
          body: _buildBody(context, provider),
          bottomNavigationBar: cart == null || cart.isEmpty
              ? null
              : _CartSummaryBar(
                  cart: cart,
                  onCheckout: () => _checkout(context),
                ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CartProvider provider) {
    if (provider.needsLogin) {
      return OrdersLoginRequiredState(onRetry: provider.load);
    }
    final cart = provider.cart;
    if (provider.isLoading && cart == null) {
      return const OrdersLoadingState(message: 'Loading your cart...');
    }
    if (cart == null) {
      return OrdersErrorState(
        message: provider.errorMessage ?? 'Something went wrong.',
        onRetry: provider.load,
      );
    }
    if (cart.isEmpty) {
      return const OrdersMessageState(
        icon: Icons.shopping_cart_outlined,
        title: 'Your cart is empty',
        message:
            'Add a healthy bowl from the Catalog tab, or use "Order again" '
            'on a past order.',
      );
    }

    final colors = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: provider.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          if (provider.errorMessage != null) ...[
            Text(provider.errorMessage!, style: TextStyle(color: colors.error)),
            const SizedBox(height: 12),
          ],
          for (final item in cart.items) ...[
            CartItemTile(
              item: item,
              isBusy: provider.isBusy(item.id),
              onIncrease: () => provider.increase(item),
              onDecrease: () => provider.decrease(item),
              onRemove: () => _confirmRemove(context, provider, item),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    CartProvider provider,
    CartItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove item?'),
        content: Text('Remove ${item.name} from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) await provider.remove(item);
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({required this.cart, required this.onCheckout});

  final Cart cart;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final items = cart.totalItems == 1 ? 'item' : 'items';
    final tenants = cart.tenantCount == 1 ? 'tenant' : 'tenants';
    return Material(
      color: Colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SummaryRow(
                label:
                    '${cart.totalItems} $items from ${cart.tenantCount} '
                    '$tenants',
                value: formatRupiah(cart.subtotal),
                emphasize: true,
              ),
              Text(
                'Packaging and delivery fees are calculated at checkout.',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: onCheckout,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
