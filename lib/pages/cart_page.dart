import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  static const String ROUTE = "/cart-page";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Chip(
                    label: Text(
                      "\$${cart.total}",
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItemWidget(cart.items.values.toList()[i]),
              itemCount: cart.numberOfItems,
            ),
          ),
        ],
      ),
    );
  }
}
