import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './screens/store_location_screen.dart';
import './screens/product_screen.dart';
import './screens/grocery_list_screen.dart';
import './providers/products.dart';
import './screens/home_screen.dart';
import './providers/auth.dart';
import './providers/store.dart';
import './providers/grocery_provider.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Stores(),
        ),
        ChangeNotifierProvider.value(
          value: GroceryProvider(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Locate Products',
          home: auth.isAuth
              ? GroceryListScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : HomeScreen(),
                ),
          routes: {
            StoreLocationScreen.routeName: (ctx) => StoreLocationScreen(),
            ProductScreen.routeName: (ctx) => ProductScreen(),
            GroceryListScreen.routeName: (ctx) => GroceryListScreen(),
          },
        ),
      ),
    );
  }
}
