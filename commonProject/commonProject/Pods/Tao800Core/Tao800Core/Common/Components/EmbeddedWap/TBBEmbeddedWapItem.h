//
//  TBBDealDetailJavascriptBridgeItem.h
//  universalT800
//
//  Created by Rose on 13-9-27.
//  Copyright (c) 2013年 enfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBBEmbeddedWapItem : NSObject<UIWebViewDelegate>
@property(nonatomic, copy) NSString *htmlText;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) int height;
@property(nonatomic, assign) int tag;
@property(nonatomic, assign) BOOL refreshFlag;
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic) BOOL embeddedFlag;
@end
