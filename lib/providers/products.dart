import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth.dart';

class ProductItem {
  final String id;
  final String name;
  final List aisle;
  final String price;
  final String image;

  ProductItem({this.id, this.name, this.aisle, this.price, this.image});
}

class Products with ChangeNotifier {
  String storeId;

  List<ProductItem> _products = [];
  Map<String, ProductItem> _groceryList = {};

  List<ProductItem> get products {
    return [..._products];
  }

  Map<String, ProductItem> get groceryList {
    return {..._groceryList};
  }

  Future<void> getProducts(String term, String loc) async {

    //was getting certificate handshake problem so i tried ioClient instead of http
    //didn't fix
    // bool trustSelfSigned = true;
    // HttpClient httpClient = new HttpClient()
    //   ..badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => trustSelfSigned);
    // IOClient ioClient = new IOClient(httpClient);

    _products = [];
    final prefs = await SharedPreferences.getInstance();
    final extractedPrefs =
        jsonDecode(prefs.getString('accessData')) as Map<String, Object>;
    final apiBase = DotEnv().env['API_BASE_URL'];
    final proUrl =
        '$apiBase/v1/products?filter.term=$term&filter.locationId=$loc';
    final accToken = extractedPrefs['accToken'];

    try {
      final productResponse = await http.get(proUrl, headers: {
        'Authorization': 'Bearer $accToken',
        'Cache-Control': 'no-cache'
      });
      final extractedProductResponse =
          json.decode(productResponse.body)['data'];

      if (extractedProductResponse != null) {
        extractedProductResponse.forEach((item) {
          if (item != null) {
            _products.add(ProductItem(
              id: item['productId'],
              aisle: item['aisleLocations'],
              name: item['description'],
              price: item['items'][0]['price'] != null
                  ? '${item['items'][0]['price']['regular']}'
                  : 'unknown',
              image: item['images'][0]['sizes'][0]['url'],
            ));
          }
        });
      }
      if (productResponse.statusCode == 401) {
        print('Token has expired');
        Auth().refreshAccessToken();
        Future.delayed(const Duration(seconds: 3));
        getProducts(term, loc);
        return;
      }
    } catch (error) {
      print('error from fetching products$error');
    }
    notifyListeners();
  }
}
