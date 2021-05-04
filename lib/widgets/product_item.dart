import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/pages/product_details_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsPage.ROUTE,
          arguments: product.id,
        );
      },
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavouriteStatus(auth.token, auth.userId);
              },
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added item to cart!",
                  ),
                  duration: Duration(
                    seconds: 2,
                  ),
                  action: SnackBarAction(label: "Undo the action", onPressed: () => cart.removeLastAddedItem(product.id)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
