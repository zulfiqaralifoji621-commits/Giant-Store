import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> data, Product product) {
    return CartItem(
      product: product,
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
