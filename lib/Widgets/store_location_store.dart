import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/store.dart';
import '../Widgets/display_error.dart';

class StoreLocationStore extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;

  StoreLocationStore({this.id, this.name, this.address, this.city, this.state});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Color(0xff2699FB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[50].withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Wrap(
            spacing: 5.0,
            runSpacing: 5.0,
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.56,
                child: Text(
                  name,
                  style: TextStyle(fontSize: 14, color: Color(0xffFFFFFF)),
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(address,
                  style: TextStyle(fontSize: 10, color: Color(0xffFFFFFF))),
              Text('$city, $state',
                  style: TextStyle(fontSize: 10, color: Color(0xffFFFFFF))),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Provider.of<Stores>(context)
                    .setSelectedStore(id, name, address, city, state);
                Provider.of<Stores>(context, listen: false).getStore();
                showConfirmation('You have successfully selected a store.', context);
              },
              color: Color(0xff2699FB),
            ),
          ),
        ],
      ),
    );
  }
}
