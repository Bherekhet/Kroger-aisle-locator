import 'dart:async';
import 'package:aisle_locator/screens/store_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class WebViewScreen extends StatefulWidget {
  final url;
  WebViewScreen(this.url);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final _key = UniqueKey();
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  var _init = false;

  StreamSubscription<String> _onUrlChanged;
  @override
  void initState() {
    super.initState();

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted && url.startsWith(DotEnv().env['REDIRECT_URL']) && !_init) {

        setState(() { 
          _init = true;
        });

        Provider.of<Auth>(context, listen: false).setAuthCode(url).then((value) {
          final authToken = Provider.of<Auth>(context).getToken;

          if(authToken != null) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => StoreLocationScreen()));
          } else {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _key,
      url: widget.url,
      withJavascript: true,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        title: const Text('WebView'),
      ),
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
    );
  }
}
