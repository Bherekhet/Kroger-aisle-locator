import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grocery_provider.dart';
import '../Widgets/grocery_list_aisle_builder.dart';

class GroceryListItem extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String image;
  final List<String> aisles;

  GroceryListItem({this.id, this.name, this.price, this.image, this.aisles});

  _onSwiped(BuildContext context) {
    Provider.of<GroceryProvider>(context).removeGroceryItem(id);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: UniqueKey(),
      background: Container(
          color: Colors.blue[50],
          child: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {},
          ),
          alignment: Alignment.centerLeft),
      confirmDismiss: (_) => _onSwiped(context),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue[100].withOpacity(0.6),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3)),
            ]),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 40,
              backgroundColor: Colors.transparent,
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  Text(
                    '\$$price',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 80,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: aisles.length,
                    itemBuilder: (_, i) {
                      return SizedBox(
                        width: 130,
                        child: GroceryListAilseBuilder(
                          id: id,
                          price: price,
                          aisles: aisles,
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
        //   color: Colors.white,
        //   child: Column(
        //     children: <Widget>[
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Flexible(
        //             child: Container(
        //               padding: EdgeInsets.all(10),
        //               child: Text(
        //                 name,
        //                 style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w400),
        //                 overflow: TextOverflow.clip,
        //               ),
        //             ),
        //           ),
        //           IconButton(
        //             icon: Icon(Icons.delete),
        //             color: Colors.blue,
        //             onPressed: () {
        //               _grocery.removeGroceryItem(id);
        //             },
        //           )
        //         ],
        //       ),
        //       Container(
        //         alignment: Alignment.centerLeft,
        //         height: 140,
        //         padding: EdgeInsets.only(left: 10),
        //         child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             shrinkWrap: true,
        //             itemCount: aisles.length,
        //             itemBuilder: (_, i) {
        //               return SizedBox(
        //                 width: 130,
        //                 child: GroceryListAilseBuilder(
        //                   id: id,
        //                   price: price,
        //                   aisles: aisles,
        //                 ),
        //               );
        //             }),
        //       ),
        //       SizedBox(height: 30,),
        //     ],
        //   ),
      ),
    );
  }
}
