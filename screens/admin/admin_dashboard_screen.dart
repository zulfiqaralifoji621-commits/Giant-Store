import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../widgets/empty_state.dart';
import 'product_form_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ProductFormScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add product',
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: productService.watchAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'No products',
              message: 'Add your first product to the catalog.',
              action: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProductFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add product'),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    '${product.category} · Stock: ${product.stock} · '
                        '${product.isActive ? 'Active' : 'Hidden'}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductFormScreen(product: product),
                          ),
                        );
                      } else if (value == 'toggle') {
                        await productService.updateProduct(
                          product.copyWith(isActive: !product.isActive),
                        );
                      } else if (value == 'delete') {
                        await productService.deleteProduct(product.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(
                          product.isActive ? 'Hide' : 'Show',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProductFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
    );
  }
}
