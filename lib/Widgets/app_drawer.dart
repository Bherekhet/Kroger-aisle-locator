import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/grocery_list_screen.dart';
import '../screens/store_location_screen.dart';
import '../screens/product_screen.dart';
import '../providers/store.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String name;
  String address;
  String city;
  String state;
  
  @override
  Widget build(BuildContext context) {
    final value = Provider.of<Stores>(context).test;
    name = value['name'];
    address = value['address'];
    city = value['city'];
    state = value['state'];
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: ListTileTheme(
          style: ListTileStyle.drawer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Aisle Locator',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(name ?? 'Unknown store', style: TextStyle(fontSize: 16),),
                    Text(address ?? 'Unknown location, please choose location', style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.list,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Grocery List',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(GroceryListScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.edit_location,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Store Location',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, StoreLocationScreen.routeName);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.store,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Product Search',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, ProductScreen.routeName);
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.blueAccent,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colors.white,
                        child: Text(
                          'Change Location',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, StoreLocationScreen.routeName);
                        },
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
