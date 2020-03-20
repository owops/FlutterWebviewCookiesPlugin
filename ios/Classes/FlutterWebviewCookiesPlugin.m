#import "FlutterWebviewCookiesPlugin.h"
#import <WebKit/WebKit.h>

@implementation FlutterWebviewCookiesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_webview_cookies"
            binaryMessenger:[registrar messenger]];
  FlutterWebviewCookiesPlugin* instance = [[FlutterWebviewCookiesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (NSHTTPCookie *)createCookieWithName:(NSString *)name value:(NSString *)value url:(NSString *)url path:(NSString *)path httpOnly:(BOOL)httpOnly {
    if(path == nil || path.length == 0) {
        path = @"/";
    }
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:url forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:path forKey:NSHTTPCookiePath];

    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties: cookieProperties];
    return cookie;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"setCookie" isEqualToString:call.method]) {
      NSDictionary *cookieDictionary = call.arguments;
      if(cookieDictionary) {
          NSArray *headeringCookie = [NSHTTPCookie
                                      cookiesWithResponseHeaderFields:@{
                                          @"Set-Cookie":[cookieDictionary objectForKey:@"src-cookie"],
                                      }
                                      forURL:[NSURL URLWithString:[cookieDictionary objectForKey:@"src-url"]]];
          NSLog(@"%@", headeringCookie);
          NSHTTPCookie *cookie = headeringCookie[0];
          if (@available(iOS 11.0, *)) {
              WKHTTPCookieStore *store = [[WKWebsiteDataStore defaultDataStore] httpCookieStore];
              [store setCookie:cookie completionHandler:nil];
              [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
              [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
          } else {
              // Fallback on earlier versions
          }
          result(@YES);
      } else {
          result(@NO);
      }
  } else if ([@"getCookies" isEqualToString:call.method]) {
      NSString *cookieUrl = call.arguments;
      NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:cookieUrl]];
      result(cookies);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end

