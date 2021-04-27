import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverviewPage extends StatefulWidget {

  static const String ROUTE = '/product-overview-page';

  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _showfavourites = false;
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts()
        .then((value) {
          
            setState(() {
              _isLoading = false;
            });
    });
    Provider.of<Cart>(context, listen: false)
                .fetchCart();
    super.initState();
  }

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
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.ROUTE);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Provider.of<ProductProvider>(context, listen: false)
                    .fetchProducts();
              },
              child: ProductsGrid(_showfavourites)),
    );
  }
}
