import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ColoredBox(
                color: Color(0xFFEEF2F0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currency.format(product.price),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF1B4332),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text('In stock: ${product.stock}'),
                const SizedBox(height: 24),
                Row(
                  children: [
                    IconButton.outlined(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: _quantity < product.stock
                          ? () => setState(() => _quantity++)
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: product.stock > 0
                ? () {
              context
                  .read<CartProvider>()
                  .addProduct(product, quantity: _quantity);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added ${product.name} to cart'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
                : null,
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to cart'),
          ),
        ),
      ),
    );
  }
}
