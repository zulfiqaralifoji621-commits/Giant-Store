import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  OrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  Stream<List<StoreOrder>> watchUserOrders(String userId) {
    return _orders
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => StoreOrder.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<String> placeOrder({
    required String userId,
    required List<CartItem> items,
    required String shippingAddress,
  }) async {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    final order = StoreOrder(
      id: '',
      userId: userId,
      items: items,
      total: total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
    );
    final doc = await _orders.add(order.toMap());
    return doc.id;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _orders.doc(orderId).update({'status': status.name});
  }
}
