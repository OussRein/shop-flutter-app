import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: min(widget.order.products.length * 50.0 + 50, 180),
              child: ListView.builder(
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: ListTile(
                    leading: Icon(Icons.shopping_basket),
                    title: Text(
                      widget.order.products[i].product.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      '\$${widget.order.products[i].price}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),   
                    ),
                  ),
                ),
                itemCount: widget.order.products.length,
              ),
            ),
        ],
      ),
    );
  }
}
