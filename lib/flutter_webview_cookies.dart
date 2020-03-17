import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWebviewCookies {
  static const MethodChannel _channel =
      const MethodChannel('flutter_webview_cookies');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }


}
