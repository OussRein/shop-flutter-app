import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavouriteStatus(String token, String userId) async {

    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse(
        'https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/${this.id}.json?auth=$token');
    

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if( response.statusCode  >= 400) print('FFFF');
      notifyListeners();
    } catch (error) {
      isFavourite = !isFavourite;
      notifyListeners();
      print(error.toString());
      return error;
    }
    
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        isFavourite = json['isFavourite'],
        price = json['price'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'isFavourite': isFavourite,
        'imageUrl': imageUrl,
      };
}
