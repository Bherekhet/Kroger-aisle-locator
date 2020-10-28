import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../misc/constants.dart' as Constants;
import '../providers/grocery_provider.dart';

class Product extends StatelessWidget {
  final String productId;
  final String productName;
  final List productLoc;
  final String productPrice;
  final String productImage;

  Product(
      {this.productId,
      this.productName,
      this.productLoc,
      this.productPrice,
      this.productImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: CircleAvatar(
                child: Image.network(productImage),
                // backgroundImage: NetworkImage(productImage),
                radius: 40,
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productName,
                      style:
                          TextStyle(fontSize: Constants.tProductNameFontSize),
                    ),
                    Text('\$$productPrice',
                        style: TextStyle(
                            fontSize: Constants.tProductPriceFontSize)),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Colors.blueAccent,
                      child: Text(
                        'ADD TO GROCERY LIST',
                        style: TextStyle(
                            color: Color(Constants.tAddToGroceryTextColor)),
                      ),
                      onPressed: () {
                        Provider.of<GroceryProvider>(context).addToGrocery(productId, productName, productPrice, productImage, productLoc);
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Product added to grocery list'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
          indent: 15,
          endIndent: 15,
          thickness: 0.5,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
