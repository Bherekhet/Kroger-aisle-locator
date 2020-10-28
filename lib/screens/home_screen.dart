import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../misc/constants.dart' as Constants;
import './webview_screen.dart';

class HomeScreen extends StatelessWidget {
  _displayInWebView(BuildContext context) {
    var scope = Uri.encodeComponent('product.compact');
    var oauthUrl = DotEnv().env['OAUTH2_BASE_URL'];
    var client = Uri.encodeComponent(DotEnv().env['CLIENT_ID']);
    var rdUrl = DotEnv().env['REDIRECT_URL'];
    var url =
        '$oauthUrl/authorize?scope=$scope&response_type=code&client_id=$client&redirect_uri=$rdUrl';
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => WebViewScreen(url)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.blue, Colors.red]),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Kroger Aisle Locator',
                      textAlign: TextAlign.center,
                      style: Constants.tHomeScreenIntoTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Save your shooping list with aisle locations before going \n to the store.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white30),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(Constants.tStartButtonColor),
                        child: Text(
                          'LETS\'S START',
                          style: TextStyle(letterSpacing: 5.0),
                        ),
                        onPressed: () {
                          _displayInWebView(context);
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
