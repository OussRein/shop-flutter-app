import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/app_drawer.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersPage extends StatelessWidget {

  static const String ROUTE = "/orders-page";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
