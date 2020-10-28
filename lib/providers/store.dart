import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../misc/constants.dart' as constants;
import '../providers/auth.dart';
import '../models/store_info.dart';

class Stores with ChangeNotifier {
  List<StoreInfo> _stores = [];
  Map<String, String> _selectedStore = {};
  String _storeId;
  final String selectedStoreCode;

  Stores({this.selectedStoreCode});

  String get storeId {
    return _storeId;
  }

  Map<String, String> get test {
    return {..._selectedStore};
  }

  List<StoreInfo> get stores {
    return [..._stores];
  }

  Future<void> fetchNearByStores(String zip, String token) async {
    final apiBase = DotEnv().env['API_BASE_URL'];
    final locUrl =
        '$apiBase/v1/locations?filter.zipCode.near=$zip&filter.limit=20';
    try {
      final locationResponse = await http.get(
        locUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Cache-Control': 'no-cache',
        },
      );
      _stores.clear();
      if (locationResponse.statusCode == 401) {
        print('Token has expired');
        token = await Auth().refreshAccessToken();
        Future.delayed(const Duration(seconds: 3));
        fetchNearByStores(zip, token);
        return;
      }

      if (locationResponse.statusCode == 200) {
        final extractedResponse = jsonDecode(locationResponse.body)['data'];
        extractedResponse.forEach((storeLoc) {
          if (containsChain(storeLoc['chain'])) {
            _stores.add(StoreInfo(
              id: storeLoc['locationId'],
              latitude: storeLoc['geolocation']['latitude'],
              longtide: storeLoc['geolocation']['longitude'],
              name: (storeLoc['name']),
              addressLine: storeLoc['address']['addressLine1'],
              city: storeLoc['address']['city'],
              state: storeLoc['address']['state'],
              zipCode: storeLoc['address']['zipCode'],
              country: storeLoc['address']['county'],
            ));
          }
        });
      }
    } catch (error) {
      print('error from fetch loc $error');
    }
    notifyListeners();
  }

  Future<void> setSelectedStore(String id, String name, String address, String city, String state) async {

    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey('store')) {
      print('found store');
      pref.remove('store');
    }
    
    final storeData = jsonEncode({
      'name': name,
      'address': address,
      'city': city,
      'state': state,
    });

    pref.setString('store', storeData);
    pref.setString('storeId', id);
  }

  Future<void> getStore() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('store')) {
      return Future.value(null);
    }
    final extractedData =
        jsonDecode(pref.getString('store')) as Map<String, Object>;
    _selectedStore = {};
    _selectedStore.addAll({
      'name': extractedData['name'],
      'address': extractedData['address'],
      'city': extractedData['city'],
      'state': extractedData['state'],
    });
  }

  Future<void> getSavedStoreLocation() async {
    final pref = await SharedPreferences.getInstance();
    final extractedData = pref.getString('storeId');
    _storeId = extractedData;
  }

  bool containsChain(String chain) {
    final List<String> chainList = constants.chains;
    return chainList.contains(chain);
  }
}
