import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem _cartItem;

  CartItemWidget(this._cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?!"),
            content: Text("You are removing the item from the cart!"),
            actions: [
              TextButton(onPressed: (){Navigator.of(ctx).pop(true);}, child: Text("Yes")),
              TextButton(onPressed: (){Navigator.of(ctx).pop(false);}, child: Text("No")),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(_cartItem.product.id);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: FittedBox(child: Text("\$${_cartItem.price}")),
              ),
            ),
            title: Text(_cartItem.product.title),
            subtitle: Text("Total : \$${_cartItem.price * _cartItem.quantity}"),
            trailing: Text("${_cartItem.quantity}"),
          ),
        ),
      ),
    );
  }
}
