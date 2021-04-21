import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/product_details_page.dart';
import 'package:shopping_app/pages/product_overview_page.dart';
import 'package:shopping_app/providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductProvider(),
      child: MaterialApp(
        title: 'Shopping app',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.orange.shade900,
        ),
        home: ProductOverviewPage(),
        routes: {
          ProductDetailsPage.ROUTE : (ctx) => ProductDetailsPage(),
        },
        
      ),
    );
  }
}
