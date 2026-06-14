import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ColoredBox(
                  color: Color(0xFFEEF2F0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => const ColoredBox(
                  color: Color(0xFFEEF2F0),
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          currency.format(product.price),
                          style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppThemeColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (onAddToCart != null)
                        IconButton.filledTonal(
                          onPressed: product.stock > 0 ? onAddToCart : null,
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppThemeColors {
  static const Color primary = Color(0xFF1B4332);
}
