
import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopping_app/providers/product.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});

  OrderItem.fromJson(Map<String, dynamic> json)
      : products = json['products'],
        id = json['id'],
        amount = json['amount'],
        dateTime = DateTime.parse(json['dateTime']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'products': products,
        'amount': amount,
        'dateTime': dateTime.toIso8601String(),
      };
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String _authToken;
  String _userId;

  Orders(this._authToken, this._userId, this._orders);

  void addOrder(List<CartItem> cartItems, double total) async {
    try {
      
      final url = Uri.parse(
          'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/orders/$_userId.json?auth=$_authToken');

      DateTime dt = DateTime.now();
      var response = await http.post(url,
          body: json.encode({
            'products': cartItems
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'product': cp.product,
                    })
                .toList(),
            'amount': total,
            'dateTime': dt.toIso8601String(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartItems,
          dateTime: dt,
        ),
      );
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> fetchOrders() async {
    try {
      final url = Uri.parse(
          'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/orders/$_userId.json?auth=$_authToken');
      var response = await http.get(url);
      final data = json.decode(response.body);

      List<OrderItem> orders = [];

    if (data != null) {
      data.forEach((key, prod) {
        orders.add(OrderItem(
          id: key,
          amount: prod['amount'],
          products: (prod['products'] as List<dynamic>).map((cartItem) => CartItem(
                id: cartItem['id'],
                price: cartItem['price'],
                product: Product.fromJson(cartItem['product']),
                quantity: cartItem['quantity'],
              )).toList(),
          dateTime: DateTime.parse(prod['dateTime']),
        ));
      });
    }

    _orders= orders;
    notifyListeners();
    } catch (error) {
      return error;
    }
  }
}
