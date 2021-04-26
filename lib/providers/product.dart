import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({this.id, this.title, this.description, this.price, this.imageUrl, this.isFavourite = false});

  void toggleFavouriteStatus(){
    final url = Uri.https(
          'shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app',
          '/products'
          '/${this.id}.json');

    try {
      http.patch(url,
          body: json.encode({
            'isFavourite': !isFavourite,
          }));
      notifyListeners();

    } catch (error) {
      print(error.toString());
      return error;
    }
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        isFavourite = json['isFavourite'],
        price = json['price'];

  Map<String, dynamic> toJson() => {
        'id' : id,
        'title': title,
        'price': price,
        'description' : description,
        'isFavourite': isFavourite,
        'imageUrl' : imageUrl,
      };
}