
import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  String _authToken;
  String _userId;

  ProductProvider(this._authToken, this._userId, this._products);

  /*= [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
*/

  List<Product> get products {
    //if(_showfavourites) return _products.where((element) => element.isFavourite).toList();
    return [..._products];
  }

  List<Product> get favouriteProducts {
    return _products.where((element) => element.isFavourite).toList();
  }

  /*void showFavouritesOnly(){
    _showfavourites = true;
    notifyListeners();
  }

  void showAll(){
    _showfavourites = false;
    notifyListeners();
  }*/

  Future<void> fetchProducts([bool filterByUser = false]) async {
    try {
      String filterString = filterByUser ? 'orderBy="creatorId"equalTo="$_userId"' : '';
      final url = Uri.parse('https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken&$filterString');
      var response = await http.get(url);
      final data = json.decode(response.body);
      List<Product> products = [];
      if (data == null) return;
      final urlOfFavorites = Uri.parse('https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$_userId.json?auth=$_authToken');
          var responseFav = await http.get(urlOfFavorites);
          final favoriteData = json.decode(responseFav.body);
      data.forEach((productId, productData) {
        products.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
          isFavourite: favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _products = products;
      notifyListeners();
    } catch (error) {
      return error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {

      final url = Uri.parse('https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_authToken');
      var response = await http.post(url,
          body: json.encode({
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'title': product.title,
            'creatorId': _userId,
          }));

      var newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        isFavourite: false,
        price: product.price,
        title: product.title,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  Future<void> updateProduct(Product product) async{

    final url = Uri.parse('https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products/${product.id}.json?auth=$_authToken');

    try {
      await http.patch(url,
          body: json.encode({
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'title': product.title,
            'creatorId': _userId,
          }));
      final index = _products.indexWhere((element) => element.id == product.id);
      _products[index] = product;
      notifyListeners();

    } catch (error) {
      print(error.toString());
      return error;
    }
    
  }

  void deleteProduct(String id) {

    final url = Uri.parse('https://shopapp-b51c4-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$_authToken');

    final index = _products.indexWhere((element) => element.id == id);
    var product = _products[index];

    try {
      _products.removeWhere((element) => element.id == id);
      notifyListeners();

      http.delete(url);

    } catch (error) {
      products.insert(index, product);
      notifyListeners();
      return error;
    }
    
    
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }
}
