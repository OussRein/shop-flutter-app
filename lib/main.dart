import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:shopping_app/pages/edit_product_page.dart';
import 'package:shopping_app/pages/orders_page.dart';
import 'package:shopping_app/pages/product_details_page.dart';
import 'package:shopping_app/pages/product_overview_page.dart';
import 'package:shopping_app/pages/user_products_page.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders()
        ),
      ],
      child: MaterialApp(
        title: 'Shopping app',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.orange.shade900,
        ),
        home: ProductOverviewPage(),
        routes: {
          ProductDetailsPage.ROUTE: (ctx) => ProductDetailsPage(),
          CartPage.ROUTE : (ctx) => CartPage(),
          OrdersPage.ROUTE: (ctx) => OrdersPage(),
          UserProductPage.ROUTE: (ctx) => UserProductPage(),
          EditProductPage.ROUTE: (ctx) => EditProductPage(),
        },
      ),
    );
  }
}
