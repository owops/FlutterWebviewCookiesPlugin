import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterWebviewCookies {
  static const MethodChannel _channel =
      const MethodChannel('flutter_webview_cookies');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<Cookie>> getCookies() async {
    final List<Cookie> cookies = await _channel.invokeMethod('getCookies');
    return cookies;
  }

  static Future<bool> setCookie(Map<String, dynamic> cookie) async {
    final bool result = await _channel.invokeMethod('setCookie', cookie);
    return result;
  }
}
