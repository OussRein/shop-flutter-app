import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/orders_page.dart';
import 'package:shopping_app/pages/user_products_page.dart';
import 'package:shopping_app/providers/auth.dart';

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
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();},
          ),
        ],
      ),
    );
  }
}
