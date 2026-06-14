import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../services/product_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';
import '../products/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productService = ProductService();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _productService.seedSampleProducts();
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_selectedCategory == 'All') return products;
    return products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GiantStore'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productService.watchActiveProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Could not load products',
              message: 'Check your Firebase connection and try again.',
            );
          }

          final products = snapshot.data ?? [];
          final categories = {
            'All',
            ...products.map((product) => product.category),
          }.toList();

          final filtered = _filterProducts(products);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Discover deals',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = category == _selectedCategory;
                    return FilterChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selectedCategory = category);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'No products yet',
                  message: 'Products will appear here once added.',
                )
                    : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      onAddToCart: () {
                        context.read<CartProvider>().addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
