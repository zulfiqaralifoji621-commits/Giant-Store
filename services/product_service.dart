import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductService {
  ProductService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> watchActiveProducts() {
    return _products
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<Product>> watchAllProducts() {
    return _products.orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<Product?> getProduct(String id) async {
    final doc = await _products.doc(id).get();
    if (!doc.exists) return null;
    return Product.fromMap(doc.id, doc.data()!);
  }

  Future<String> addProduct(Product product) async {
    final doc = await _products.add(product.toMap());
    return doc.id;
  }

  Future<void> updateProduct(Product product) async {
    await _products.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }

  Future<void> seedSampleProducts() async {
    final existing = await _products.limit(1).get();
    if (existing.docs.isNotEmpty) return;

    final samples = [
      Product(
        id: '',
        name: 'Wireless Headphones',
        description: 'Premium noise-cancelling headphones with 30h battery.',
        price: 129.99,
        imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        category: 'Electronics',
        stock: 25,
      ),
      Product(
        id: '',
        name: 'Running Shoes',
        description: 'Lightweight shoes built for comfort and speed.',
        price: 89.99,
        imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        category: 'Fashion',
        stock: 40,
      ),
      Product(
        id: '',
        name: 'Smart Watch',
        description: 'Track fitness, notifications, and sleep in style.',
        price: 199.99,
        imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        category: 'Electronics',
        stock: 15,
      ),
      Product(
        id: '',
        name: 'Leather Backpack',
        description: 'Durable everyday bag with laptop compartment.',
        price: 74.50,
        imageUrl:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        category: 'Accessories',
        stock: 30,
      ),
    ];

    for (final product in samples) {
      await _products.add(product.toMap());
    }
  }
}
