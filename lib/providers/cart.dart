import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/product.dart';

class CartItem {
  final String id;
  final Product product;
  final double price;
  final double quantity;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.product,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (cartItem) => CartItem(
              id: cartItem.id,
              price: cartItem.price,
              product: product,
              quantity: cartItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: DateTime.now().toString(),
              price: product.price,
              product: product,
              quantity: 1));
    }
    notifyListeners();
  }

  double get total {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  int get numberOfItems {
    return _items.length;
  }

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }
}
