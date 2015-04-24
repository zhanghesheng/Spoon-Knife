#import "WebViewJavascriptBridge.h"

#import "TBCore/NSDictionaryAdditions.h"
#import "TBCore/NSString+Addition.h"

@interface WebViewJavascriptBridge ()  {
    NSMutableArray *_startupMessageQueue;
    NSMutableDictionary *_responseCallbacks;
    NSMutableDictionary *_messageHandlers;
    NSInteger _uniqueId;
    UIWebView *_webView;
    __weak id <UIWebViewDelegate> _webViewDelegate;
    WVJBHandler _messageHandler;
}

@property(nonatomic, strong) NSMutableArray *startupMessageQueue;
@property(nonatomic, strong) NSMutableDictionary *responseCallbacks;
@property(nonatomic, strong) NSMutableDictionary *messageHandlers;
@property(atomic, assign) NSInteger uniqueId;
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, weak) id <UIWebViewDelegate> webViewDelegate;
@property(nonatomic, copy) WVJBHandler messageHandler;

- (void)_flushMessageQueue;

- (void)_sendData:(NSDictionary *)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString *)handlerName;

- (void)_queueMessage:(NSDictionary *)message;

- (void)_dispatchMessage:(NSDictionary *)message;

- (NSString *)_serializeMessage:(NSDictionary *)message;

- (NSDictionary *)_deserializeMessageJSON:(NSString *)messageJSON;

- (void)_log:(NSString *)type json:(NSString *)output;

@end

@implementation WebViewJavascriptBridge

static NSString *MESSAGE_SEPARATOR = @"__WVJB_MESSAGE_SEPERATOR__";
static NSString *CUSTOM_PROTOCOL_SCHEME = @"wvjbscheme";
static NSString *QUEUE_HAS_MESSAGE = @"__WVJB_QUEUE_MESSAGE__";

@synthesize startupMessageQueue = _startupMessageQueue;
@synthesize responseCallbacks = _responseCallbacks;
@synthesize messageHandlers = _messageHandlers;
@synthesize uniqueId = _uniqueId;
@synthesize webView = _webView;
@synthesize webViewDelegate = _webViewDelegate;
@synthesize messageHandler = _messageHandler;

- (void)dealloc {

   
}

+ (id)bridgeForWebView:(UIWebView *)webView handler:(WVJBHandler)handler {
    return [self bridgeForWebView:webView webViewDelegate:nil handler:handler];
}

+ (id)bridgeForWebView:(UIWebView *)webView webViewDelegate:(id <UIWebViewDelegate>)webViewDelegate handler:(WVJBHandler)messageHandler {
    WebViewJavascriptBridge *bridge = [[WebViewJavascriptBridge alloc] init];
    bridge.messageHandler = messageHandler;
    bridge.webView = webView;
    bridge.webViewDelegate = webViewDelegate;
    bridge.messageHandlers = [NSMutableDictionary dictionary];
    [bridge reset];
    webView.delegate = bridge;
    return bridge;
}

static bool logging = false;

+ (void)enableLogging {
    logging = true;
}

- (void)send:(NSDictionary *)data {
    [self send:data responseCallback:nil];
}

- (void)send:(NSDictionary *)data responseCallback:(WVJBResponseCallback)responseCallback {
    [self _sendData:data responseCallback:responseCallback handlerName:nil];
}

- (void)callHandler:(NSString *)handlerName {
    [self callHandler:handlerName data:nil responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data {
    [self callHandler:handlerName data:data responseCallback:nil];
}

- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    [self _sendData:data responseCallback:responseCallback handlerName:handlerName];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
    self.messageHandlers[handlerName] = handler;
}

- (void)reset {
    self.startupMessageQueue = [NSMutableArray array];
    self.responseCallbacks = [NSMutableDictionary dictionary];
    self.uniqueId = 0;
}

- (void)_sendData:(NSDictionary *)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString *)handlerName {
    NSMutableDictionary *message = [NSMutableDictionary dictionaryWithObject:data forKey:@"data"];

    if (responseCallback) {
        int uid = (int)_uniqueId;
        NSString *callbackId = [NSString stringWithFormat:@"objc_cb_%d", ++uid];
        self.responseCallbacks[callbackId] = responseCallback;
        message[@"callbackId"] = callbackId;
    }

    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

- (void)_queueMessage:(NSDictionary *)message {
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    } else {
        [self _dispatchMessage:message];
    }
}

- (void)_dispatchMessage:(NSDictionary *)message {
    NSString *messageJSON = [self _serializeMessage:message];
    [self _log:@"sending" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    if ([[NSThread currentThread] isMainThread]) {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", messageJSON]];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", messageJSON]];
        });
    }
}

- (void)_flushMessageQueue {
    NSString *messageQueueString = [_webView stringByEvaluatingJavaScriptFromString:@"WebViewJavascriptBridge._fetchQueue();"];
    NSArray *messages = [messageQueueString componentsSeparatedByString:MESSAGE_SEPARATOR];
    for (NSString *messageJSON in messages) {
        [self _log:@"receivd" json:messageJSON];

        NSDictionary *message = [self _deserializeMessageJSON:messageJSON];

        NSString *responseId = message[@"responseId"];
        if (responseId) {
            WVJBResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [_responseCallbacks removeObjectForKey:responseId];
        } else {
            WVJBResponseCallback responseCallback = NULL;
            __block NSString *callbackId = message[@"callbackId"];
            responseCallback = callbackId ? ^(id responseData) {
                NSDictionary *message2 = @{@"responseId" : callbackId, @"responseData" : responseData};
                [self _queueMessage:message2];
            } : ^(id ignoreResponseData) {
                // Do nothing
            };

            WVJBHandler handler;
            if (message[@"handlerName"]) {
                handler = _messageHandlers[message[@"handlerName"]];
                if (!handler) {return NSLog(@"WVJB Warning: No handler for %@", message[@"handlerName"]);}
            } else {
                handler = self.messageHandler;
            }

            @try {
                NSDictionary *data = message[@"data"];
                if (!data || ((id) data) == [NSNull null]) {data = [NSDictionary dictionary];}
                handler(data, responseCallback);
            }
            @catch (NSException *exception) {
                NSLog(@"WebViewJavascriptBridge: WARNING: objc handler threw. %@ %@", message, exception);
            }
        }
    }
}

- (NSString *)_serializeMessage:(NSDictionary *)message {
    return [message JSONString:NO];
}

- (NSDictionary *)_deserializeMessageJSON:(NSString *)messageJSON {
    return [messageJSON JSONValue];
}

- (void)_log:(NSString *)action json:(NSString *)json {
    if (!logging) {return;}
    if (json.length > 500) {
        NSLog(@"WVJB %@: %@", action, [[json substringToIndex:500] stringByAppendingString:@" [...]"]);
    } else {
        NSLog(@"WVJB %@: %@", action, json);
    }
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != _webView) {return;}

    if (![[_webView stringByEvaluatingJavaScriptFromString:@"typeof WebViewJavascriptBridge == 'object'"] isEqualToString:@"true"]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"WebViewJavascriptBridge.js" ofType:@"txt"];
        NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [_webView stringByEvaluatingJavaScriptFromString:js];
    }

    if (self.startupMessageQueue) {
        for (id queuedMessage in self.startupMessageQueue) {
            [self _dispatchMessage:queuedMessage];
        }
        self.startupMessageQueue = nil;
    }

    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != _webView) {return;}
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.webViewDelegate webView:_webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _webView) {return YES;}
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:CUSTOM_PROTOCOL_SCHEME]) {
        if ([[url host] isEqualToString:QUEUE_HAS_MESSAGE]) {
            [self _flushMessageQueue];
        } else {
            NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@://%@", CUSTOM_PROTOCOL_SCHEME, [url path]);
        }
        return NO;
    } else if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    } else {
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != _webView) {return;}
    if (self.webViewDelegate && [self.webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.webViewDelegate webViewDidStartLoad:webView];
    }
}

@end
