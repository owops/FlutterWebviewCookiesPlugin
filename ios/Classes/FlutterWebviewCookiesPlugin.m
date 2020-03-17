#import "FlutterWebviewCookiesPlugin.h"

@implementation FlutterWebviewCookiesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_webview_cookies"
            binaryMessenger:[registrar messenger]];
  FlutterWebviewCookiesPlugin* instance = [[FlutterWebviewCookiesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"setCookie" isEqualToString:call.method]) {
    result(true);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
