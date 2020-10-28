import 'package:flutter/foundation.dart';

import '../models/grocery_model.dart';

class GroceryProvider with ChangeNotifier {
  Map<String, GroceryModel> _items = {};

  Map<String, GroceryModel> get items {
    return {..._items};
  }

  void loadGroceryList() async {
    // final pref = await SharedPreferences.getInstance();
    // if (pref.containsKey('groceryList')) {
    //   final data =
    //       json.decode(pref.getString('groceryList')) as Map<String, Object>;
    //   print('fetching $data');
    //   _items = data['groceryList'];
    // }
  }

  void addToGrocery(String id, String name, String price, String image, List aisles) async {
    try {
      _items.putIfAbsent(
        id,
        () => GroceryModel(
            productId: id,
            productName: name,
            productPrice: price,
            productImage: image,
            productAisleLocations: _identifyAisles(aisles)),
      );

      //final pref = await SharedPreferences.getInstance();
      //print('checking prefs ${pref.getKeys()}');
      //final data = jsonEncode(_items);

      //pref.remove('groceryList');
      //pref.setString('groceryList', data);
      //print('checking prefs ${pref.getKeys()}');
    } catch (error) {
      print('this is from adding to grocery list $error');
    }
    _items.forEach((key, value) {
      print(value.productName);
    });
    //notifyListeners();
  }

  List<String> _identifyAisles(List aisles) {
    List<String> als = [];
    aisles.forEach((element) => als.add(element['description']));
    return als;
  }

  void clearAllItems() {
    _items.clear();
    notifyListeners();
  }

  void removeGroceryItem(String id) {
    try {
      _items.remove(id);
    } catch (error) {
      print('this is from deleting grocery item $error');
    }
    notifyListeners();
  }
}
