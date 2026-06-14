import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _authService = AuthService();
  final _orderService = OrderService();

  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null) return;

    setState(() => _isPlacingOrder = true);

    try {
      final cart = context.read<CartProvider>();
      await _orderService.placeOrder(
        userId: user.uid,
        items: cart.items,
        shippingAddress: _addressController.text.trim(),
      );
      cart.clear();

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not place order. Try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final currency = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Shipping address',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Street, city, postal code',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a shipping address';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Order summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...cart.items.map(
                  (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.product.name),
                subtitle: Text('Qty: ${item.quantity}'),
                trailing: Text(currency.format(item.subtotal)),
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Total'),
              trailing: Text(
                currency.format(cart.total),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isPlacingOrder ? null : _placeOrder,
              child: _isPlacingOrder
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Place order'),
            ),
          ],
        ),
      ),
    );
  }
}
