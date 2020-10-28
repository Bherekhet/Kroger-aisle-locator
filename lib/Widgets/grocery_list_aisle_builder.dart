import 'package:flutter/material.dart';

class GroceryListAilseBuilder extends StatelessWidget {
  final String id;
  final String price;
  final List<String> aisles;

  GroceryListAilseBuilder({this.id, this.price, this.aisles});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
              child: CircleAvatar(
                child: Text('A'),
              )),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(aisles[0]),
          ),
        ],
      ),
    );
  }
}
