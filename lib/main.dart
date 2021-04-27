import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/auth_page.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:shopping_app/pages/edit_product_page.dart';
import 'package:shopping_app/pages/orders_page.dart';
import 'package:shopping_app/pages/product_details_page.dart';
import 'package:shopping_app/pages/product_overview_page.dart';
import 'package:shopping_app/pages/user_products_page.dart';
import 'package:shopping_app/providers/auth.dart';
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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: null,
          update: (ctx,auth, products) => ProductProvider(auth.token,products == null ? [] : products.products),
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: null,
          update: (ctx,auth, cart) => Cart(auth.token,cart == null ? {} : cart.items),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (ctx,auth, orders) => Orders(auth.token,orders == null ? [] : orders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx,auth,_) => MaterialApp(
          title: 'Shopping app',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.orange.shade900,
          ),
          home: auth.isAuth ? ProductOverviewPage() : AuthPage(),
          routes: {
            ProductOverviewPage.ROUTE: (ctx) => ProductOverviewPage(),
            ProductDetailsPage.ROUTE: (ctx) => ProductDetailsPage(),
            CartPage.ROUTE : (ctx) => CartPage(),
            OrdersPage.ROUTE: (ctx) => OrdersPage(),
            UserProductPage.ROUTE: (ctx) => UserProductPage(),
            EditProductPage.ROUTE: (ctx) => EditProductPage(),
          },
        ),
      ),
    );
  }
}
