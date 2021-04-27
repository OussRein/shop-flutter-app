import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  CartItem.fromJson(Map<String, dynamic> json)
      : product = json['product'],
        id = json['id'],
        quantity = json['quantity'],
        price = json['price'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product,
        'price': price,
        'quantity': quantity,
      };
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};


  final String _authToken;

  Cart(this._authToken, this._items);
  Map<String, CartItem> get items {
    return _items;
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

  void addItem(Product product) async {
    try {
      var params = {
      'auth': _authToken,
      };
      if (_items.containsKey(product.id)) {
        final url = Uri.https(
            'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
            '/cart'
                '/${product.id}.json',params);

        await http.patch(
          url,
          body: json.encode({
            'product': product,
            'price': product.price,
            'quantity': _items[product.id].quantity + 1.0,
          }),
          headers: {HttpHeaders.authorizationHeader: _authToken},
        );

        _items.update(
            product.id,
            (cartItem) => CartItem(
                id: cartItem.id,
                price: cartItem.price,
                product: product,
                quantity: cartItem.quantity + 1));
      } else {
        final url = Uri.https(
            'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
            '/cart.json',params);
        var response = await http.post(url,
            body: json.encode({
              'product': product,
              'price': product.price,
              'quantity': 1.0,
            }));

        _items.putIfAbsent(
            product.id,
            () => CartItem(
                id: json.decode(response.body)['name'],
                price: product.price,
                product: product,
                quantity: 1.0));
      }
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  void removeItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    var params = {
      'auth': _authToken,
      };
    final url = Uri.https(
        'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
        '/cart/$id.json', params);

    final cart = _items[id];

    try {
      _items.remove(id);
      notifyListeners();

      http.delete(url);
    } catch (error) {
      print(error);
      _items.putIfAbsent(id, () => cart);
      notifyListeners();
      return error;
    }
  }

  void removeLastAddedItem(String id) async {
    if (!_items.containsKey(id)) {
      return;
    }
    
    if (_items[id].quantity > 1) {
      var params = {
      'auth': _authToken,
      };
      final url = Uri.https(
          'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
          '/cart/$id.json', params);

      final cart = _items[id];

      await http.patch(url,
          body: json.encode({
            'product': cart.product,
            'price': cart.price,
            'quantity': cart.quantity - 1.0,
          }));

      _items.update(
          id,
          (cartItem) => CartItem(
              id: cartItem.id,
              price: cartItem.price,
              product: cartItem.product,
              quantity: cartItem.quantity - 1));
    } else {
      removeItem(id);
    }
    notifyListeners();
  }

  void clear() {
    var cart = _items;
    try {
      var params = {
      'auth': _authToken,
      };
      _items.forEach((key, value) {
        var url = Uri.https(
            'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
            '/cart'
                '/${value.id}.json', params);
        http.delete(url);
      });
      _items = {};
      notifyListeners();
    } catch (error) {
      _items = cart;
      notifyListeners();
      return error;
    }
  }

  Future<void> fetchCart() async {
    try {
      var params = {
      'auth': _authToken,
      };

      final url = Uri.https(
          'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
          '/cart.json',
          {
      'auth': _authToken,
      }
          );
      var response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      print('This is the cart $data');
      Map<String, CartItem> cart = {};
      if (data != null) {
        data.forEach((key, prod) {
          cart.putIfAbsent(
              key,
              () => CartItem(
                    id: key,
                    price: prod['price'],
                    product: Product.fromJson(prod['product']),
                    quantity: double.parse('${prod['quantity']}'),
                  ));
        });
      }

      _items = cart;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      return error;
    }
  }
}
