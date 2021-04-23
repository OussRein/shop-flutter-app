import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/edit_product_page.dart';
import 'package:shopping_app/providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String _title;
  final String _imageUrl;

  UserProductItem(this.id, this._title, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_imageUrl),
      ),
      title: Text(_title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductPage.ROUTE, arguments: id);
              },
              color: Theme.of(context).primaryColorLight,
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
                },
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
