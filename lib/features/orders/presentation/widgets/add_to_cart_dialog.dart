import 'package:flutter/material.dart';

import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/manage_cart.dart';
import '../providers/orders_errors.dart';
import 'orders_format.dart';

/// Dialog konfirmasi jumlah sebelum menambahkan menu ke keranjang, sama
/// seperti dialog Add to cart di web.
///
/// Dipanggil dari halaman menu (modul Catalog), contoh:
/// ```dart
/// final added = await showAddToCartDialog(
///   context,
///   menuItemId: menu.id,
///   menuName: menu.name,
///   price: menu.price,
/// );
/// ```
/// Mengembalikan true jika item berhasil ditambahkan.
Future<bool> showAddToCartDialog(
  BuildContext context, {
  required String menuItemId,
  required String menuName,
  required int price,
  OrdersRepository? repository,
}) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final quantity = await showDialog<int>(
    context: context,
    builder: (_) => AddToCartDialog(
      menuItemId: menuItemId,
      menuName: menuName,
      price: price,
      addToCart: AddToCart(repository ?? createOrdersRepository()),
    ),
  );
  if (quantity == null) return false;
  messenger?.showSnackBar(
    SnackBar(content: Text('${quantity}x $menuName added to your cart.')),
  );
  return true;
}

class AddToCartDialog extends StatefulWidget {
  const AddToCartDialog({
    required this.menuItemId,
    required this.menuName,
    required this.price,
    required this.addToCart,
    super.key,
  });

  final String menuItemId;
  final String menuName;
  final int price;
  final AddToCart addToCart;

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  static const _maxQuantity = 20;

  int _quantity = 1;
  bool _isSubmitting = false;
  String? _error;

  Future<void> _submit() async {
    if (!defaultTokenCheck()) {
      setState(() => _error = 'Log in from the Accounts tab to order.');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await widget.addToCart(widget.menuItemId, quantity: _quantity);
      if (mounted) Navigator.pop(context, _quantity);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _error = describeError(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: const Text('Add to cart'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.menuName, style: textTheme.titleMedium),
          Text(
            formatRupiah(widget.price),
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                tooltip: 'Decrease quantity',
                onPressed: _isSubmitting || _quantity <= 1
                    ? null
                    : () => setState(() => _quantity--),
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall,
                ),
              ),
              IconButton.outlined(
                tooltip: 'Increase quantity',
                onPressed: _isSubmitting || _quantity >= _maxQuantity
                    ? null
                    : () => setState(() => _quantity++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: Text('Total')),
              Text(
                formatRupiah(widget.price * _quantity),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: colors.error)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add to cart'),
        ),
      ],
    );
  }
}
