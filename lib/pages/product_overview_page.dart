import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

class ProductOverviewPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: ProductsGrid(),
    );
  }
}

