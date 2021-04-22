import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewPage extends StatefulWidget {
  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _showfavourites = false;

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions filterOptions) {
              setState(() {
                if (filterOptions == FilterOptions.Favourites) {
                  //productsData.showFavouritesOnly();
                  _showfavourites = true;
                } else {
                  //productsData.showAll();
                  _showfavourites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Afficher tout"),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text("Favourites Only"),
                value: FilterOptions.Favourites,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.numberOfItems.toString(),
            ),
            child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: (){Navigator.of(context).pushNamed(CartPage.ROUTE);},
              ),
              
          ),
        ],
      ),
      body: ProductsGrid(_showfavourites),
    );
  }
}
