import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products_provider.dart';

class EditProductPage extends StatefulWidget {
  static const String ROUTE = "/edit-product-page";
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _product = Product(
    id: null,
    description: '',
    imageUrl: '',
    isFavourite: false,
    price: 0.0,
    title: '',
  );

  var _initValues = {
    'description': '',
    'imageUrl': '',
    'price': '',
    'title': '',
  };

  bool _isInit = true;



  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null && productId.isNotEmpty){
        _product = Provider.of<ProductProvider>(context).findById(productId);
        _initValues = {
          'description': _product.description,
          //'imageUrl': _product.imageUrl,
          'price': _product.price.toString(),
          'title': _product.title,
        };
        _imageUrlController.text = _product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    var isValid = _form.currentState.validate();
    if(!isValid) return;
    _form.currentState.save();
    if(_product.id != null) {
      Provider.of<ProductProvider>(context, listen: false).updateProduct(_product);
    }else {
      Provider.of<ProductProvider>(context, listen: false).addProduct(_product);
    }
    Navigator.of(context).pop();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if(value.isEmpty) return 'Please put a title';
                    return null;
                  },
                  onSaved: (value){
                    _product = Product(
                      id: _product.id,
                      description: _product.description,
                      imageUrl: _product.imageUrl,
                      isFavourite: _product.isFavourite,
                      price: _product.price,
                      title: value,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if(value.isEmpty) return 'Please put a price!';
                    if(double.tryParse(value) == null) return 'Please a valid price!';
                    if(double.parse(value) <= 0) return 'The price must be greater then 0!';
                    return null;
                  },
                  onSaved: (value){
                    _product = Product(
                      id: _product.id,
                      description: _product.description,
                      imageUrl: _product.imageUrl,
                      isFavourite: _product.isFavourite,
                      price: double.parse(value),
                      title: _product.title,
                    );
                  },
                  
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value){
                    _product = Product(
                      id: _product.id,
                      description: value,
                      imageUrl: _product.imageUrl,
                      isFavourite: _product.isFavourite,
                      price: _product.price,
                      title: _product.title,
                    );
                  },
                  validator: (value) {
                    if(value.isEmpty) return 'Please put a description!';
                    if(value.length < 10) return 'Description is too short!';
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 100,
                          width: 100,
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Image is empty!")
                              : FittedBox(
                                  child: Image.network(
                                    (_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (value){
                          _product = Product(
                            id: _product.id,
                            description: _product.description,
                            imageUrl: value,
                            isFavourite: _product.isFavourite,
                            price: _product.price,
                            title: _product.title,
                          );
                        },
                        validator: (value) {
                          if(value.isEmpty) return 'Please put an image!';
                          if(!value.startsWith("http")) return 'Enter a valid url!';
                          return null;
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
