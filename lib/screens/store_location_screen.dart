import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/store.dart';
import '../Widgets/display_error.dart';
import '../providers/auth.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/store_location_map.dart';

class StoreLocationScreen extends StatefulWidget {
  static const routeName = '/storeLoc';

  @override
  _StoreLocationScreenState createState() => _StoreLocationScreenState();
}

class _StoreLocationScreenState extends State<StoreLocationScreen> {
  final TextEditingController _searchTextController = TextEditingController();

  _fetchStoreLocations() async {
    if (_validateSearchTerm()) {
      final accToken = await Provider.of<Auth>(context).getToken;
      Provider.of<Stores>(context)
          .fetchNearByStores(_searchTextController.text.trim(), accToken);
    } else {
      showErrorDialog('Zipcode should be 5 digit long', 'Incorrect zipcode type', context);
    }
  }

  bool _validateSearchTerm() {
    final zip = _searchTextController.text.trim();
    if (zip == null || zip.length != 5 || _isNotNumberic(zip)) {
      return false;
    }
    return true;
  }

  bool _isNotNumberic(String zip) {
    double value = double.parse(zip);
    if (value == null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final storeLocations = Provider.of<Stores>(context, listen: false).stores;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Store'),
        ),
        body: Stack(
          children: <Widget>[
            storeLocations.isNotEmpty
                ? StoreLocationMap(stores: storeLocations)
                : StoreLocationMap(
                    stores: null,
                  ),
            Positioned(
              top: 50,
              left: 50,
              right: 50,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _searchTextController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: 'ZipCode'),
                  onSubmitted: (_) {
                    _fetchStoreLocations();
                  },
                ),
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}
