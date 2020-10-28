import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/grocery_list_item.dart';
import '../providers/grocery_provider.dart';
import '../providers/store.dart';
import '../Widgets/grocery_list_buttons.dart';
import '../Widgets/display_error.dart';

class GroceryListScreen extends StatefulWidget {
  static const routeName = '/groceryList';

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  @override
  void initState() {
    getStoreInfo();
    super.initState();
  }

  getStoreInfo() async {
    await Provider.of<Stores>(context, listen: false).getStore();
  }

  @override
  Widget build(BuildContext context) {
    final _grocery = Provider.of<GroceryProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Grocery List'),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Choose Date'),
                    IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      color: Colors.blueAccent,
                      onPressed: () {
                        showErrorDialog('Feature not yet Implemented.',
                            'Coming soon ...', context);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .2,
                width: double.infinity,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/shopping.jpg'),
                  image: AssetImage('assets/images/shopping.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              GroceryListButtons(
                gList: _grocery,
              ),
              _grocery.items.isNotEmpty
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _grocery.items.length,
                      itemBuilder: (_, i) {
                        return Column(
                          children: <Widget>[
                            GroceryListItem(
                              id: _grocery.items.values.toList()[i].productId,
                              name:
                                  _grocery.items.values.toList()[i].productName,
                              price: _grocery.items.values
                                  .toList()[i]
                                  .productPrice,
                              image: _grocery.items.values
                                  .toList()[i]
                                  .productImage,
                              aisles: _grocery.items.values
                                  .toList()[i]
                                  .productAisleLocations,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      })
                  : Center(
                      child: Text(
                        'You don\'t have any items in grocery list',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
            ],
          ),
        ),
        drawer: AppDrawer(),
      ),
    );
  }
}
