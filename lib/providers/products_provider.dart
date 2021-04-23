import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';

class ProductProvider with ChangeNotifier{
  List<Product> _products = [
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

  void addProduct(Product product){
    var newProduct = Product(
                      id: DateTime.now().toString(),
                      description: product.description,
                      imageUrl: product.imageUrl,
                      isFavourite: false,
                      price: product.price,
                      title: product.title,
                    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product product){
    final index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    notifyListeners();
  }

  void deleteProduct(String id){
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }


  Product findById(String id){
    return _products.firstWhere((element) => element.id == id);
  }
}