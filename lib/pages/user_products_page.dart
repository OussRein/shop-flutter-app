import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/edit_product_page.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductPage extends StatelessWidget {
  static const String ROUTE = "/user-products-page";

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products!"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {Navigator.of(context).pushNamed(EditProductPage.ROUTE);},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false).fetchProducts(true),
        builder:  (ctx, future) => RefreshIndicator(
          onRefresh: () { return Provider.of<ProductProvider>(context, listen: false).fetchProducts(true);},
            child: Consumer<ProductProvider>(
            builder: (ctx, data, _ ) => Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                        products.products[i].id, products.products[i].title, products.products[i].imageUrl),
                    Divider(),
                  ],
                ),
                itemCount: products.products.length,
              ),
          ),
            ),
        ),
      ),
    );
  }
}
