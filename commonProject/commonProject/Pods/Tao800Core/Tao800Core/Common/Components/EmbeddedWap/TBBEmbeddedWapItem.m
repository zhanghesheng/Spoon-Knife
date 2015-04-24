//
//  TBBDealDetailJavascriptBridgeItem.m
//  universalT800
//
//  Created by Rose on 13-9-27.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import "TBBEmbeddedWapItem.h"
#import "TBCore/TBCore.h"
#import "TBUI/WebViewJavascriptBridge.h"

@interface TBBEmbeddedWapItem()
@property(nonatomic, strong)WebViewJavascriptBridge *javascriptBridge;
@end

@implementation TBBEmbeddedWapItem

- (id)init{
    self = [super init];
    if (self) {
        _tag = 0;
        _height = 1;
        _refreshFlag = YES;
        
        float widthScreen = [UIScreen mainScreen].bounds.size.width -40;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, widthScreen, self.height)];
        self.webView.userInteractionEnabled = NO;
        self.webView.scalesPageToFit = YES;
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView
                                                      webViewDelegate:self
                                                              handler:^(id data, WVJBResponseCallback responseCallback) {
                                                                  NSLog(@"ObjC received message from JS: %@", data);
                                                                  responseCallback(@"Response for message from ObjC");
                                                              }];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"modifyImageWidth.js" ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_webView stringByEvaluatingJavaScriptFromString:js];
    
    NSString *widthStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"];
    NSString *heightStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    
    int width = [widthStr intValue];
    int height = [heightStr intValue];
    
    //NSLog(@"=====width=%@  height=%@=====", widthStr, heightStr);

    //修改服务器页面的meta的值
    if (![self.htmlText isEqualToString:@"暂无数据"]) {
//        NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].dealContent = \"width=%f, initial-scale=1.0, minimum-scale=1.0, user-scalable=yes\"",
//                          self.webView.frame.size.width];
//        [webView stringByEvaluatingJavaScriptFromString:meta];
//        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//        height = [str integerValue];
        height = height*self.webView.frame.size.width/width;
    }
    
    if (height - self.height < 3 || !self.refreshFlag) {
        //避免页面高度反复变化导致页面的反复刷新
        return;
    }
    
    self.height = height;
    self.refreshFlag = NO;
    
    CGRect rect = self.webView.frame;
    rect.size.height = height;
    self.webView.frame = rect;
    
    if (![self.htmlText isEqualToString:@"暂无数据"]) {
        self.refreshFlag = NO;

        self.webView.scalesPageToFit = YES;
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    } else {
        self.webView.scalesPageToFit = NO;
        self.webView.autoresizingMask = UIViewAutoresizingNone;
    }
    
    //NSLog(@"-------------document.body.scrollHeight------------");
    //NSLog(@"height2 = %d",height);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void)setHtmlText:(NSString *)htmlText{
    _htmlText = [htmlText copy];
    NSString *string = [NSString stringWithFormat:@"<div style=\"color:#686868;font-size:40px\">%@</div>", _htmlText]; //FormatHtmlText(dict);
    [self.webView loadHTMLString:string baseURL:nil];
}

@end
