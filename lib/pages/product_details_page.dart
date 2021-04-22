import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String ROUTE = "/product-detail-page";
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 250,
            child: Image.network(
              product.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Chip(
                    label: Text(
                      "Price : \$${product.price}",
                    ),
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.description),
            ),
          ),
        ],
      ),
    );
  }
}
