import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grocery_provider.dart';
import '../Widgets/display_error.dart';

class GroceryListButtons extends StatelessWidget {
  final GroceryProvider gList;
  GroceryListButtons({this.gList});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            child: FlatButton(
              color: Colors.blueAccent,
              child: Text(
                'Save',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () {
                showErrorDialog('Feature not yet Implemented.', 'Coming soon ...', context);
              },
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Your List',
                    style: TextStyle(fontSize: 20),
                  )),
              Chip(
                label: Text('${gList.items.length}'),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: FlatButton(
              color: Colors.blueAccent,
              child: Text(
                'Clear All',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () {
                Provider.of<GroceryProvider>(context, listen: false).clearAllItems();
              },
            ),
          ),
        ],
      ),
    );
  }
}
