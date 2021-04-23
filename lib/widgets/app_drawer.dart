import 'package:flutter/material.dart';
import 'package:shopping_app/pages/orders_page.dart';
import 'package:shopping_app/pages/user_products_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("My Store"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: (){Navigator.of(context).pushReplacementNamed('/');},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: (){Navigator.of(context).pushReplacementNamed(OrdersPage.ROUTE);},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.store_mall_directory),
            title: Text("My Products"),
            onTap: (){Navigator.of(context).pushReplacementNamed(UserProductPage.ROUTE);},
          ),
        ],
      ),
    );
  }
}
