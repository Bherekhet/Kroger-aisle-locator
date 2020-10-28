import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Auth with ChangeNotifier {
  String _authCode;
  String _accToken;
  String _refreshToken;
  int _tokenExpiresIn;

  String get getAuthCode {
    return _authCode;
  }

  bool get isAuth {
    return _accToken != null;
  }

  Future<String> get getToken async {
    tryAutoLogin();
    return Future.value(_accToken);
  }

  Future<String> setAuthCode(String codeUrl) {
    RegExp regExp = new RegExp('code=(.*)');
    _authCode = regExp.firstMatch(codeUrl)?.group(1);
    return _getToken(_authCode);
  }

  Future<String> _getToken(String code) async {
    final client = DotEnv().env['CLIENT_ID'];
    final clientPass = DotEnv().env['CLIENT_SECRET'];
    final redirect = DotEnv().env['REDIRECT_URL'];
    final encoded = ascii.encode('$client:$clientPass');
    final authorization = 'Basic ${base64.encode(encoded)}';
    final tokenUrl = '${DotEnv().env['OAUTH2_BASE_URL']}/token';

    final body =
        'grant_type=authorization_code&code=${Uri.encodeComponent(code)}&redirect_uri=${Uri.encodeComponent(redirect)}';

    if (code == null || code.length == 0) {
      print('error didn\'t get authentication code');
      return null;
    } else {
      try {
        final tokenResponse = await http.post(tokenUrl,
            headers: {
              'Authorization': authorization,
              'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: body);
        _accToken = jsonDecode(tokenResponse.body)['access_token'];
        _refreshToken = jsonDecode(tokenResponse.body)['refresh_token'];
        _tokenExpiresIn = jsonDecode(tokenResponse.body)['expires_in'];
        // print('expiring time $_tokenExpiresIn');
        final prefs = await SharedPreferences.getInstance();
        final accessData = jsonEncode({
          'accToken': _accToken,
          'refToken': _refreshToken,
          'expiryTime': _tokenExpiresIn.toString()
        });
        prefs.setString('accessData', accessData);
      } catch (error) {
        print('error code token $error');
      }
    }

    notifyListeners();
    return null;
  }

  Future<String> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedAccessData =
        jsonDecode(prefs.getString('accessData')) as Map<String, Object>;
    String refreshToken = extractedAccessData['refToken'];

    final client = DotEnv().env['CLIENT_ID'];
    final clientPass = DotEnv().env['CLIENT_SECRET'];
    final encoded = ascii.encode('$client:$clientPass');
    final authorization = 'Basic ${base64.encode(encoded)}';
    final tokenUrl = '${DotEnv().env['OAUTH2_BASE_URL']}/token';
    final body = 'grant_type=refresh_token&refresh_token=$refreshToken';

    // print('refresh $refreshToken');
    try {
      final refreshTokenResponse = await http.post(
        tokenUrl,
        headers: {
          'Authorization': authorization,
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
     // print(refreshTokenResponse.body);
      if (refreshTokenResponse.statusCode == 200) {
        // print('response from refreshToken $refreshTokenResponse');
        _accToken = jsonDecode(refreshTokenResponse.body)['access_token'];
        _refreshToken = jsonDecode(refreshTokenResponse.body)['refresh_token'];
        _tokenExpiresIn = jsonDecode(refreshTokenResponse.body)['expires_in'];
        final accessData = jsonEncode({
          'accToken': _accToken,
          'refToken': _refreshToken,
          'expiryTime': _tokenExpiresIn.toString()
        });
        prefs.remove('accessData');
        prefs.setString('accessData', accessData);
      }
    } catch (error) {
      print('error from refreshing token $error');
    }
    return Future.value(_accToken);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('accessData')) {
      return false;
    }
    final extractedAccessData =
        json.decode(prefs.getString('accessData')) as Map<String, Object>;

    _accToken = extractedAccessData['accToken'];
    _refreshToken = extractedAccessData['refToken'];
    _tokenExpiresIn = int.parse(extractedAccessData['expiryTime']);
    notifyListeners();
    return true;
  }
}
