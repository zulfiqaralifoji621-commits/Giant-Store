import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/order.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../widgets/empty_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final orderService = OrderService();
    final currency = NumberFormat.simpleCurrency();
    final dateFormat = DateFormat.yMMMd().add_jm();

    if (user == null) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Sign in required',
          message: 'Log in to view your order history.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: StreamBuilder<List<StoreOrder>>(
        stream: orderService.watchUserOrders(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message: 'Your purchases will show up here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${order.id.substring(0, 6)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Chip(label: Text(order.status.name)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(dateFormat.format(order.createdAt)),
                      const SizedBox(height: 8),
                      Text('${order.items.length} item(s)'),
                      const SizedBox(height: 8),
                      Text(
                        currency.format(order.total),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
