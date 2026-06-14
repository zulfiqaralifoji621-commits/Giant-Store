import 'cart_item.dart';
import 'product.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class StoreOrder {
  const StoreOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
  });

  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String shippingAddress;

  factory StoreOrder.fromMap(String id, Map<String, dynamic> data) {
    final rawItems = data['items'] as List<dynamic>? ?? [];
    return StoreOrder(
      id: id,
      userId: data['userId'] as String? ?? '',
      items: rawItems.map((item) {
        final map = item as Map<String, dynamic>;
        final product = Product(
          id: map['productId'] as String? ?? '',
          name: map['name'] as String? ?? '',
          description: '',
          price: (map['price'] as num?)?.toDouble() ?? 0,
          imageUrl: map['imageUrl'] as String? ?? '',
          category: 'Order',
          stock: 0,
        );
        return CartItem(
          product: product,
          quantity: (map['quantity'] as num?)?.toInt() ?? 1,
        );
      }).toList(),
      total: (data['total'] as num?)?.toDouble() ?? 0,
      status: _parseStatus(data['status'] as String?),
      createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '') ??
          DateTime.now(),
      shippingAddress: data['shippingAddress'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'shippingAddress': shippingAddress,
    };
  }

  static OrderStatus _parseStatus(String? value) {
    return OrderStatus.values.firstWhere(
          (status) => status.name == value,
      orElse: () => OrderStatus.pending,
    );
  }
}
