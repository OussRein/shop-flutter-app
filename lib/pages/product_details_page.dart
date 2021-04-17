import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String ROUTE = "/product-detail-page";
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
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
            Container(
              margin: EdgeInsets.all(10),
              child : Text(product.title, style: Theme.of(context).textTheme.headline6,),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(border: Border.all(color : Colors.black26,)),
              width: double.infinity,
              height: 200,
              child : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(product.description),
                    ),
            ),
          ],
        ),
    );
  }
}