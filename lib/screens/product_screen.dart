import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/product.dart';
import '../Widgets/app_drawer.dart';
import '../providers/products.dart';
import '../providers/store.dart';
import '../Widgets/display_error.dart';
import '../screens/grocery_list_screen.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _storeId;
  List<ProductItem> _products = [];
  bool _isLoading = true;
  bool initRun = false;

  @override
  void initState() {
    _fetchStoreId();
    super.initState();
  }

  _fetchStoreId() async {
    await Provider.of<Stores>(context, listen: false).getSavedStoreLocation();
    _storeId = Provider.of<Stores>(context, listen: false).storeId;
    if (_storeId != null) {
      _fetchProducts(_storeId, 'flower');
      setState(() {
        initRun = false;
      });
    }else {
      setState(() {
        initRun = true;
      });
    }
    
  }

  _fetchProducts(String id, String term) {
    Provider.of<Products>(context, listen: false).getProducts(term, id);
  }

  _onSubmit() {
    setState(() {
      _isLoading = true;
      _products.clear();
    });
    if (_formKey.currentState.validate()) {
      if (_storeId == null) {
        showErrorDialog('Please select a location first',
            'Incorrect zipcode type', context);
      } else {
        _fetchProducts(_storeId, _textController.text.trim().toString());
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedProducts = Provider.of<Products>(context, listen: true).products;
    _products = savedProducts;
    if (_products.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Search'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.pushNamed(context, GroceryListScreen.routeName);
              },
            )
          ],
        ),
        body: initRun ? Center(child: Text('Select a store first')): Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Search a product',
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onEditingComplete: () => _onSubmit(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: _products.length,
                            itemBuilder: (_, i) {
                              return Product(
                                productId: _products[i].id,
                                productName: _products[i].name,
                                productLoc: _products[i].aisle,
                                productImage: _products[i].image,
                                productPrice: _products[i].price,
                              );
                            }),
                      ),
              ],
            )),
        drawer: AppDrawer(),
      ),
    );
  }
}
